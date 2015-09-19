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
        static let distanceThreshold = 2.0
    }
    
    static let manager = LocationManager()

    let locationManager = CLLocationManager()
    
    let fireBaseRef:Firebase
    let userBaseRef: Firebase
    let geoFire:GeoFire
    
    var userID: String?
    var myLoc: CLLocation
    

    override init() {
        self.fireBaseRef = Firebase(url: fireBaseUrl)
        self.userBaseRef = self.fireBaseRef.childByAppendingPath("user")
        self.geoFire = GeoFire(firebaseRef: self.fireBaseRef.childByAppendingPath("location"))
        self.myLoc = CLLocation()
        
        super.init()
        self.locationManager.delegate = self
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        self.userID = userDefaults.stringForKey(kUserIDKey)
        self.startUpdating()
        
        self.userBaseRef.childByAppendingPath(self.userID).setValue(["firstName":"foo", "lastName":"bar"])
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
        
        if (self.myLoc.distanceFromLocation(newLocation) < 2.0) { return }
        
        if let userID = self.userID {
            NSLog("updated location")
            self.myLoc = newLocation;
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