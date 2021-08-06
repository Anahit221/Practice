//
//  SlideInTransition.swift
//  Practice
//
//  Created by Cypress on 7/20/21.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting = false
    let dimmingView = UIView()
    var toViewController: UIViewController!
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else { return }

        self.toViewController = toViewController

        let containerView = transitionContext.containerView
        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeight = toViewController.view.bounds.height

        if isPresenting {
            dimmingView.backgroundColor = .gray
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds

            containerView.addSubview(toViewController.view)
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }

        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration) {
            self.isPresenting ? transform() : identity()
        } completion: { _ in
            transitionContext.completeTransition(!isCancelled)
        }
        let tapGatureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView))
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didTapDimmingView))
        swipeGestureRecognizer.direction = .left
        dimmingView.addGestureRecognizer(tapGatureRecognizer)
        toViewController.view.addGestureRecognizer(swipeGestureRecognizer)
    }

    @objc
    private func didTapDimmingView() {
        toViewController.dismiss(animated: true)
    }
}
