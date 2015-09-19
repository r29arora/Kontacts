//
//  LocationManager.swift
//  Contacts
//
//  Created by Rajul Arora on 2015-09-19.
//  Copyright © 2015 Rajul Arora. All rights reserved.
//

import Foundation
import CoreLocation

@objc protocol LocationManagerDelegate {
    func locationManagerUserEnteredRadius(key:String)
    func locationManagerUserExitedRadius(key:String)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    struct Constants {
        static let distanceThreshold = 2.0
    }
    
    weak var delegate:LocationManagerDelegate?
    
    static let manager = LocationManager()

    let locationManager = CLLocationManager()
    
    let fireBaseRef:Firebase
    let geoFire:GeoFire
    
    var userID: String?
    var myLoc: CLLocation
    

    override init() {
        self.fireBaseRef = Firebase(url: fireBaseUrl)
        self.geoFire = GeoFire(firebaseRef: self.fireBaseRef.childByAppendingPath("location"))
        self.myLoc = CLLocation()
        
        super.init()
        self.locationManager.delegate = self
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        self.userID = userDefaults.stringForKey(kUserIDKey)
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
        
        // don't bother updating location if you havent moved
        if (self.myLoc.distanceFromLocation(newLocation) < 2.0) { return }
        
        if let userID = self.userID {
            self.myLoc = newLocation;
            self.geoFire.setLocation(newLocation, forKey: userID)
            self.geoQuery(self.myLoc)
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
    
    func geoQuery(mylocation: CLLocation)
    {
        let center = mylocation
        let circleQuery = geoFire.queryAtLocation(center, withRadius: 0.4)
        
        circleQuery.observeEventType(GFEventTypeKeyEntered, withBlock: { (key: String!, location: CLLocation!) in
            self.delegate?.locationManagerUserEnteredRadius(key)
        })
        
        circleQuery.observeEventType(GFEventTypeKeyExited, withBlock: { (key: String!, location: CLLocation!) in
            self.delegate?.locationManagerUserExitedRadius(key)
        })
 
    }
}