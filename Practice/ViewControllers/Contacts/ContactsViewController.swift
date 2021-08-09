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

    private let viewModel = ContactsViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doBindings()
        viewModel.refresh.accept(())
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        setupNavigationTitle()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refresh.accept(())
    }
    
    private func doBindings() {
        bindOutputs()
        bindInputs()
    }
    
    private func bindInputs() {
        tableView.rx.itemSelected
            .do(onNext: { [tableView] indexPath in
                tableView?.deselectRow(at: indexPath, animated: true)
            })
            .bind(to: viewModel.openDetail)
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
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
        
        viewModel.navigateToEdit.asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] contact in
                self?.navigateToDetail(contact: contact, shouldEdit: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.navigateToDetail.asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] contact in
                self?.navigateToDetail(contact: contact, shouldEdit: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationTitle() {
        navigationItem.title = "Contacts"
    }
    
    private func navigateToDetail(contact: Contact, shouldEdit: Bool) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ContactViewController") as? ContactViewController else { return }
        
        vc.contact = contact
        vc.isInEditingMode = shouldEdit
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [viewModel] _, _, completion in
            viewModel.delete.accept(indexPath)
            completion(true)
        }
        delete.image = UIImage(systemName: "trash")

        let edit = UIContextualAction(style: .normal, title: "Edit") {[viewModel] _, _, completion in
            viewModel.openEdit.accept(indexPath)
            completion(true)
        }
        edit.image = UIImage(systemName: "pencil")
        edit.backgroundColor = .purple
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipeActions
    }
}
