//
//  ContactsViewController.swift
//  Practice
//
//  Created by Cypress on 8/2/21.
//

import Foundation
import UIKit
import Contacts


class ContactsViewController: NavigationBarViewController {

    var contactsStore = CNContactStore()
    var contacts = [Contact]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchContacts()
    }
    
    func fetchContacts() {
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        try! contactsStore.enumerateContacts(with: request) { (contact, stoppingPointer) in
            let name = contact.givenName
            let familyName = contact.familyName
            let email = contact.emailAddresses.first?.value
            
            let contactToAppend = Contact(givenName: name, familyName: familyName, email: email as String? )
        self.contacts.append(contactToAppend)
        }
        tableView.reloadData()
    }
    
}

extension ContactsViewController:  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
}

extension ContactsViewController:  UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let contactToDisplay = contacts[indexPath.row]
        cell.textLabel?.text = contactToDisplay.givenName + " " + contactToDisplay.familyName
        cell.detailTextLabel?.text = contactToDisplay.email
        return cell
    }
}

