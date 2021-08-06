//
//  AlbumTableViewCell.swift
//  Practice
//
//  Created by Cypress on 8/5/21.
//

import Foundation
import Kingfisher
import UIKit

final class AlbumTableViewCell: UITableViewCell {
    @IBOutlet private var albumTitle: UILabel!
    @IBOutlet private var collectionView: UICollectionView! { didSet {
        collectionView.delegate = self
        collectionView.dataSource = self
    }}

    var album: Album! { didSet {
        albumTitle.text = album.title
        collectionView.reloadData()
    }}
}

extension AlbumTableViewCell: UICollectionViewDelegate {}

extension AlbumTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        album?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "AlbumCollectionViewCell",
            for: indexPath)
            as? AlbumCollectionViewCell
        else { fatalError() }
        cell.imageURL = URL(string: album.images[indexPath.row])
        return cell
    }
}
