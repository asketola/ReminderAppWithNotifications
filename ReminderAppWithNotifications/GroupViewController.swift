//
//  GroupViewController.swift
//  ReminderAppWithNotifications
//
//  Created by Annemarie Ketola on 2/20/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import UIKit

class GroupViewController: UITableViewController {
    
    weak var delegate: ViewController?
    var group: ReminderGroup!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show the current group name
        title = group.name
        
        // let users add reminders easily
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewReminder))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        let reminder = group.items[indexPath.row]
        
        if reminder.isCommplete {
            
            //make the text a middle green color with strikethrough
            let attrs: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: 1,
                .foregroundColor: UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
            ]
            
            let attributedString = NSAttributedString(string: reminder.title, attributes: attrs)
            
            cell.textLabel?.attributedText = attributedString
        } else {
            cell.textLabel?.text = reminder.title
        }
        return cell
    }
    
    func addReminder(named name: String) {
        //create a new reminder
        let reminder = Reminder(title: name, isComplete: false)
        group.items.append(reminder)
        
        //add the reminder to our table
        tableView.insertRows(at: [IndexPath(row: group.items.count-1, section: 0)], with: .automatic)
        
        //make sure we update the  main view controller
        delegate?.update(group)
    }
    
    @objc func addNewReminder() {
        let ac = UIAlertController(title: "New Reminder", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            guard let text = ac.textFields?[0].text else { return }
            self.addReminder(named: text)
        }))
            
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
        present(ac, animated: true)
    }

}
