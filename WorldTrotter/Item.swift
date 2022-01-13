//
//  Item.swift
//  WorldTrotter
//
//  Created by Sara Liu on 1/12/22.
//  Copyright © 2022 Sara Liu. All rights reserved.
//

import UIKit

class Item {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: Date
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.dateCreated = Date()
        self.serialNumber = serialNumber
    }
    
    convenience init(random: Bool = false) {
        if(random){
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            let randomAdjective = adjectives.randomElement()
            let randomNoun = nouns.randomElement()
            let randomName = "\(randomAdjective ?? "Fabulous") \(randomNoun ?? "Kindle")"
            let randomValue = Int.random(in: 0..<100)
            let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
        
    }
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name && lhs.valueInDollars == rhs.valueInDollars && lhs.dateCreated == rhs.dateCreated
    }
}
