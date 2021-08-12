//
//  DBService.swift
//  Practice
//
//  Created by Cypress on 10.08.21.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

class RealmObjectWithId: Object, Codable {
    @objc dynamic var _id: String = UUID().uuidString
}

class DBService {
    lazy var helperQueue = DispatchQueue(label: "DBService")
    static let shared = DBService()
    lazy var realm: Realm = {
        autoreleasepool {
            // Configuring Realm
            do {
                let realm = try Realm(configuration: Realm.Configuration.defaultConfiguration, queue: helperQueue)
                realm.autorefresh = true
                return realm
            } catch {
                fatalError("Realm Error")
            }
        }
    }()

    private init() {}

    func save(users: [User]) {
        let realmUsers = users.map { RealmUser(user: $0) }
        try? realm.write {
            realm.add(realmUsers)
        }
    }

    var users: Observable<[User]> {
        Observable.create { [realm] observer in
            let realmUsers = Array(realm.objects(RealmUser.self))
            let users = realmUsers.map { User(realmUser: $0) }
            observer.onNext(users)
            return Disposables.create()
        }
    }
}
