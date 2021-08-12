//
//  User.swift
//  Practice
//
//  Created by Cypress on 7/28/21.
//

import Foundation

struct User: Decodable {
    let id: String
    let username: String
    let email: String
}

extension User {
    init(realmUser: RealmUser) {
        id = realmUser.id
        username = realmUser.username
        email = realmUser.email
    }
}
