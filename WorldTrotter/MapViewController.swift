//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Sara Liu on 12/30/21.
//  Copyright © 2021 Sara Liu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // creating a view programmatically by overriding the UIViewController method loadView()
    var mapView: MKMapView!

    // Displaying user's region
    let locationManager = CLLocationManager()
    
    // when the view property is nil and the view controller is asked for its view, then the loadView() method is called
    override func loadView() {
        // create a map view
        mapView = MKMapView()

        // set it as "the" view of this view controller
        view = mapView
        
        // create segmented control programmatically
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        // using anchors to create constraints. Anchors are properties on a view that correspond to attributes of the super view
        // safeAreaLayoutGuide -> alignment rectangle that represents the visible portion of interface
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        // 8 points below the top of the safeAreaLayoutGuide
        
//        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        
        // Every view has a layoutMargins property that denotes the default spacing to use when laying out content
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        
        // programmatically set up constraint using NSLayoutConstraint to relate a layout attribute of one view to the layout attribute of another view using multiplier and constant to define a single constraint
        /*
         // imageView.width = 1.5 * imageView.height + 0.0
         NSLayoutConstraint(item: imageView,
                            attribute: .width,
                            relatedBy: .equal,
                            toItem: imageView,
                            attribute: .height,
                            multiplier: 1.5,
                            constant: 0.0)
         */
        
        // activate constraints
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // attaching a target-action pair to the segmented control, associating it with the .valueChanged event
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
    
        // adding points of interest
        let poiLabel = UILabel()
        poiLabel.translatesAutoresizingMaskIntoConstraints = false
        poiLabel.text = "Points of Interest"
        view.addSubview(poiLabel)
        let poiLabelTopConstraint = poiLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
        let poiLabelLeadingConstraint = poiLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        poiLabelTopConstraint.isActive = true
        poiLabelLeadingConstraint.isActive = true

        
        
        let pointsOfInterest = UISwitch()
        pointsOfInterest.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pointsOfInterest)
        let poiTopConstraint = pointsOfInterest.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
        let poiLeadingConstraint = pointsOfInterest.leadingAnchor.constraint(equalTo: poiLabel.trailingAnchor, constant: 10)
//        let poiTrailingConstraint = pointsOfInterest.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        poiTopConstraint.isActive = true
        poiLeadingConstraint.isActive = true
//        poiTrailingConstraint.isActive = true
        
        poiLabel.centerYAnchor.constraint(equalTo: pointsOfInterest.centerYAnchor).isActive = true
        
        pointsOfInterest.addTarget(self, action: #selector(poiChanged(_:)), for: .valueChanged)
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .authorizedWhenInUse  {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let region = MKCoordinateRegion( center: locValue, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        self.mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("map has finished loading.")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded.")
        self.mapView.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            print("locationServices enabled")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        //centering map to user location
//        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
//        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        self.mapView.pointOfInterestFilter = .excludingAll
        if let coor = self.mapView.userLocation.location?.coordinate {
            print("setting MapView to userLocation")
            self.mapView.setCenter(coor, animated: true)
            self.mapView.showsUserLocation = true
        }
    }
    
    // use @objc to expose the method to the Objective-C runtime
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex{
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    @objc func poiChanged(_ switchControl: UISwitch) {
        if switchControl.isOn {
            mapView.pointOfInterestFilter = .includingAll
        } else {
            mapView.pointOfInterestFilter = .excludingAll
        }
    }

    // setRegion once the AuthorizationStatus has been changed
//    @objc func authorizationChanged(_ status: CLAuthorizationStatus){
//        let location = locationManager
//        if status == CLAuthorizationStatus.authorizedWhenInUse {
//             let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
//            mapView.setRegion(region, animated: true)
//        }
//    }
    
    
}
