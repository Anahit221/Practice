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

class DBService {
    lazy var helperQueue = DispatchQueue(label: "DBService", qos: .default)
    static let shared = DBService()

    lazy var realm: Realm = {
        do {
            let realm = try Realm(configuration: Realm.Configuration.defaultConfiguration, queue: helperQueue)
            realm.autorefresh = true
            return realm
        } catch {
            fatalError("Realm Error")
        }
    }()

    private init() {}

    func save(users: [User]) -> Observable<Void> {
        Observable.create { [weak self] observer in
            let realmUsers = users.map { RealmUser(user: $0) }
            self?.helperQueue.async { [weak self] in
                try? self?.realm.write {
                    self?.realm.add(realmUsers, update: .modified)
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }

    var users: Observable<[User]> {
        Observable.create { [weak self] observer in
            self?.helperQueue.async { [weak self] in
                guard let self = self else { return }
                let realmUsers = Array(self.realm.objects(RealmUser.self))
                let users = realmUsers.map { User(realmUser: $0) }
                observer.onNext(users)
            }
            return Disposables.create()
        }
    }

    func save(albums: [Album]) -> Observable<Void> {
        Observable.create { [weak self] observer in
            let realmAlbums = albums.map { RealmAlbum(album: $0) }
            self?.helperQueue.async { [weak self] in
                try? self?.realm.write {
                    self?.realm.add(realmAlbums, update: .modified)
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }

    func albums(for userId: String) -> Observable<[Album]> {
        Observable.create { [weak self] observer in
            self?.helperQueue.async { [weak self] in
                guard let self = self else { return }
                let realmAlbums = Array(self.realm.objects(RealmAlbum.self)).filter { $0.userId == userId }
                let albums = realmAlbums.map { Album(realmAlbum: $0) }
                observer.onNext(albums)
            }
            return Disposables.create()
        }
    }
}
