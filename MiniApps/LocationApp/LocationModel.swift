//
//  LocationModel.swift
//  MiniApps
//
//  Created by Валентина Попова on 08.09.2024.
//

import Foundation
import CoreLocation

struct LocationData {
    let city: String
    let date: String
}

final class LocationModel: NSObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var locationUpdateHandler: ((LocationData) -> Void)?
    
    func requestLocationUpdate(completion: @escaping (LocationData) -> Void) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.locationUpdateHandler = completion
    }
    
    private func fetchCity(for location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let placemark = placemarks?.first, let city = placemark.locality {
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.locale = Locale(identifier: "ru_RU")
                let dateString = formatter.string(from: Date())
                let locationData = LocationData(city: city, date: dateString)
                self?.locationUpdateHandler?(locationData)
            }
        }
    }
}

extension LocationModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchCity(for: location)
        }
    }
}
