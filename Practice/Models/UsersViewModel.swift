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
    let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    let refresh = PublishRelay<Void>()
    
    // MARK: - Outputs
    
    let users = PublishRelay<[User]>()
    
    init() {
        doBidings()
    }
    
    private func  doBidings() {
         refresh
            .flatMapLatest {
                UsersService.shared.getUsers()
            }
            .bind(to: users)
            .disposed(by: disposeBag)
    }
}
