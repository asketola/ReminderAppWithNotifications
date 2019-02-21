//
//  ViewController.swift
//  ReminderAppWithNotifications
//
//  Created by Annemarie Ketola on 2/20/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var groups = [ReminderGroup]()
    var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Reminder App"
        load()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewGroup))
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: "Reminders") else { return }
        
        let decoder = JSONDecoder()
        
        if let savedGroups = try? decoder.decode([ReminderGroup].self, from: data) {
            groups = savedGroups
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        
            if let data = try? encoder.encode(groups) {
                UserDefaults.standard.set(data, forKey: "Reminders")
            }
    }
    
    func show(_ group: ReminderGroup){
        guard let groupViewController = storyboard?.instantiateViewController(withIdentifier: "Groups") as? GroupViewController else {
            fatalError("Unable to load group view controller")
        }
        
        groupViewController.delegate = self
        groupViewController.group = group
        
        navigationController?.pushViewController(groupViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let group = groups[indexPath.row]
        cell.textLabel?.text = group.name
        
        if group.items.count == 1 {
            cell.detailTextLabel?.text = "1 reminder"
        } else {
            cell.detailTextLabel?.text = "\(group.items.count) reminders"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        selectedIndex = indexPath.row
        show(group)
    }
    
    func addGroup(named name: String) {
        let group = ReminderGroup(name: name, items:[])
        groups.append(group)
        selectedIndex = groups.count - 1
        
        tableView.insertRows(at: [IndexPath(row: selectedIndex ?? 0, section: 0)], with: .automatic)
        show(group)
    }
    
    @objc func addNewGroup() {
        
        let ac = UIAlertController(title: "New Reminder Group", message: "What should this reminder group be called?", preferredStyle: .alert)
        
        // add a single empty textfield
        ac.addTextField()
        
        // add a single empty textfield
        ac.addAction(UIAlertAction(title: "Add", style: .default) {
            action in
            
            // if we can't read the textfield for some readon, bail out
            guard let text = ac.textFields?[0].text else { return }
            
            // we got the name - use it to make a group
            self.addGroup(named: text)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func update(_ group: ReminderGroup) {
        guard let selectedIndex = selectedIndex else {
            fatalError("attempted to update a group without a selection")
        }
        //update our groups array with the changed reminder
        groups[selectedIndex] = group
        
        // refresh tableview for that group
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        
        // write the new reminders to the user defaults
        save()
    }
}

