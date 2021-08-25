//
//  Album.swift
//  Practice
//
//  Created by Cypress on 8/4/21.
//

import Foundation
import UIKit

struct Album: Decodable {
    let id: String
    let title: String
    let userId: String

    fileprivate let image1: String
    fileprivate let image2: String
    fileprivate let image3: String
    fileprivate let image4: String
    fileprivate let image5: String
    fileprivate let image6: String
    fileprivate let image7: String
    fileprivate let image8: String
    fileprivate let image9: String
    fileprivate let image10: String
    fileprivate let image11: String
    fileprivate let image12: String
    fileprivate let image13: String
    fileprivate let image14: String
    fileprivate let image15: String
    fileprivate let image16: String
    fileprivate let image17: String
    fileprivate let image18: String
    fileprivate let image19: String
    fileprivate let image20: String

    var images: [String] {
        [
            image1, image2, image3, image4, image5, image6, image7, image8, image9,
            image10, image11, image12, image13, image14, image15, image16, image17,
            image18, image19, image20
        ]
    }
}

extension Album {
    init(realmAlbum: RealmAlbum) {
        id = realmAlbum.id
        userId = realmAlbum.userId
        title = realmAlbum.title
        image1 = realmAlbum.images[0]
        image2 = realmAlbum.images[1]
        image3 = realmAlbum.images[2]
        image4 = realmAlbum.images[3]
        image5 = realmAlbum.images[4]
        image6 = realmAlbum.images[5]
        image7 = realmAlbum.images[6]
        image8 = realmAlbum.images[7]
        image9 = realmAlbum.images[8]
        image10 = realmAlbum.images[9]
        image11 = realmAlbum.images[10]
        image12 = realmAlbum.images[11]
        image13 = realmAlbum.images[12]
        image14 = realmAlbum.images[13]
        image15 = realmAlbum.images[14]
        image16 = realmAlbum.images[15]
        image17 = realmAlbum.images[16]
        image18 = realmAlbum.images[17]
        image19 = realmAlbum.images[18]
        image20 = realmAlbum.images[19]
    }
}
