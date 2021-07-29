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
    
    func configure(with user: User) {
        userName.text = user.username
        email.text = user.email
    }
}
