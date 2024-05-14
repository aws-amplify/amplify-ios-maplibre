//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import MapLibre
import Amplify

public extension MLNPointFeature {
    /// Initialize an MLNPointFeature with the title and coordinates of a given Geo.Place
    /// - Parameter place: The Geo.Place from which to initialize the MLNPointFeature.
    convenience init(_ place: Geo.Place) {
        self.init()
        title = place.label
        coordinate = CLLocationCoordinate2D(place.coordinates)
        amlGeoPlace = place
        // User friendly display values
        attributes["aml_display_label"] = place.labelLine ?? place.label
        attributes["aml_display_addressLineOne"] = place.streetLabelLine
        attributes["aml_display_addressLineTwo"] = place.cityLabelLine
    }
}

// MARK: MLNPointFeature+Geo.Place property
public extension MLNPointFeature {
    var amlGeoPlace: Geo.Place? {
        get {
            guard let coordinates = attributes[\.coordinates],
                  case let label? = attributes[\.label],
                  case let street? = attributes[\.street],
                  case let addressNumber? = attributes[\.addressNumber],
                  case let municipality? = attributes[\.municipality],
                  case let neighborhood? = attributes[\.neighborhood],
                  case let region? = attributes[\.region],
                  case let subRegion? = attributes[\.subRegion],
                  case let postalCode? = attributes[\.postalCode],
                  case let country? = attributes[\.country]
            else { return nil }

            return Geo.Place(
                coordinates: coordinates,
                label: label,
                addressNumber: addressNumber,
                street: street,
                municipality: municipality,
                neighborhood: neighborhood,
                region: region,
                subRegion: subRegion,
                postalCode: postalCode,
                country: country
            )
        }
        set {
            attributes[\.coordinates] = newValue?.coordinates
            attributes[\.label] = newValue?.label
            attributes[\.street] = newValue?.street
            attributes[\.addressNumber] = newValue?.addressNumber
            attributes[\.municipality] = newValue?.municipality
            attributes[\.neighborhood] = newValue?.neighborhood
            attributes[\.region] = newValue?.region
            attributes[\.subRegion] = newValue?.subRegion
            attributes[\.postalCode] = newValue?.postalCode
            attributes[\.country] = newValue?.country
        }
    }
}

// MARK: Geo.Place user friendly display values
public extension Geo.Place {
    var streetLabelLine: String {
        "\(addressNumber ?? "") \(street ?? "")"
    }

    var cityLabelLine: String {
        "\(municipality ?? ""), \(region ?? "") \(postalCode ?? "")"
    }

    // We should not have to do this string parsing. It's error prone and will lead to issues.
    // Ideally, we'd get just the name returned in a field.
    var labelLine: String? {
        if let placeLabel = label,
           let street = street,
           let streetIndex = label?.range(of: street)?.lowerBound,
           let commaIndex = placeLabel[..<streetIndex].range(of: ",", options: .backwards)?.lowerBound {
            return String(placeLabel[..<commaIndex])
        } else {
            return label
        }
    }
}

// MARK: Fileprivate subscript helpers
fileprivate extension Dictionary where Key == String, Value == Any {
    private func placeKey<T>(for keyPath: KeyPath<Geo.Place, T>) -> String {
        switch keyPath {
        case \Geo.Place.street: return "aml_geo.place_street"
        case \Geo.Place.addressNumber: return "aml_geo.place_addressNumber"
        case \Geo.Place.label: return "aml_geo.place_label"
        case \Geo.Place.country: return "aml_geo.place_country"
        case \Geo.Place.municipality: return "aml_geo.place_municipality"
        case \Geo.Place.neighborhood: return "aml_geo.place_neighborhood"
        case \Geo.Place.postalCode: return "aml_geo.place_postalCode"
        case \Geo.Place.region: return "aml_geo.place_region"
        case \Geo.Place.subRegion: return "aml_geo.place_subRegion"
        default: return "aml_geo.place_default"
        }
    }

    subscript<T>(_ placeKeyPath: KeyPath<Geo.Place, T>) -> T? {
        get {
            if placeKeyPath ~= \Geo.Place.coordinates {
                return getCoordinate() as? T
            }
            let key = placeKey(for: placeKeyPath)
            return self[key] as? T
        }
        set {
            if placeKeyPath ~= \Geo.Place.coordinates {
                setCoordinate(newValue)
                return
            }
            let key = placeKey(for: placeKeyPath)
            self[key] = newValue
        }
    }

    mutating func setCoordinate<T>(_ value: T?) {
        guard let value = value as? Geo.Coordinates else { return }
        let (latKey, lonKey) = coordinateKeys
        self[latKey] = value.latitude
        self[lonKey] = value.longitude
    }

    func getCoordinate() -> Geo.Coordinates? {
        let (latKey, lonKey) = coordinateKeys
        guard let lat = self[latKey] as? Double,
              let lon = self[lonKey] as? Double
        else { return nil }
        return Geo.Coordinates(latitude: lat, longitude: lon)
    }

    private var coordinateKeys: (String, String) {
        ("aml_geo.place_coordinates_lat", "aml_geo.place_coordinates_lon")
    }
}
