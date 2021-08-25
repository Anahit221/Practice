//
//  RealmAlbum.swift
//  Practice
//
//  Created by Cypress on 16.08.21.
//

import Foundation
import RealmSwift

class RealmAlbum: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var userId: String = ""
    @objc dynamic var title: String = ""
    var images = List<String>()

    override class func primaryKey() -> String? { "id" }

    convenience init(album: Album) {
        self.init()
        id = album.id
        userId = album.userId
        title = album.title
        album.images.forEach { [weak self] in self?.images.append($0) }
    }
}
