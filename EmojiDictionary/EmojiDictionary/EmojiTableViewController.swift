//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Vladislav Boyko on 11/17/19.
//  Copyright © 2019 Buckwheat. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    var emojis = [Emoji]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emojis = Emoji.loadSampleEmojis()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    // MARK: - Edit button
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    } // number of sections will be 1

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return emojis.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
        
        let emoji = emojis[indexPath.row]
        
        cell.update(with: emoji)
        cell.showsReorderControl = true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Delegate methods implementation
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = emojis.remove(at: sourceIndexPath.row)
        
        emojis.insert(movedEmoji, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEmoji" {
            let indexPath = tableView.indexPathForSelectedRow!
            let emoji = emojis[indexPath.row]
            let navigationController = segue.destination as! UINavigationController
            let addEditEmojiTableViewController = navigationController.topViewController as! AddEditTableViewController
            
            addEditEmojiTableViewController.emoji = emoji
        }
    }
    
    @IBAction func unwindSegueEmojiTableView(segue: UIStoryboardSegue) {
        
        guard segue.identifier == "SaveUnwind" else {return}
        let sourceViewController = segue.source as! AddEditTableViewController
        
        if let emoji = sourceViewController.emoji {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                emojis[selectedIndexPath.row] = emoji
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: emojis.count, section: 0)
                emojis.append(emoji)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        Emoji.saveToFile(emojis: emojis)
        
        
        }
}
