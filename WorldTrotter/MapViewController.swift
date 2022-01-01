//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Sara Liu on 12/30/21.
//  Copyright © 2021 Sara Liu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // creating a view programmatically by overriding the UIViewController method loadView()
    var mapView: MKMapView!
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded.")
    }
    
    
    
    
}
