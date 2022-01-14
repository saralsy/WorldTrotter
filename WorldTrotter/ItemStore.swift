//
//  ItemStore.swift
//  WorldTrotter
//
//  Created by Sara Liu on 1/12/22.
//  Copyright © 2022 Sara Liu. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    var itemsLessThan50 = [Item]()
    var itemsMoreThan50 = [Item]()
    
    // ItemsViewController calls on ItemStore to add new item to the list
    // @discardableResult tells the compiler that the caller can ignore the result of the function
    // let newItem = createItem() same as itemStore.createItem(), result doesn't have to be assigned to a variable
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        
        if newItem.valueInDollars < 50 {
            itemsLessThan50.append(newItem)
        } else {
            itemsMoreThan50.append(newItem)
        }
        return newItem
    }
    
    init() {
        print("ItemStore init() is called.")
        for _ in 0...5 {
            createItem()
        }
    }
}
