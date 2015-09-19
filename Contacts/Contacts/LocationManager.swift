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
    struct Constants {
        static let fireBaseUrl = "https://kontact.firebaseio.com/"
    }
    
    static let manager = LocationManager()

    let locationManager = CLLocationManager()
    
    let geoFireRef:Firebase
    let geoFire:GeoFire
    
    var userID: String?

    override init() {
        self.geoFireRef = Firebase(url: Constants.fireBaseUrl)
        self.geoFire = GeoFire(firebaseRef: self.geoFireRef)

        super.init()
        self.locationManager.delegate = self
        
        let userID = NSUUID().UUIDString
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(userID, forKey: "user_id")
        self.userID = userID
        self.startUpdating()
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
        NSLog("%@", newLocation)
        
        if let userID = self.userID {
            self.geoFire.setLocation(newLocation, forKey: userID)
        } else {
            NSLog("should never happen")
        }
    }
}

// MARK: - Public Methods

extension LocationManager {
    func requestAccess() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
    }

    func removeUser() {
        if let userID = self.userID {
            self.locationManager.stopUpdatingLocation()
            self.geoFire.removeKey(userID)
        }
    }

    func startUpdating() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
        }
    }
}