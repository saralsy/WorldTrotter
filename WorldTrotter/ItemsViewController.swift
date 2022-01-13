//
//  ItemsViewController.swift
//  WorldTrotter
//
//  Created by Sara Liu on 1/12/22.
//  Copyright © 2022 Sara Liu. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    // adding property 
    var itemStore: ItemStore!
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(itemStore.allItems.count) rows are created.")
        return itemStore.allItems.count
    }

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Create an instance of UITableViewCell with default appearance
        // reuseIdentifier is the name of the cell class
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        // Set the text on teh cell with the description of the item that is
        // at the nth index of items, where n = row of this cell
        let item = itemStore.allItems[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
           
       return cell
    }
    
    override func tableView(_ tableView: UITableView,
    titleForHeaderInSection section: Int) -> String? {
        return "Packing List"
    }
    
    // Adding buttons for adding and removing the packing item from the list
    @IBAction func addNewItems(_ sender: UIButton) {
        // make a new index path for the 0th section, inserting to the last row
//        let lastRow = tableView.numberOfRows(inSection: 0)
        
        // updating the datastore
        let newItem = itemStore.createItem()
        if let index = itemStore.allItems.firstIndex(where: {$0 == newItem}){
            let indexPath = IndexPath(row: index, section: 0)
            // insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        if isEditing {
            // change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            // exit editing mode
            setEditing(false, animated: true)
        } else {
            // change the text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            // enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView,
      commit editingStyle: UITableViewCell.EditingStyle,
      forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            print("\(item.name) has been deleted.")
            itemStore.allItems.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // moving rows
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        // get reference to object being moved so we can insert to the toIndex
        let movedItem = itemStore.allItems[fromIndex]
        
        // remove item from the array
        itemStore.allItems.remove(at: fromIndex)
        
        // insert the item to the array at the toIndex
        itemStore.allItems.insert(movedItem, at: toIndex)
    }
    
    override func tableView(_ tableView: UITableView,
    moveRowAt sourceIndexPath: IndexPath,
           to destinationIndexPath: IndexPath) {
        print("moving item \(sourceIndexPath), at row \(sourceIndexPath.row)")
        moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        
    }

    
    
}
