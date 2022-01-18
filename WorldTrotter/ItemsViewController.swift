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
    var favoritedView: Bool!
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("\(itemStore.allItems.count) rows are created.")
        // display "No items!" when there the item count == 0
        print("favorited view displayed: \(favoritedView ?? false)")
        if itemStore.allItems.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No items!"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
//            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        } else {
            switch section {
            case 0:
                return itemStore.allItems.count
            case 1:
                return itemStore.itemsLessThan50.count
            case 2:
                return itemStore.itemsMoreThan50.count
            default:
                return 0
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 3
        // 0: non-organized
        // 1: items worth less than $50
        // 2: items worth more than or equal to $50
    }

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Create an instance of UITableViewCell with default appearance
        // reuseIdentifier is the name of the cell class
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // all the packing items
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
             
             // Set the text on teh cell with the description of the item that is
             // at the nth index of items, where n = row of this cell
             let item = itemStore.allItems[indexPath.row]
             
             cell.textLabel?.text = item.name
            if item.favorited {
                // adding the favorited symbol to the item
                print("adding star to \(item.name)")
                cell.imageView?.image = UIImage(systemName: "star")
            }
             cell.detailTextLabel?.text = "$\(item.valueInDollars)"
                
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
             
             // Set the text on teh cell with the description of the item that is
             // at the nth index of items, where n = row of this cell
//            print("indexPath.row \(indexPath.row)")
            let item = itemStore.itemsLessThan50[indexPath.row]
             
             cell.textLabel?.text = item.name
             cell.detailTextLabel?.text = "$\(item.valueInDollars)"
                
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
             
             // Set the text on teh cell with the description of the item that is
             // at the nth index of items, where n = row of this cell
             let item = itemStore.itemsMoreThan50[indexPath.row]
             
             cell.textLabel?.text = item.name
             cell.detailTextLabel?.text = "$\(item.valueInDollars)"
                
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView,
    titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Packing List"
        case 1:
            return "Items worth less than $50"
        case 2:
            return "Items worth more than or equal to $50"
        default:
            return "Everything you need"
        }
    }
    
    // Adding buttons for adding and removing the packing item from the list
    @IBAction func addNewItems(_ sender: UIButton) {
        // make a new index path for the 0th section, inserting to the last row
//        let lastRow = tableView.numberOfRows(inSection: 0)
        
        // updating the datastore
        let newItem = itemStore.createItem()
        
        if newItem.valueInDollars < 50 {
            if let index = itemStore.allItems.firstIndex(where: {$0 == newItem}), let lessThan50Idx = itemStore.itemsLessThan50.firstIndex(where: {$0 == newItem}) {
                let tableIdx = IndexPath(row: index, section: 0)
                let sectionIdx = IndexPath(row: lessThan50Idx, section: 1)
                tableView.insertRows(at: [tableIdx, sectionIdx], with: .automatic)
            }
        } else {
            if let index = itemStore.allItems.firstIndex(where: {$0 == newItem}), let moreThan50Idx = itemStore.itemsMoreThan50.firstIndex(where: {$0 == newItem}) {
                let tableIdx = IndexPath(row: index, section: 0)
                let sectionIdx = IndexPath(row: moreThan50Idx, section: 2)
                tableView.insertRows(at: [tableIdx, sectionIdx], with: .automatic)
            }
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
    
    @IBAction func toggleFavoriteMode(_ sender: UIButton) {
        // show only the favorited items
        favoritedView = true
    }
    
    // enable editing only for the first section
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        if indexPath.section == 0 {
            return true
        }
        return false
    }
    
    
    override func tableView(_ tableView: UITableView,
      commit editingStyle: UITableViewCell.EditingStyle,
      forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sectionRemovedFrom = indexPath.section
            print("deleting from section: \(sectionRemovedFrom)")
            
            let item = itemStore.allItems[indexPath.row]
            print("\(item.name) has been deleted.")
            
            // remove from specific packing list
            if let lessThan50Idx = itemStore.itemsLessThan50.firstIndex(where: {$0 == item}) {
                let lstIdx = IndexPath(row: lessThan50Idx, section: 1)
                itemStore.itemsLessThan50.remove(at: lessThan50Idx)
                tableView.deleteRows(at: [lstIdx], with: .automatic)
                
            }
            if let moreThan50Idx = itemStore.itemsMoreThan50.firstIndex(where: {$0 == item}) {
                let lstIdx = IndexPath(row: moreThan50Idx, section: 2)
                itemStore.itemsMoreThan50.remove(at: moreThan50Idx)
                tableView.deleteRows(at: [lstIdx], with: .automatic)
            }
            
            itemStore.allItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func handleMarkAsFavorite(_ item: Item, index: Int){
        itemStore.allItems[index].favorited = true
        print("Marked \(index)'s item: \(item.name) as favorite")
        tableView.reloadData()
    }
    
    private func handleMoveToTrash(_ item: Item, index: Int){
        itemStore.allItems.remove(at: index)
        print("moving \(item.name) to trash.")
        if item.valueInDollars < 50, let idx = itemStore.itemsLessThan50.firstIndex(where: {$0 == item}) {
            itemStore.itemsLessThan50.remove(at: idx)
        } else if item.valueInDollars >= 50, let idx = itemStore.itemsMoreThan50.firstIndex(where: { $0 == item }) {
            itemStore.itemsMoreThan50.remove(at: idx)
        }
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // adding the swipe left action to favorite an item
        let action = UIContextualAction(style: .normal,
                                        title: "Favourite") {
                                            [weak self] (action, view, completionHandler) in
                                            self?.handleMarkAsFavorite((self?.itemStore.allItems[indexPath.row])!, index: indexPath.row)
                                            completionHandler(true)
        }
        let trash = UIContextualAction(style: .destructive,
                                       title: "Trash") { [weak self] (action, view, completionHandler) in
                                        self?.handleMoveToTrash((self?.itemStore.allItems[indexPath.row])!, index: indexPath.row)
                                        completionHandler(true)
        }
        trash.backgroundColor = .systemRed
        
        action.backgroundColor = .systemBlue
        let configuration = UISwipeActionsConfiguration(actions: [action, trash])

        return configuration
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
