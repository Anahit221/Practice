//
//  AppDelegate.swift
//  Practice
//
//  Created by Cypress on 6/29/21.
//

import AVFoundation
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)

        } catch {
            print("error occured")
        }
        createDocumentsDirectoryIfNeeded()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

private func createDocumentsDirectoryIfNeeded() {
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    if FileManager.default.contents(atPath: documentsURL.path) == nil {
        let dummy = String()
        do {
            let dummyURL = documentsURL.appendingPathComponent(".dummy.txt")
            try dummy.write(to: dummyURL, atomically: true, encoding: .utf8)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
