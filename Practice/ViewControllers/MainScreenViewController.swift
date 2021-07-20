//
//  MainMenuViewController.swift
//  Practice
//
//  Created by Cypress on 7/16/21.
//

import UIKit

class MainScreenViewController: UIViewController  {
    let transition = SlideInTransition()

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    @IBAction func didMenuTapped(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(identifier: "MenuViewController") else { return }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
}

extension MainScreenViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
