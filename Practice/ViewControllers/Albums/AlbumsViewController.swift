//
//  AlbumsViewController.swift
//  Practice
//
//  Created by Cypress on 8/2/21.
//

import Foundation
import RxSwift
import UIKit

class AlbumsViewController: NavigationBarViewController {
    // MARK: - Properties

     let viewModel = AlbumsViewModel()

    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refresh.accept(())
    }

    // MARK: - Reactive

    private let disposeBag = DisposeBag()
    private func doBindings() {
        viewModel.albums
            .bind(to: tableView.rx.items) { tv, row, album in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = tv.dequeueReusableCell(
                    withIdentifier: AlbumTableViewCell.reuseIdentifier,
                    for: indexPath)
                    as? AlbumTableViewCell
                else { fatalError() }
                cell.album = album
                return cell
            }
            .disposed(by: disposeBag)
    }
}
