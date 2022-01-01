//
//  ViewController.swift
//  WorldTrotter
//
//  Created by Sara Liu on 12/30/21.
//  Copyright © 2021 Sara Liu. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {

    
    
    override func viewDidLoad() {
        // UIWindow is the superview of UIView (ViewController)
        super.viewDidLoad()
        print("ConversionViewController loaded.")
        

//        let firstFrame = CGRect(x: 160, y: 240, width: 100, height: 150)
//        let firstView = UIView(frame: firstFrame)
//        firstView.backgroundColor = UIColor.blue
//        // UIView for ViewController is the superview of firstView, blue view
//        view.addSubview(firstView)
//
//        let secondFrame = CGRect(x: 20, y: 30, width: 50, height: 50)
//        let secondView = UIView(frame: secondFrame)
//        secondView.backgroundColor = UIColor.green
//        // UIView for firstView is the superview of green view
//        firstView.addSubview(secondView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // adding a layer of gradient color for the background
        /*
        createGradient()
        print("showing gradient in the ConversionViewController")
        */
        
        // changing background to be random color everytime the conversion view controller is loaded
        /*
        let bgColors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.yellow]
        let randomNumber = Int.random(in: 0...3)
        super.view.backgroundColor = bgColors[randomNumber]
        */
 }
    
    
    // Adding a gradient layer
    func createGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.white.cgColor]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
        
    
    
}

