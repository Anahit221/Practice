//
//  UsersViewController.swift
//  Practice
//
//  Created by Cypress on 7/23/21.
//

import RxSwift
import UIKit

class UsersViewController: NavigationBarViewController {
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel = UsersViewModel()

    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doBindings()
        didTapUserCell()
        setupNavigationItemTitle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refresh.accept(())
    }

    // MARK: - Methods

    private func doBindings() {
        bindOutputs()
    }

    private func bindOutputs() {
        viewModel
            .users
            .bind(to: tableView.rx.items) { tv, row, user in
                let indexPath = IndexPath(row: row, section: 0)

                guard let cell = tv.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell
                else { fatalError() }

                cell.user = user

                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func setupNavigationItemTitle() {
        navigationItem.title = " Users"
    }

    func didTapUserCell() {
        tableView.rx.modelSelected(User.self)
            .subscribe(onNext: { [weak self] user in
                if let vc = self?.storyboard?
                    .instantiateViewController(identifier: "AlbumsViewController") as? AlbumsViewController {
                    vc.viewModel.userID.accept(user.id)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
