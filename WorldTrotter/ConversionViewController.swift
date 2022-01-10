//
//  ViewController.swift
//  WorldTrotter
//
//  Created by Sara Liu on 12/30/21.
//  Copyright © 2021 Sara Liu. All rights reserved.
//

import UIKit

// making ConversionViewController conform to UITextFieldDelegate
class ConversionViewController: UIViewController, UITextFieldDelegate {
    // responding to text field changes
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    
    
    // implement text delegate property of the text field
    // calls this method on its delegate to ask whether the replacement string should be accepted or rejected
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool{
        print("Current text: \(String(describing:textField.text))")
        print("Replacement text: \(string)")
        
        let currentLocale = Locale.current
        let isMetric = currentLocale.usesMetricSystem
        let currencySymbol = currentLocale.currencySymbol
        print("user's region uses \(currencySymbol) and isMetric: \(isMetric)")
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let exisitingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        let replacementTextHasAlphabeticCharacters = string.rangeOfCharacter(from: CharacterSet.letters)
        
        if exisitingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil{
            return false // reject the second decimal separator
        } else if replacementTextHasAlphabeticCharacters != nil {
            return false
        } else {
            return true
        }
    }
    
    
    // optional variable to store the temperature
    var fahrenheitValue: Measurement<UnitTemperature>? {
        // use a property observer, called whenever a property's value is changed
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    // adding a number formatter as a property
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    // updating the celsius label every time the Fahrenheit value is changed
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from:NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    

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
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        // using multiple conditions, if the text field has text and the text is empty
//        if let text = textField.text, text.isEmpty {
//            celsiusLabel.text = "???"
//        } else {
//            celsiusLabel.text = textField.text
//        }
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    // dismiss the keyboard when called
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    
    // Adding a gradient layer
    func createGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.white.cgColor]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
        
    
    
}

