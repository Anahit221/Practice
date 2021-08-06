//
//  ContactViewModel.swift
//  Practice
//
//  Created by Cypress on 8/4/21.
//

import Contacts
import RxRelay
import RxSwift

final class ContactViewModel {
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let contactStore = CNContactStore()

    // MARK: - Inputs

    let refresh = PublishRelay<Void>()

    // MARK: - Outputs

    let contacts = PublishRelay<[Contact]>()

    init() {
        doBindings()
    }

    private func doBindings() {
        refresh
            .compactMap { [weak self] in
                self?.fetchContacts()
            }
            .map { $0.filter { !($0.email?.isEmpty ?? true) } }
            .bind(to: contacts)
            .disposed(by: disposeBag)
    }

    func fetchContacts() -> [Contact]? {
        let keys = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactEmailAddressesKey
        ]
            as [CNKeyDescriptor]
        do {
            return try contactStore.containers(matching: nil)
                .flatMap { container -> [Contact] in
                    let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                    let results = try self.contactStore.unifiedContacts(matching: predicate, keysToFetch: keys)
                    return results.map { result in
                        let givenName = result.givenName
                        let familyName = result.familyName
                        let email = result.emailAddresses.first?.value
                        return Contact(
                            image: UIImage(systemName: "person.fill"),
                            givenName: givenName,
                            familyName: familyName,
                            email: email as String?)
                    }
                }
        } catch {}
        return nil
    }
}
