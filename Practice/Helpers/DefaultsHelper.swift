//
//  DefaultsHelper.swift
//  Practice
//
//  Created by Cypress on 7/8/21.
//

import Foundation

class DefaultsHelper {
    let userDefaults = UserDefaults.standard
    static var shared = DefaultsHelper()
    private init() {}

    enum Key: String {
        case onboardingSeen
        case loggedIn
    }

    var isOnboardingSeen: Bool {
        userDefaults.bool(forKey: Key.onboardingSeen.rawValue)
    }

    var isLoggedIn: Bool {
        userDefaults.bool(forKey: Key.loggedIn.rawValue)
    }

    func setOnboarding(isSeen: Bool) {
        userDefaults.set(isSeen, forKey: Key.onboardingSeen.rawValue)
    }

    func set(loggedIn: Bool) {
        userDefaults.set(loggedIn, forKey: Key.loggedIn.rawValue)
    }
}
