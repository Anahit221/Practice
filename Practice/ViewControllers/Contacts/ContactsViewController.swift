//
//  ContactsViewController.swift
//  Practice
//
//  Created by Cypress on 8/2/21.
//

import Contacts
import RxSwift
import UIKit

class ContactsViewController: NavigationBarViewController {
    // MARK: MVVM

    private let viewModel = ContactViewModel()
    private let disposeBag = DisposeBag()
    private var contacts = [Contact]()
    private var editContacts = EditContactsViewController()

    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doBindings()
        viewModel.refresh.accept(())
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func doBindings() {
        viewModel.contacts
            .bind(to: tableView.rx.items) { tv, row, contact in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = tv.dequeueReusableCell(
                        withIdentifier: ContactTableViewCell.reuseIdentifier,
                        for: indexPath) as? ContactTableViewCell
                else { fatalError() }
                cell.contact = contact
                return cell
            }
            .disposed(by: disposeBag)
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
        }
        delete.image = UIImage(systemName: "trash")

        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
        }
        edit.image = UIImage(systemName: "pencil")
        edit.backgroundColor = .purple
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipeActions
    }
}
