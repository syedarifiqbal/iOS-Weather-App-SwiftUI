//
//  LocationAccessManager.swift
//  SwiftUI Weather App
//
//  Created by Arif Iqbal on 20/09/2023.
//

import SwiftUI
import CoreLocation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var cityName: String = ""

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        let geoCoder = CLGeocoder()
        let locationToGeocode = CLLocation(latitude: latitude, longitude: longitude)
        
        geoCoder.reverseGeocodeLocation(locationToGeocode) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                var formattedCityName = ""
                if let city = placemark.locality {
                    formattedCityName = city
                }
                if let countryCode = placemark.isoCountryCode {
                    if !formattedCityName.isEmpty {
                        formattedCityName += ", "
                    }
                    formattedCityName += countryCode
                }
                self.cityName = formattedCityName
            }
        }
    }
}
