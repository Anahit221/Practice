//
//  MediaViewController.swift
//  Practice
//
//  Created by Cypress on 8/2/21.
//

import AVFoundation
import Foundation
import MediaPlayer
import UIKit

class MediaViewController: BaseViewController {
    // MARK: - Properties

    var medias = [Media]() { didSet {
        tableView.reloadData()
    }}

    var player: AVAudioPlayer?
    var nowPlayingInfo = [String: Any]()

    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var playerView: UIView!
    @IBOutlet private var sourceImageView: UIImageView!
    @IBOutlet private var pauseButton: UIButton!
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var fileNameLabel: UILabel!

    var currentlyPlaying: Media?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMedia()
        refreshData()
        setupMediaPlayerNotificationView()
        navigationItem.title = "Media"
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupMediaPlayerNotificationView() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            guard let self = self else { return .commandFailed }
            let mediaPlay = self.currentlyPlaying
            guard let mediaPlayy = mediaPlay else { return .commandFailed }
            self.play(media: mediaPlayy)
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
    }

    private func updateNotificationView() {
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentlyPlaying?.fileName
        if let player = player {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(
                .init(seconds: player.currentTime, preferredTimescale: .max)
            )
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    private func play(media: Media) {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        if media == currentlyPlaying {
            player?.play()
        } else {
            currentlyPlaying = media

            let url = documentURL.appendingPathComponent(media.fileName)
            player = try? AVAudioPlayer(contentsOf: url)
            player?.play()
        }

        sourceImageView.image = UIImage(systemName: media.source == .video ? "video.fill" : "music.note")
        fileNameLabel.text = media.fileName
        pauseButton.isHidden = false
        playButton.isHidden = true
        playerView.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        updateNotificationView()
        tableView.reloadData()
    }

    private func pause() {
        player?.stop()
        playerView.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: false)
        updateNotificationView()
        tableView.reloadData()
    }

    @IBAction func didTapPlayButton(_ sender: UIButton) {
        guard let currentlyPlaying = currentlyPlaying else { return }
        play(media: currentlyPlaying)
    }

    @IBAction func didTapPauseButton(_ sender: UIButton) {
        pause()
    }

    private func loadMedia() {
        let fileManager = FileManager.default

        guard
            let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
            let medias = try? fileManager.contentsOfDirectory(atPath: documentURL.path)
        else { return }

        self.medias = medias.filter { !$0.hasSuffix(".txt") }.map { Media(fileName: $0) }
    }

    private func refreshData() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefreshData), for: .valueChanged)
    }

    @objc
    private func didPullToRefreshData() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension MediaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: false)

        let media = medias[indexPath.row]
        let isCurrentCellPlaying = currentlyPlaying == media && (player?.isPlaying ?? false)

        if isCurrentCellPlaying {
            pause()
        } else {
            play(media: media)
        }
    }
}

extension MediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        medias.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: "MediaTableViewCell", for: indexPath) as? MediaTableViewCell
        else { fatalError() }

        let media = medias[indexPath.row]
        cell.media = media
        if currentlyPlaying == media && (player?.isPlaying ?? false) {
            cell.play()
        } else {
            cell.pause()
        }
        return cell
    }
}
