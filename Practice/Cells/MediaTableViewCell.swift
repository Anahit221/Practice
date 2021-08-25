//
//  MediaTableViewCell.swift
//  Practice
//
//  Created by Cypress on 17.08.21.
//

import RxSwift
import UIKit

class MediaTableViewCell: UITableViewCell {
    @IBOutlet var sourceImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var playButtonImageView: UIImageView!
    @IBOutlet var pauseButtonImageView: UIImageView!

    func play() {
        playButtonImageView.isHidden = true
        pauseButtonImageView.isHidden = false
    }

    func pause() {
        playButtonImageView.isHidden = false
        pauseButtonImageView.isHidden = true
    }

    var media: Media! { didSet {
        sourceImageView.image = UIImage(systemName: media.source == .audio ? "music.note" : "video.fill")?
            .withTintColor(.darkGray)
        titleLabel.text = media.fileName
    }}
}
