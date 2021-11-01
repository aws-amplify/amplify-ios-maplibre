//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import AWSCore
import Amplify
import AWSLocationGeoPlugin
import Foundation

class AWSMapURLProtocol: URLProtocol {
    private var urlSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private static var globallyRegistered = false
    private static var regionName: String?
    private static var credentialsProvider: AWSCredentialsProvider?
    private static var hostName: String?

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

    private static func getGeoConfig() {
        guard let plugin = try? Amplify.Geo.getPlugin(for: "awsLocationGeoPlugin") as? AWSLocationGeoPlugin else {
            assertionFailure(AWSMapURLProtocolError.configurationError.localizedDescription)
            return
        }
        credentialsProvider = plugin.authService.getCredentialsProvider()
        regionName = plugin.pluginConfig.regionName
        guard let regionName = regionName else {
            assertionFailure(AWSMapURLProtocolError.missingRegion.localizedDescription)
            return
        }
        hostName = "maps.geo.\(regionName).amazonaws.com"
    }

    override class func canInit(with request: URLRequest) -> Bool {
        canInit(request.url?.host)
    }

    override class func canInit(with task: URLSessionTask) -> Bool {
        canInit(task.currentRequest?.url?.host)
    }

    private static func canInit(_ host: String?) -> Bool {
        // Attempt to get credentialsProvider and regionName for AWSLocationGeoPlugin if not already present.
        if credentialsProvider == nil || regionName == nil || hostName == nil {
            getGeoConfig()
        }
        return host == hostName
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        signRequest { result in
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
              let credentialsProvider = AWSMapURLProtocol.credentialsProvider,
              let regionName = AWSMapURLProtocol.regionName
        else {
            completionHandler(.failure(AWSMapURLProtocolError.unexpectedNil))
            return
        }

        var signedRequest = request

        signedRequest.url = originalURLComponents.url
        signedRequest.addValue(host, forHTTPHeaderField: "host")

        AWSSignatureV4Signer.sigV4SignedURL(with: signedRequest,
                                            credentialProvider: credentialsProvider,
                                            regionName: regionName,
                                            serviceName: "geo",
                                            date: Date(),
                                            expireDuration: 60,
                                            signBody: true,
                                            signSessionToken: true).continueWith { task in

            if let url = task.result as URL? {
                signedRequest.url = url
                completionHandler(.success(signedRequest))
            } else if let error = task.error {
                completionHandler(.failure(error))
            } else {
                completionHandler(.failure(AWSMapURLProtocolError.signatureError))
            }
            return nil
        }
    }

    private func handleRequest(_ request: URLRequest) {
        dataTask = urlSession.dataTask(with: request) { data, response, error in
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
