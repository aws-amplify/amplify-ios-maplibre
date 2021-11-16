//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify
import AWSLocationGeoPlugin
import Mapbox
import AmplifyMapLibreAdapter

public struct MapCreationStateMachine {
    private(set) var state: State
    
    enum State {
        case begin
        case loading
        case complete(MGLMapView)
        case error(Geo.Error)
    }

//    mutating func transition(input: Result<MGLMapView, Geo.Error>, with options: AMLMapView.Options, proxyDelegate: MGLMapViewRepresentable.ProxyDelegate) {
//        switch input {
//        case .success(let mapView): state = .complete(
//            MGLMapViewRepresentable(
//                mapView: mapView,
//                zoomLevel: options.$zoomLevel,
//                bounds: options.$bounds,
//                center: options.$center,
//                heading: options.$heading,
//                userLocation: options.$userLocation,
//                features: options.$features,
//                attribution: options.$attribution,
//                clusteringBehavior: options.clusteringBehavior,
//                proxyDelegate: proxyDelegate
//            )
//        )
//        case .failure(let error): state = .error(error)
//        }
//    }
    
    mutating func transition(input: Result<MGLMapView, Geo.Error>) {
        switch input {
        case .success(let mapView): state = .complete(mapView)
        case .failure(let error): state = .error(error)
        }
    }
}

public class AMLMapViewModel: ObservableObject {
    @Published public var mapLoadingState: MapCreationStateMachine = .init(state: .begin)
    @Published public var bounds: MGLCoordinateBounds// = MGLCoordinateBounds()
    @Published public var zoomLevel: Double// = 14
    @Published public var heading: CLLocationDirection// = 0
    @Published public var searchText: String// = ""
    @Published public var center: CLLocationCoordinate2D
    @Published public var showUserLocation: Bool
    @Published public var minZoomLevel: Double
    @Published public var maxZoomLevel: Double
    @Published public var hideAttributionButton = false
    @Published public var compassPosition: MGLOrnamentPosition = .bottomLeft
    @Published public var features: [MGLPointFeature] = []
    let clusteringBehavior: AMLMapView.ClusteringBehavior = .init()
    
    public init(
        heading: CLLocationDirection = 0,
        zoomLevel: Double = 14,
        bounds: MGLCoordinateBounds = .init(),
        center: CLLocationCoordinate2D = .init(),
        searchText: String = "",
        showUserLocation: Bool = false,
        minZoomLevel: Double = 0,
        maxZoomLevel: Double = 22,
        hideAttributionButton: Bool = false,
        compassPosition: MGLOrnamentPosition = .bottomLeft,
        clusteringBehavior: AMLMapView.ClusteringBehavior = .init()
    ) {
        self.heading = heading
        self.zoomLevel = zoomLevel
        self.bounds = bounds
        self.center = center
        self.searchText = searchText
        self.showUserLocation = showUserLocation
        self.minZoomLevel = minZoomLevel
        self.maxZoomLevel = maxZoomLevel
        self.hideAttributionButton = hideAttributionButton
        self.compassPosition = compassPosition
    }
    
    var annotationImage: UIImage = UIImage.init(
        named: "AMLAnnotationView",
        in: Bundle.module,
        compatibleWith: nil
    )!
    
    var featureTapped: ((MGLMapView, MGLPointFeature) -> Void) = { mapView, pointFeature in
        
        mapView.setCenter(
            pointFeature.coordinate,
            zoomLevel: max(15, mapView.zoomLevel),
            direction: mapView.camera.heading,
            animated: true
        )
        
        let point = mapView.convert(pointFeature.coordinate, toPointTo: mapView)
        let width = min(UIScreen.main.bounds.width * 0.8, 400)
        let height = width * 0.4
        
        let calloutView = AMLCalloutUIView(
            frame: .init(
                x: mapView.center.x - width / 2,
                y: mapView.center.y - height - 40,
                width: width,
                height: height
            ),
            feature: pointFeature
        )
                    

        /// Add a callout view to the map.
        ///
        /// This method first checks if a callout view is already presented. If so, it removes it before add a new one.
        /// - Parameters:
        ///   - calloutView: The UIView to be presented as a callout view.
        ///   - mapView: The MGLMapView on which the callout view will be presented.
        func addCalloutView(_ calloutView: UIView, to mapView: MGLMapView) {
            if let existingCalloutView = mapView.subviews
                .first(where: { $0.tag == 42 })
            {
                mapView.willRemoveSubview(existingCalloutView)
                existingCalloutView.removeFromSuperview()
            }
            
            calloutView.tag = 42
            mapView.addSubview(calloutView)
        }
        
        addCalloutView(calloutView, to: mapView)
    }
    
