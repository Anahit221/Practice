//
//  ContactViewModel.swift
//  Practice
//
//  Created by Cypress on 09.08.21.
//

import Foundation
import RxSwift
import RxRelay

final class ContactViewModel {
    // MARK: - Managers
    
    private let contactsManager = ContactsDataManager.shared
    
    //MARK: - Inputs
    
    let contact = PublishRelay<Contact>()
    let firstName = PublishRelay<String>()
    let lastName = PublishRelay<String>()
    let email = PublishRelay<String>()
    
    let save = PublishRelay<Void>()
    
    // MARK: - Outputs
    
    let isInEditingMode = PublishRelay<Bool>()
    
    init() {
        doBindings()
    }

    // MARK: - Reactive
    
    private let disposeBag = DisposeBag()
    private func doBindings() {
        bindContact()
        bindSave()
        
    }
    
    // MARK: - Helpers
    
    private func bindContact() {
        contact.map(\.givenName)
            .bind(to: firstName)
            .disposed(by: disposeBag)
        
        contact.map(\.familyName)
            .bind(to: lastName)
            .disposed(by: disposeBag)
        
        contact.compactMap(\.email)
            .bind(to: email)
            .disposed(by: disposeBag)
    }
    
    private func bindSave()  {
        let modifiedContact: Observable<Contact> =
            Observable.combineLatest(firstName, lastName, email, contact) { firstName, lastName, email, contact in
                let modifiedContact = Contact(
                    identifier: contact.identifier,
                    image: contact.image,
                    givenName: firstName, 
                    familyName: lastName,
                    email: email)
                return modifiedContact
            }
        let savedContact = save
            .withLatestFrom(modifiedContact)
            .flatMap { [contactsManager] contact in
                contactsManager.update(contact: contact)
            }
            .share()
        savedContact
            .bind(to: contact)
            .disposed(by: disposeBag)
        
        savedContact.map { _ in false }
            .bind(to: isInEditingMode)
            .disposed(by: disposeBag)
    }

}
