//
//  ContactListTableViewController.swift
//  ContactsCKAssessment
//
//  Created by Cody on 9/28/18.
//  Copyright © 2018 Cody Adcock. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: ContactController.shared.contactsWereUpdatedNotification, object: nil)
        ContactController.shared.fetchContacts { (_) in
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            let destinationVC = segue.destination as? ContactDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let contact = ContactController.shared.contacts[indexPath.row]
            destinationVC?.contact = contact
        }
    }
    
    @objc func updateView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}
