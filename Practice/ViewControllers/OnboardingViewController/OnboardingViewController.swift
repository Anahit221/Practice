//
//  OnboardingViewController.swift
//  Practice
//
//  Created by Cypress on 7/2/21.
//

import RxCocoa
import RxSwift
import UIKit

class OnboardingViewController: UIViewController {
    var currentIndex = 0

    // MARK: - Outlets

    @IBOutlet private var skipButton: UIButton!
    @IBOutlet private var pageControl: UIPageControl!
    var pageViewController: UIPageViewController!

    lazy var pages = getViewControllerWith(identifiers: "WelcomeViewController",
                                           "MapViewController",
                                           "NavigatorViewController",
                                           "CoinViewController")

    private let defaultsHelper = DefaultsHelper.shared

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageViewController = segue.destination as? UIPageViewController {
            self.pageViewController = pageViewController
        }
    }

    // MARK: - Action

    @IBAction func pageControll(_ sender: Any) {
        let direction: UIPageViewController.NavigationDirection =
            pageControl.currentPage > currentIndex ? .forward : .reverse
        guard pageControl.currentPage >= 0, pageControl.currentPage <= pages.count
        else { return }
        pageViewController.setViewControllers([pages[pageControl.currentPage]], direction: direction, animated: true)
        currentIndex = pageControl.currentPage
        hideSkipButton()
    }

    @IBAction func skip(_ sender: Any) {
        defaultsHelper.setOnboarding(isSeen: true)
        let logInViewController = UIStoryboard.main.instantiateViewController(identifier: "LogInViewController")
        navigationController?.setViewControllers([logInViewController], animated: true)
    }

    // MARK: - Methods

    func hideSkipButton() {
        if let index = pageControl?.currentPage {
            skipButton.isHidden = index == 3
        }
    }

    private func getViewControllerWith(identifiers: String...) -> [UIViewController] {
        identifiers.compactMap { identifier in storyboard?.instantiateViewController(identifier: identifier)
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        if let index = pages.firstIndex(of: viewController), index > 0 {
            return pages[index - 1]
        }
        return nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        if let index = pages.firstIndex(of: viewController), index < pages.count - 1 {
            return pages[index + 1]
        }
        return nil
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            self.currentIndex = currentIndex
            pageControl.currentPage = currentIndex
        }
        hideSkipButton()
    }
}
