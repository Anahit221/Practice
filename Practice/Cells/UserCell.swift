//
//  UserCell.swift
//  Practice
//
//  Created by Cypress on 7/28/21.
//

import UIKit

final class UserCell: UITableViewCell {
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var email: UILabel!

    var user: User! { didSet {
        configure()
    }}

    private func configure() {
        userName.text = user.username
        email.text = user.email
    }
}
