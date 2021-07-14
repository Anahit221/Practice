//
//  DefaultsHelper.swift
//  Practice
//
//  Created by Cypress on 7/8/21.
//

import Foundation

class DefaultsHelper {
    
   static let userDefaults = UserDefaults.standard
  
    
    enum Key: String {
        case onboardingSeen
    }
    
    var isOnboardingSeen: Bool {
        DefaultsHelper.userDefaults.bool(forKey: Key.onboardingSeen.rawValue)
    }
    
    
    func setOnboarding(isSeen: Bool) {
        DefaultsHelper.userDefaults.set(isSeen, forKey: Key.onboardingSeen.rawValue)
    }
}
