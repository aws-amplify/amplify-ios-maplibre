//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Mapbox
import Amplify

public extension MGLPointFeature {
    /// Initialize an MGLPointFeature with the title and coordinates of a given Geo.Place
    /// - Parameter place: The Geo.Place from which to initialize the MGLPointFeature.
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

// MARK: MGLPointFeature+Geo.Place property
public extension MGLPointFeature {
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
        case \.street: return "aml_geo.place_street"
        case \.addressNumber: return "aml_geo.place_addressNumber"
        case \.label: return "aml_geo.place_label"
        case \.country: return "aml_geo.place_country"
        case \.municipality: return "aml_geo.place_municipality"
        case \.neighborhood: return "aml_geo.place_neighborhood"
        case \.postalCode: return "aml_geo.place_postalCode"
        case \.region: return "aml_geo.place_region"
        case \.subRegion: return "aml_geo.place_subRegion"
        default: return "aml_geo.place_default"
        }
    }

    subscript<T>(_ placeKeyPath: KeyPath<Geo.Place, T>) -> T? {
        get {
            if placeKeyPath ~= \.coordinates {
                return getCoordinate() as? T
            }
            let key = placeKey(for: placeKeyPath)
            return self[key] as? T
        }
        set {
            if placeKeyPath ~= \.coordinates {
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
