//
//  ContactTableViewCell.swift
//  Practice
//
//  Created by Cypress on 8/4/21.
//

import UIKit

final class ContactTableViewCell: UITableViewCell {
    @IBOutlet private var contactImage: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!

    var contact: Contact! { didSet {
        nameLabel.text = contact.fullName
        emailLabel.text = contact.email
        contactImage.image = contact.image
    }}
}

extension Contact {
    var fullName: String {
        givenName + " " + familyName
    }
}
