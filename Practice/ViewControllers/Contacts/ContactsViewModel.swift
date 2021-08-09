//
//  ContactsViewModel.swift
//  Practice
//
//  Created by Cypress on 8/4/21.
//

import Contacts
import RxRelay
import RxSwift

final class ContactsViewModel {
    // MARK: - Properties

    private let contactsManager = ContactsDataManager.shared

    // MARK: - Inputs

    let refresh = PublishRelay<Void>()
    let openEdit = PublishRelay<IndexPath>()
    let openDetail = PublishRelay<IndexPath>()
    let delete = PublishRelay<IndexPath>()

    // MARK: - Outputs

    let contacts = PublishRelay<[Contact]>()
    let navigateToEdit = PublishRelay<Contact>()
    let navigateToDetail = PublishRelay<Contact>()

    init() {
        doBindings()
    }

    // MARK: - Reactive
    
    private let disposeBag = DisposeBag()
    private func doBindings() {
        refresh
            .flatMap { [contactsManager] in
                contactsManager.read()
            }
            .map { $0.filter { !($0.email?.isEmpty ?? true) } }
            .bind(to: contacts)
            .disposed(by: disposeBag)
        
        delete
            .withLatestFrom(contacts) { indexPath, contacts in
                contacts[indexPath.row]
            }
            .flatMap { [contactsManager] in
                contactsManager.delete(contact: $0)
            }
            .bind(to: refresh)
            .disposed(by: disposeBag)
        
        openEdit
            .withLatestFrom(contacts) { indexPath, contacts in
                contacts[indexPath.row]
            }
            .bind(to: navigateToEdit)
            .disposed(by: disposeBag)
        
        openDetail
            .withLatestFrom(contacts) { indexPath, contacts in
                contacts[indexPath.row]
            }
            .bind(to: navigateToDetail)
            .disposed(by: disposeBag)
    }
}
