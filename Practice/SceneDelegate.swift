//
//  SceneDelegate.swift
//  Practice
//
//  Created by Cypress on 6/29/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let _ = (scene as? UIWindowScene) else { return }
        let defaultsHelper = DefaultsHelper()
        let initialViewController: UIViewController
        if defaultsHelper.isOnboardingSeen {
            initialViewController = UIStoryboard.main.instantiateViewController(identifier: "LogInViewController")
        } else if defaultsHelper.isLoginSeen {  initialViewController = UIStoryboard.main.instantiateViewController(identifier: "MainMenuViewController")
        } else {
            initialViewController = UIStoryboard.main.instantiateViewController(identifier: "OnboardingViewController")}
        let navigationController = window?.rootViewController as? UINavigationController
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setViewControllers([initialViewController], animated: false)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
     
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
      
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
       
    }


}