    var clusterTapped: ((MGLMapView, MGLPointFeatureCluster) -> Void) = { mapView, cluster in
        mapView.setCenter(
            cluster.coordinate,
            zoomLevel: min(15, mapView.zoomLevel + 2),
            direction: mapView.camera.heading,
            animated: true
        )
    }
}

public class MyViewModel: ObservableObject {
    @Published public var mapLoadingState: MapCreationStateMachine = .init(state: .begin)
    @Published public var bounds = MGLCoordinateBounds()
    @Published public var zoomLevel: Double = 14
    @Published public var heading: CLLocationDirection = 0
    @Published public var displayState = AMLSearchBar.DisplayState.map
    @Published public var searchText = ""
    @Published public var center: CLLocationCoordinate2D = .init(
        latitude: 37.785834,
        longitude: -122.406417
    )
    
    @Published public var showUserLocation: Bool
    @Published public var minZoomLevel: Double
    @Published public var maxZoomLevel: Double
    @Published public var hideAttributionButton = false
    @Published public var compassPosition: MGLOrnamentPosition = .bottomLeft
    @Published public var features: [MGLPointFeature] = []
    let clusteringBehavior: MGLMapViewRepresentable.ClusteringBehavior = .init()
    
    public init(
        
        searchText: String = "",
        center: CLLocationCoordinate2D = .init(),
        showUserLocation: Bool = false,
        minZoomLevel: Double = 0,
        maxZoomLevel: Double = 22,
        hideAttributionButton: Bool = false,
        compassPosition: MGLOrnamentPosition = .bottomLeft
        
    ) {
        self.showUserLocation = showUserLocation
        self.minZoomLevel = minZoomLevel
        self.maxZoomLevel = maxZoomLevel
        self.hideAttributionButton = hideAttributionButton
        self.compassPosition = compassPosition
    }
    
    var annotationImage: UIImage = UIImage.init(
        named: "AMLAnnotationView",
        in: Bundle.module,
        compatibleWith: nil
    )!
    
    var featureTapped: ((MGLMapView, MGLPointFeature) -> Void) = { mapView, pointFeature in
        
        mapView.setCenter(
            pointFeature.coordinate,
            zoomLevel: max(15, mapView.zoomLevel),
            direction: mapView.camera.heading,
            animated: true
        )
        
        let point = mapView.convert(pointFeature.coordinate, toPointTo: mapView)
        let width = min(UIScreen.main.bounds.width * 0.8, 400)
        let height = width * 0.4
        
        let calloutView = AMLCalloutUIView(
            frame: .init(
                x: mapView.center.x - width / 2,
                y: mapView.center.y - height - 40,
                width: width,
                height: height
            ),
            feature: pointFeature
        )
                    

        /// Add a callout view to the map.
        ///
        /// This method first checks if a callout view is already presented. If so, it removes it before add a new one.
        /// - Parameters:
        ///   - calloutView: The UIView to be presented as a callout view.
        ///   - mapView: The MGLMapView on which the callout view will be presented.
        func addCalloutView(_ calloutView: UIView, to mapView: MGLMapView) {
            if let existingCalloutView = mapView.subviews
                .first(where: { $0.tag == 42 })
            {
                mapView.willRemoveSubview(existingCalloutView)
                existingCalloutView.removeFromSuperview()
            }
            
            calloutView.tag = 42
            mapView.addSubview(calloutView)
        }
        
        addCalloutView(calloutView, to: mapView)
    }
    
    var clusterTapped: ((MGLMapView, MGLPointFeatureCluster) -> Void) = { mapView, cluster in
        mapView.setCenter(
            cluster.coordinate,
            zoomLevel: min(15, mapView.zoomLevel + 2),
            direction: mapView.camera.heading,
            animated: true
        )
    }
    

    
    @Published public var places: [Geo.Place] = []

