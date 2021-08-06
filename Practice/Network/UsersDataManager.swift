//
//  UsersService.swift
//  Practice
//
//  Created by Cypress on 8/2/21.
//

import Foundation
import RxAlamofire
import RxSwift

class UsersDataManager {
    static let shared = UsersDataManager()
    private init() {}

    func getUsers() -> Observable<[User]> {
        RxAlamofire
            .request(.get, URL.usersURL)
            .validate(statusCode: 200 ..< 300)
            .data()
            .compactMap { data in
                let decoder = JSONDecoder()
                guard let users = try? decoder.decode([User].self, from: data) else { return nil }
                return users
            }
    }
}
