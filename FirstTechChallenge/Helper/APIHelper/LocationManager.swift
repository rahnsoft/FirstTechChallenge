//
//  LocationManager.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 01/11/2021.
//

import CoreLocation
import Foundation
import MapKit
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    var latitude: Double = 0
    var longitude: Double = 0

    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            longitude = location.coordinate.longitude
            latitude = location.coordinate.latitude
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
