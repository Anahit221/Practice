//
//  UsersService.swift
//  Practice
//
//  Created by Cypress on 8/2/21.
//

import Foundation
import RxAlamofire
import RxRelay
import RxSwift

class UsersDataManager {
    static let shared = UsersDataManager()
    private init() {}
    
    private let disposeBag = DisposeBag()

    func getUsers() -> Observable<[User]> {
        Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            let fetchFromNetwork = PublishRelay<Void>()
            let dbUsers = DBService.shared.users.share()
            
            dbUsers
                .bind(to: observer)
                .disposed(by: self.disposeBag)
            dbUsers
                .map { _ in () }
                .bind(to: fetchFromNetwork)
                .disposed(by: self.disposeBag)
            
            fetchFromNetwork
                .flatMapLatest {
                    RxAlamofire.request(.get, URL.usersURL)
                        .validate(statusCode: 200 ..< 300)
                        .data()
                        .compactMap { data in
                            let decoder = JSONDecoder()
                            guard let users = try? decoder.decode([User].self, from: data)
                            else { return nil }
                            return users
                        }
                }
                .catchAndReturn([])
                .flatMap { users in
                    DBService.shared.save(users: users)
                }
                .flatMap {
                    DBService.shared.users
                }
                .bind(to: observer)
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
