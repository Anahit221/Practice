//
//  UserCell.swift
//  Practice
//
//  Created by Cypress on 7/28/21.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var email: UILabel!
    
    var user: User! { didSet {
        configure()
    }}
    
    
    private func configure() {
        userName.text = user.username
        email.text = user.email
    }
}
