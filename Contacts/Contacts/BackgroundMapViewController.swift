//
//  BackgroundMapViewController.swift
//  Contacts
//
//  Created by Rajul Arora on 2015-09-19.
//  Copyright © 2015 Rajul Arora. All rights reserved.
//

class BackgroundMapViewController: UIViewController, MKMapViewDelegate {

    private lazy var mapView: MKMapView = {
        let view = MKMapView(frame: .zero)
        view.showsUserLocation = true
        view.delegate = self
        return view
    }()

    var isAnimated = true
}

// MARK: - UIViewController 

extension BackgroundMapViewController {
    override func loadView() {
        super.loadView()
        self.view.addSubview(self.mapView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.mapView.frame = self.view.bounds
    }
}

// MARK: - MKMapViewDelegate 

extension BackgroundMapViewController {
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = mapView.userLocation.coordinate
        mapRegion.span.longitudeDelta = 0.2
        mapRegion.span.latitudeDelta = 0.2

        mapView.setRegion(mapRegion, animated: self.isAnimated)
    }
}