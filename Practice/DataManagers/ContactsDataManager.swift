//
//  ContactsDataManager.swift
//  Practice
//
//  Created by Cypress on 09.08.21.
//

import Contacts
import Foundation
import RxSwift

final class ContactsDataManager {
    // MARK: Singleton

    static let shared = ContactsDataManager()
    private init() {}

    // MARK: - Strore

    private let contactStore = CNContactStore()
    let keys = [
        CNContactThumbnailImageDataKey,
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactEmailAddressesKey
    ] as [CNKeyDescriptor]

    // MARK: - CRUD

    func read() -> Observable<[Contact]> {
        guard let contacts = fetchContacts() else { return .empty() }
        return Observable.just(contacts)
    }

    func update(contact: Contact) -> Observable<Contact> {
        update(contact: contact) ? Observable.just(contact) : Observable.never()
    }

    func delete(contact: Contact) -> Observable<Void> {
        delete(contact: contact) ? Observable.just(()) : Observable.never()
    }

    // MARK: - Helpers

    func fetchContacts() -> [Contact]? {
        return try? contactStore.containers(matching: nil)
            .flatMap { container -> [Contact] in
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                let results = try self.contactStore.unifiedContacts(matching: predicate, keysToFetch: self.keys)
                return results.map { result in
                    let identifier = result.identifier
                    var image: UIImage?
                    if let data = result.thumbnailImageData {
                        image = UIImage(data: data)
                    } else {
                        image = UIImage(systemName: "person.fill")
                    }
                    let givenName = result.givenName
                    let familyName = result.familyName
                    let email = result.emailAddresses.first?.value
                    return Contact(
                        identifier: identifier,
                        image: image,
                        givenName: givenName,
                        familyName: familyName,
                        email: email as String?)
                }
            }
    }

    private func update(contact: Contact) -> Bool {
        guard
            let storedContact = try? contactStore.unifiedContact(withIdentifier: contact.identifier, keysToFetch: keys),
            let mutableContact = storedContact.mutableCopy() as? CNMutableContact
        else { return false }

        mutableContact.givenName = contact.givenName
        mutableContact.familyName = contact.familyName
        if let email = contact.email {
            mutableContact.emailAddresses = [CNLabeledValue(label: "home", value: email as NSString)]
        }

        let request = CNSaveRequest()
        request.update(mutableContact)
        return (try? contactStore.execute(request)) != nil
    }

    private func delete(contact: Contact) -> Bool {
        guard
            let contact = try? contactStore.unifiedContact(withIdentifier: contact.identifier, keysToFetch: keys),
            let mutableContact = contact.mutableCopy() as? CNMutableContact
        else { return false }

        let request = CNSaveRequest()
        request.delete(mutableContact)
        return (try? contactStore.execute(request)) != nil
    }
}
