//
//  ViewController.swift
//  Checklists
//
//  Created by Seth Watson on 9/13/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

/// UITableViewController to manage Checklist view setup and Checklist state
class ChecklistViewController: UITableViewController {
//    var items = [ChecklistItem]()
    var checklist: Checklist!
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set checklist name to title when view loads
        title = checklist.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue based on identifier
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        
        //applies checkmark if item checked
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
}

// MARK: UITableViewDataSource

extension ChecklistViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returns the current number of items in the checklists
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // prepares cell at indexpath to be reused with a new checklist item
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        // takes an item from the array of checklist items in a particular row defined by index and sets it to item
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        //puts text from checklistitem in label
        label.text = "\(item.text)"
    }
}


// MARK: - UITableViewDelegate

extension ChecklistViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //looks to tableview for cell in the row defined by index, unwraps and assigns to cell
        if let cell = tableView.cellForRow(at: indexPath) {
            //takes an item from the array of checklist items in a particular row defined by index and sets it to item
            let item = checklist.items[indexPath.row]
            //toggles check when item clicked
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        //animation for row selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // remove item from row
        checklist.items.remove(at: indexPath.row)
        // array of indexpaths
        let indexPaths = [indexPath]
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }
}

    
extension ChecklistViewController: itemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        // assign current array length to newrowindex
        let newRowIndex = checklist.items.count
        // adds item to checklist items array
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        //insert new row for the ChecklistItem at indexPath which is length of items array on Checklist
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated:true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated:true)
    }
}
