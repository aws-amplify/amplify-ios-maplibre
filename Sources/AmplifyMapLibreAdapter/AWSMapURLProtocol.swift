//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import ClientRuntime
import AWSClientRuntime
import AwsCommonRuntimeKit
import AWSSDKHTTPAuth
import SmithyHTTPAPI

class AWSMapURLProtocol: URLProtocol {
    private var urlSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private static var globallyRegistered = false
    private static var geoConfig = GeoConfig()
    private static let signer = AWSSigV4Signer()

    /// Register the custom URL Protocol.
    /// - Parameter sessionConfig: Optional URLSessionConfiguration for URLSession you want to proxy.
    class func register(sessionConfig: URLSessionConfiguration? = nil) {
        if let config = sessionConfig {
            // Register with a custom NSURLSession
            config.protocolClasses = [AWSMapURLProtocol.self]
        } else {
            // Register globally.
            if !globallyRegistered {
                URLProtocol.registerClass(AWSMapURLProtocol.self)
                globallyRegistered = true
            }
        }
    }

    override class func canInit(with request: URLRequest) -> Bool {
        canInit(request.url?.host)
    }

    override class func canInit(with task: URLSessionTask) -> Bool {
        canInit(task.currentRequest?.url?.host)
    }

    private static func canInit(_ host: String?) -> Bool {
        return host == geoConfig?.hostName
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        signRequest { [weak self] result in
            guard let self = self else {
                // self is nil when the request has been cancelled.
                // In that case, just return.
                return
            }
            switch result {
            case .success(let signedRequest):
                self.handleRequest(signedRequest)
            case .failure(let error):
                self.notifyClientOfError(error)
            }
        }
    }

    override func stopLoading() {
        dataTask?.cancel()
        dataTask = nil
    }

    private func notifyClientOfError(_ error: Error) {
        client?.urlProtocol(self, didFailWithError: error)
        urlSession.invalidateAndCancel()
        if let error = error as? AWSMapURLProtocolError {
            assertionFailure(error.localizedDescription)
        }
    }

    private func signRequest(completionHandler: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let originalURL = request.url,
              let originalURLComponents = URLComponents(url: originalURL, resolvingAgainstBaseURL: false),
              let host = originalURLComponents.host,
              let geoConfig = AWSMapURLProtocol.geoConfig
        else {
            completionHandler(.failure(AWSMapURLProtocolError.unexpectedNil))
            return
        }

        let requestBuilder = HTTPRequestBuilder()
            .withHost(host)
            .withPath(originalURLComponents.path.urlPercentEncoding(encodeForwardSlash: false))
            .withMethod(.get)
            .withPort(443)
            .withProtocol(.https)
            .withHeader(name: "host", value: host)

        Task {
            var signedRequest = request
            signedRequest.url = originalURLComponents.url
            signedRequest.addValue(host, forHTTPHeaderField: "host")
            guard let url = await Self.signer.sigV4SignedURL(
                requestBuilder: requestBuilder,
                awsCredentialIdentityResolver: geoConfig.identityResolver,
                signingName: "geo",
                signingRegion: geoConfig.regionName,
                date: Date(),
                expiration: 60,
                signingAlgorithm: .sigv4)
            else {
                completionHandler(.failure(AWSMapURLProtocolError.signatureError))
                return
            }
            signedRequest.url = url
            completionHandler(.success(signedRequest))
        }
    }

    private func handleRequest(_ request: URLRequest) {
        dataTask = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {
                // self is nil when the request has been cancelled.
                // In that case, just return.
                return
            }
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
            }
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let error = error {
                self.notifyClientOfError(error)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
        dataTask?.resume()
        // Prevents a retain cycle as `URLSession` strongly references `self` as a delegate
        urlSession.finishTasksAndInvalidate()
    }
}
