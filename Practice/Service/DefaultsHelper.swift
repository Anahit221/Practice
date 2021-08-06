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
        case loginSeen
    }

    var isOnboardingSeen: Bool {
        userDefaults.bool(forKey: Key.onboardingSeen.rawValue)
    }

    var isLoginSeen: Bool {
        userDefaults.bool(forKey: Key.loginSeen.rawValue)
    }

    func setOnboarding(isSeen: Bool) {
        userDefaults.set(isSeen, forKey: Key.onboardingSeen.rawValue)
    }

    func setLogin(isSeen: Bool) {
        userDefaults.set(isSeen, forKey: Key.loginSeen.rawValue)
    }
}
