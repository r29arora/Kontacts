//
//  LocationManager.swift
//  Contacts
//
//  Created by Rajul Arora on 2015-09-19.
//  Copyright © 2015 Rajul Arora. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let manager = LocationManager()

    let locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.delegate = self

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print("\(newLocation)")
    }
}

// MARK: - Public Methods

extension LocationManager {
    func requestAccess() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
}