    public func search(
        _ text: String,
        area: Geo.SearchArea
    ) {
        Amplify.Geo.search(for: text, options: .init(area: area)) { [weak self] result in
            switch result {
            case.success(let places):
                DispatchQueue.main.async {
                    self?.places = places
                    
                    self?.features = AmplifyMapLibre.createFeatures(places)
//                    { place -> MGLPointFeature in
//                        let feature = MGLPointFeature()
//                        feature.coordinate = CLLocationCoordinate2D(place.coordinates)
//
//                        feature.attributes["label"] = place.labelLine
//                        feature.attributes["addressLineOne"] = place.streetLabelLine
//                        feature.attributes["addressLineTwo"] = place.cityLabelLine
//                        return feature
//                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}



public struct AMLMapView: View {
//    var mapViewRepresenter: MGLMapViewRepresentable?
//    var mapResult: Result<MGLMapView, Geo.Error>?
    @Binding var mapView: MGLMapView?
//    var proxyDelegate = MGLMapViewRepresentable.ProxyDelegate.init()
    
//    @State var mapCreationStateMachine = MapCreationStateMachine(state: .begin)
    
//    public init(
//        mapView: Binding<MGLMapView?> = .constant(nil),
//        zoomLevel: Binding<Double> = .constant(14),
//        bounds: Binding<MGLCoordinateBounds> = .constant(MGLCoordinateBounds()),
//        center: Binding<CLLocationCoordinate2D> = .constant(CLLocationCoordinate2D()),
//        heading: Binding<CLLocationDirection> = .constant(0),
//        userLocation: Binding<CLLocationCoordinate2D?> = .constant(nil),
//        features: Binding<[MGLPointFeature]> = .constant([]),
//        attribution: Binding<String?> = .constant(nil),
//        clusteringBehavior: MGLMapViewRepresentable.ClusteringBehavior = .init()
//    ) {
//        _mapView = mapView
//        self.options = .init()
//        if let mapView = mapView.wrappedValue {
//            mapCreationStateMachine = MapCreationStateMachine(
//                state: .complete(
//                    MGLMapViewRepresentable(
//                        mapView: mapView,
//                        zoomLevel: zoomLevel,
//                        bounds: bounds,
//                        center: center,
//                        heading: heading,
//                        userLocation: userLocation,
//                        features: features,
//                        attribution: attribution,
//                        clusteringBehavior: clusteringBehavior,
//                        proxyDelegate: self.proxyDelegate
//                    )
//                )
//            )
//        }
//    }
    
    @ObservedObject var viewModel: MyViewModel
    
    public init(
        mapView: Binding<MGLMapView?> = .constant(nil),
        viewModel: MyViewModel
    ) {
        _mapView = mapView
        self.viewModel = viewModel
    }
    
//    public init(
//        options: Options
//    ) {
//        _mapView = options.$mapView
//
//        if let mapView = options.mapView {
//            mapCreationStateMachine = MapCreationStateMachine(
//                state: .complete(
//                    MGLMapViewRepresentable(
//                        mapView: mapView,
//                        zoomLevel: options.$zoomLevel,
//                        bounds: options.$bounds,
//                        center: options.$center,
//                        heading: options.$heading,
//                        userLocation: options.$userLocation,
//                        features: options.$features,
//                        attribution: options.$attribution,
//                        clusteringBehavior: options.clusteringBehavior,
//                        proxyDelegate: proxyDelegate
//                    )
//                )
//            )
//        }
//    }
    
//    @Binding var options: Options
    
    public var body: some View {
        switch viewModel.mapLoadingState.state {
        case .complete(let mapView):
            MGLMapViewRepresentable(mapView: mapView, viewModel: viewModel)
                .showUserLocation(viewModel.showUserLocation)
                .compassPosition(viewModel.compassPosition)
                .minZoomLevel(viewModel.minZoomLevel)
                .maxZoomLevel(viewModel.maxZoomLevel)
//                .featureClusterTapped(viewModel.clusterTapped)
//                .featureTapped(viewModel.featureTapped)
        case .error(let error):
            Text("Error loading view: \(error.localizedDescription)")
        case .loading:
            AMLActivityIndicator()
        case .begin:
            AMLActivityIndicator()
                .onAppear {
                    AmplifyMapLibre.createMap {
                        viewModel.mapLoadingState.transition(input: $0)
                        
//                        mapCreationStateMachine.transition(
//                            input: $0,
//                            with: options,
//                            proxyDelegate: proxyDelegate
//                        )
                    }
                }
        }
            
    }
    
}

extension AMLMapView {
    public struct Options {
        @Binding var mapView: MGLMapView?
        @Binding var zoomLevel: Double
        @Binding var bounds: MGLCoordinateBounds
        @Binding var center: CLLocationCoordinate2D
        @Binding var heading: CLLocationDirection
        @Binding var userLocation: CLLocationCoordinate2D?
        @Binding var features: [MGLPointFeature]
        @Binding var attribution: String?
        let clusteringBehavior: MGLMapViewRepresentable.ClusteringBehavior
        
        public init(
            mapView: Binding<MGLMapView?> = .constant(nil),
            zoomLevel: Binding<Double> = .constant(14),
            bounds: Binding<MGLCoordinateBounds> = .constant(MGLCoordinateBounds()),
            center: Binding<CLLocationCoordinate2D> = .constant(CLLocationCoordinate2D()),
            heading: Binding<CLLocationDirection> = .constant(0),
            userLocation: Binding<CLLocationCoordinate2D?> = .constant(nil),
            features: Binding<[MGLPointFeature]> = .constant([]),
            attribution: Binding<String?> = .constant(nil),
            clusteringBehavior: MGLMapViewRepresentable.ClusteringBehavior = .init()
        ) {
            _mapView = mapView
            _zoomLevel = zoomLevel
            _bounds = bounds
            _center = center
            _heading = heading
            _userLocation = userLocation
            _features = features
            _attribution = attribution
            self.clusteringBehavior = clusteringBehavior
        }
    }

}
    
    
//    /// Underlying MGLMapView.
//    let mapView: MGLMapView
//    /// Current zoom level of the map
//    @Binding var zoomLevel: Double
//    /// The coordinate bounds of the currently displayed area of the map.
//    @Binding var bounds: MGLCoordinateBounds
//    /// The center coordinates of the currently displayed area of the map.
//    @Binding var center: CLLocationCoordinate2D
//    /// The current heading of the map in degrees.
//    @Binding var heading: CLLocationDirection
//    /// The user's current location.
//    @Binding var userLocation: CLLocationCoordinate2D?
//    /// Features that are displayed on the map.
//    @Binding var features: [MGLPointFeature]
//    /// The attribution string for the map data providers.
//    @Binding var attribution: String?
//    /// The clustering behavior of the map.
//    let clusteringBehavior: ClusteringBehavior

    /// Initialize an instance of AMLMapView.
    ///
    /// A SwiftUI wrapper View around MGLMapView
    /// - Parameters:
    ///   - mapView: The underlying MGLMapView.
    ///   - zoomLevel: Current zoom level of the map. Default 14
    ///   - bounds: The coordinate bounds of the currently displayed area of the map.
    ///   - center: The center coordinates of the currently displayed area of the map.
    ///   - userLocation: The user's current location. If this value exists, it will set `mapView.showsUserLocation` to true. (optional). __Setting this to true will prompt the user for location permission__
    ///   - annotations: Binding of annotations displayed on the map.
    ///   - attribution: The attribution string for the map data providers.
//    public init(
//        mapView: MGLMapView,
//        zoomLevel: Binding<Double> = .constant(14),
//        bounds: Binding<MGLCoordinateBounds> = .constant(MGLCoordinateBounds()),
//        center: Binding<CLLocationCoordinate2D> = .constant(CLLocationCoordinate2D()),
//        heading: Binding<CLLocationDirection> = .constant(0),
//        userLocation: Binding<CLLocationCoordinate2D?> = .constant(nil),
//        features: Binding<[MGLPointFeature]> = .constant([]),
//        attribution: Binding<String?> = .constant(nil),
//        clusteringBehavior: ClusteringBehavior = .init()
//    ) {
//        self.clusteringBehavior = clusteringBehavior
//        self.mapView = mapView
//        _bounds = bounds
//        _center = center
//        _userLocation = userLocation
//        _attribution = attribution
//        _zoomLevel = zoomLevel
//        _features = features
//        _heading = heading
//        self.mapView.centerCoordinate = center.wrappedValue
//        self.mapView.zoomLevel = zoomLevel.wrappedValue
//        self.mapView.logoView.isHidden = true
//        self.mapView.showsUserLocation = userLocation.wrappedValue != nil
//    }
//}

/// SwiftUI Wrapper for MGLMapView.
//public struct AMLMapView: UIViewRepresentable {
//    /// Underlying MGLMapView.
//    let mapView: MGLMapView
//    /// Current zoom level of the map
//    @Binding var zoomLevel: Double
//    /// The coordinate bounds of the currently displayed area of the map.
//    @Binding var bounds: MGLCoordinateBounds
//    /// The center coordinates of the currently displayed area of the map.
//    @Binding var center: CLLocationCoordinate2D
//    /// The current heading of the map in degrees.
//    @Binding var heading: CLLocationDirection
//    /// The user's current location.
//    @Binding var userLocation: CLLocationCoordinate2D?
//    /// Features that are displayed on the map.
//    @Binding var features: [MGLPointFeature]
//    /// The attribution string for the map data providers.
//    @Binding var attribution: String?
//    /// The clustering behavior of the map.
//    let clusteringBehavior: ClusteringBehavior
//
//    /// Initialize an instance of AMLMapView.
//    ///
//    /// A SwiftUI wrapper View around MGLMapView
//    /// - Parameters:
//    ///   - mapView: The underlying MGLMapView.
//    ///   - zoomLevel: Current zoom level of the map. Default 14
//    ///   - bounds: The coordinate bounds of the currently displayed area of the map.
//    ///   - center: The center coordinates of the currently displayed area of the map.
//    ///   - userLocation: The user's current location. If this value exists, it will set `mapView.showsUserLocation` to true. (optional). __Setting this to true will prompt the user for location permission__
//    ///   - annotations: Binding of annotations displayed on the map.
//    ///   - attribution: The attribution string for the map data providers.
//    public init(
//        mapView: MGLMapView,
//        zoomLevel: Binding<Double> = .constant(14),
//        bounds: Binding<MGLCoordinateBounds> = .constant(MGLCoordinateBounds()),
//        center: Binding<CLLocationCoordinate2D> = .constant(CLLocationCoordinate2D()),
//        heading: Binding<CLLocationDirection> = .constant(0),
//        userLocation: Binding<CLLocationCoordinate2D?> = .constant(nil),
//        features: Binding<[MGLPointFeature]> = .constant([]),
//        attribution: Binding<String?> = .constant(nil),
//        clusteringBehavior: ClusteringBehavior = .init()
//    ) {
//        self.clusteringBehavior = clusteringBehavior
//        self.mapView = mapView
//        _bounds = bounds
//        _center = center
//        _userLocation = userLocation
//        _attribution = attribution
//        _zoomLevel = zoomLevel
//        _features = features
//        _heading = heading
//        self.mapView.centerCoordinate = center.wrappedValue
//        self.mapView.zoomLevel = zoomLevel.wrappedValue
//        self.mapView.logoView.isHidden = true
//        self.mapView.showsUserLocation = userLocation.wrappedValue != nil
//    }
//
//    public func makeUIView(context: UIViewRepresentableContext<AMLMapView>) -> MGLMapView {
//        mapView.delegate = context.coordinator
//        return mapView
//    }
//
//    public func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<AMLMapView>) {
//        if uiView.zoomLevel != zoomLevel {
//            uiView.setZoomLevel(zoomLevel, animated: true)
//        }
//
//        if uiView.camera.heading != heading {
//            let camera = uiView.camera
//            camera.heading = heading
//            uiView.setCamera(camera, animated: true)
//        }
//
//        if let clusterSource = mapView.style?.source(withIdentifier: "aml_location_source") as? MGLShapeSource {
//            clusterSource.shape = MGLShapeCollectionFeature.init(shapes: features)
//        }
//    }
//
//    public func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    let proxyDelegate: ProxyDelegate = .init()
//}


//class AMLMapViewModel: ObservableObject {
//    internal init(clusteringBehavior: MGLMapViewRepresentable.ClusteringBehavior) {
//        self.clusteringBehavior = clusteringBehavior
//    }
//
//
//    @Published var zoomLevel: Double
//    @Published var bounds: MGLCoordinateBounds
//    @Published var center: CLLocationCoordinate2D
//    @Published var heading: CLLocationDirection
//    @Published var userLocation: CLLocationCoordinate2D?
//    @Published var features: [MGLPointFeature]
//    @Published var attribution: String?
//    let clusteringBehavior: MGLMapViewRepresentable.ClusteringBehavior
//
//    public init(
//        zoomLevel: Binding<Double> = .constant(14),
////        bounds: Binding<MGLCoordinateBounds> = .constant(MGLCoordinateBounds()),
////        center: Binding<CLLocationCoordinate2D> = .constant(CLLocationCoordinate2D()),
////        heading: Binding<CLLocationDirection> = .constant(0),
////        userLocation: Binding<CLLocationCoordinate2D?> = .constant(nil),
////        features: Binding<[MGLPointFeature]> = .constant([]),
////        attribution: Binding<String?> = .constant(nil),
//        clusteringBehavior: MGLMapViewRepresentable.ClusteringBehavior = .init()
//    ) {
//
////        _bounds = bounds
////        _center = center
////        _heading = heading
////        _userLocation = userLocation
////        _features = features
////        _attribution = attribution
//        self.clusteringBehavior = clusteringBehavior
//    }
//}
