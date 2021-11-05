//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public enum AWSMapURLProtocolError: Error {
    case configurationError
    case missingRegion
    case signatureError
    case unexpectedNil
}

extension AWSMapURLProtocolError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .configurationError:
            let message = """
                           Failed to read the service configuration for AWSLocationGeoPlugin.
                           Make sure Amplify Geo is properly configured in your project.
                           """
            return NSLocalizedString(message, comment: "")
        case .missingRegion:
            let message = """
                           Region is missing from AWSLocationGeoPlugin configuration.
                           This should not happen. Check your project configuration.
                           """
            return NSLocalizedString(message, comment: "")
        case .signatureError:
            let message = """
                           Failed to sign URL request.
                           This should not happen. Check your project configuration.
                           """
            return NSLocalizedString(message, comment: "")
        case .unexpectedNil:
            let message = """
                           Unexpectedly encounted a nil value while building a canonical request.
                           This should not happen. Check your project configuration.
                           """
            return NSLocalizedString(message, comment: "")
        }
    }
}
