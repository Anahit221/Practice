//
//  NavigationBarViewController.swift
//  Practice
//
//  Created by Cypress on 7/27/21.
//

import Foundation
import UIKit



class NavigationBarViewController: UIViewController {
    
    let transition = SlideInTransition()
    
    
    override func viewDidLoad() {
       
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0 , width: view.frame.width , height: 70))
        navBar.barTintColor = .lightGray
        view.addSubview(navBar)
        let navItem = UINavigationItem(title: "")
        let line = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(goToMenuViewController))
                line.tintColor = .darkGray
        navItem.leftBarButtonItem = line
        navBar.setItems([navItem], animated: false)
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                navBar.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: navBar.bottomAnchor, multiplier: 1.0)
               ])
        } else {
            let standardSpacing: CGFloat = 20.0
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
            bottomLayoutGuide.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: standardSpacing)
            ])
        }
    }
    
@objc
    func goToMenuViewController() {
        guard let menuViewController = storyboard?.instantiateViewController(identifier: "MenuViewController") else { return }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
        
    }
   
}


extension NavigationBarViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
