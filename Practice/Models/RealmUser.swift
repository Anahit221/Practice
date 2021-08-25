//
//  RealmUser.swift
//  Practice
//
//  Created by Cypress on 10.08.21.
//

import Foundation
import RealmSwift

class RealmUser: Object {
    // MARK: Properties

    @objc dynamic var id: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var email: String = ""

    override class func primaryKey() -> String? { "id" }

    convenience init(user: User) {
        self.init()
        id = user.id
        username = user.username
        email = user.email
    }
}
