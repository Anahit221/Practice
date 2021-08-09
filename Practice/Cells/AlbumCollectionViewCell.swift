//
//  AlbumCollectionViewCell.swift
//  Practice
//
//  Created by Cypress on 8/6/21.
//

import Foundation
import Kingfisher
import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    var album: Album!

    @IBOutlet private var imageView: UIImageView!

    var imageURL: URL! { didSet {
        imageView.kf.setImage(with: imageURL)
    }}
}
