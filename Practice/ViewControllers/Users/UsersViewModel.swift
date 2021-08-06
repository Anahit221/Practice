//
//  UsersViewModel.swift
//  Practice
//
//  Created by Cypress on 8/2/21.
//

import Foundation

import RxRelay
import RxSwift

final class UsersViewModel {
    // MARK: - Properties

    let disposeBag = DisposeBag()

    // MARK: - Inputs

    let refresh = PublishRelay<Void>()

    // MARK: - Outputs

    let users = PublishRelay<[User]>()

    // MARK: - Init

    init() {
        doBidings()
    }

    // MARK: - Methods

    private func doBidings() {
        refresh
            .flatMapLatest {
                UsersDataManager.shared.getUsers()
            }
            .bind(to: users)
            .disposed(by: disposeBag)
    }
}
