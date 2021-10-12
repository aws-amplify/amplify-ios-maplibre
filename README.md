# AmplifyMapLibreAdapter

The AmplifyMapLibreAdapter is a thin shim that sits between the Amplify Geo category and the MapLibre SDK.

- Registers a custom URL protocol with MapLibre that intercepts and signs calls to AWS Location endpoints. This registration occers automatically the first time AmplifyMapLibreAdapter is used to create a map.

- Brokers communication between Amplify and MapLibre by providing functions and extensions that simplify using Amplify Geo with MapLibre.

- Provides a SwiftUI wrapper called AMLMapView (Amplify MapLibre MapView) around MapLibre's MGLMapView. This introduces SwiftUI support to the MapLibre SDK for iOS. It provides a limited subset of MGLMapView functionality that can be used for displaying a map.

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This project is licensed under the Apache-2.0 License.
