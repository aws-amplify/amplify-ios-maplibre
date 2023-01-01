## AmplifyMapLibreAdapter for iOS

The AmplifyMapLibreAdapter is a library that combines the Amplify Geo category and the MapLibre SDK.

- Registers a custom URL protocol with MapLibre that intercepts and signs calls to AWS Location endpoints. This registration occurs automatically the first time AmplifyMapLibreAdapter is used to create a map.

- Brokers communication between Amplify and MapLibre by providing functions and extensions that simplify using Amplify Geo with MapLibre.

- Provide SwiftUI support for MapLibre that adds `AMLMapView` (Amplify MapLibre MapView) and `AMLMapCompositeView` Views around MapLibre's MGLMapView. This introduces SwiftUI support to the MapLibre SDK for iOS. It provides a subset of MGLMapView functionality that can be used for displaying and interacting with a map; providing APIs to track state changes, inject custom implementations for user interaction, and define settings.

## Usage

[Getting Started Guide](https://docs.amplify.aws/lib/geo/getting-started/q/platform/ios/)

[API Documentation](https://aws-amplify.github.io/amplify-ios-maplibre/docs/)

[Examples](Examples/AMLExamples/README.md)

## Platform Support

AmplifyMapLibreAdapter supports iOS 13 and above.

## Installation

### Swift Package Manager

Swift Pacakge Manager is distributed with Xcode. To add AmplifyMapLibreAdapter to your iOS project, take the following steps: 
1. Open your project in Xcode.
2. Select your application in the **Project Navigator**.
3. Select your project in the **Project List** pane.
4. Select **Package Dependencies**.
5. Click the + (plus) button.
6. Enter the AmplifyMapLibreAdapter GitHub repo URL (`https://github.com/aws-amplify/amplify-ios-maplibre`) in the search bar labeled **Search or Enter Package URL**.
7. Click **Add Package** and select your desired **Dependency Rule**
8. Select the targets you would like to add.
    - **AmplifyMapLibreAdapter** will allow you to create a `MGLMapView` configured to work with Amplify Geo.
    - **AmplifyMapLibreUI** provides SwiftUI Map Views, `AMLMapView` and `AMLMapCompositeView`. Additionally, it also provides other map related UI components with applicable functionality, such as a `AMLSearchBar`, `AMLPlaceList`, `AMLMapControlView`, and more. All of which seamlessly integrate with Amplify Geo.

## Reporting Bugs/Feature Requests

We welcome you to use the GitHub issue tracker to report bugs or suggest features.

When filing an issue, please check [exisiting open](https://github.com/aws-amplify/amplify-ios-maplibre/issues), or [recently closed](https://github.com/aws-amplify/amplify-ios-maplibre/issues?utf8=%E2%9C%93&q=is%3Aissue%20is%3Aclosed%20), issues to make sure somebody else hasn't already reported the issue. Please try to include as much information as you can. Details like these are incredibly useful:

* Expected behavior and observed behavior.
* A reproducible test case or series of steps.
* The version of our code being used.
* Any modications you've made relecant to the bug.
* Anything custom about your environment or deployment.
* Stack Trace in text form (if applicable).

## Open Source Contributions

We welcome and and all contributions from the community! Make sure you read through our contribution guide [here](https://github.com/aws-amplify/amplify-ios-maplibre/blob/main/CONTRIBUTING.md) before submitting any PR's.

## Security

See [CONTRIBUTING](https://github.com/aws-amplify/amplify-ios-maplibre/blob/main/CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This project is licensed under the Apache-2.0 License.
test
