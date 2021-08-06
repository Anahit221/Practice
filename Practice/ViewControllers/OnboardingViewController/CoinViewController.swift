//
//  CoinViewController.swift
//  Practice
//
//  Created by Cypress on 7/1/21.
//

import UIKit

class CoinViewController: UIViewController {
    let defaultsHelper = DefaultsHelper.shared

    @IBOutlet var coinImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func doneButton(_ sender: Any) {
        defaultsHelper.setOnboarding(isSeen: true)
        let logInViewController = UIStoryboard.main.instantiateViewController(identifier: "LogInViewController")
        navigationController?.setViewControllers([logInViewController], animated: true)
    }
}
