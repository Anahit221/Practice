//
//  OnboardingViewController.swift
//  Practice
//
//  Created by Cypress on 7/2/21.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet  var pageControl: UIPageControl!
    var pageViewController: UIPageViewController!
    
    private func getViewControllerWith(identifiers: String...) -> [UIViewController] {
        
        identifiers.compactMap { identifier in storyboard?.instantiateViewController(identifier: identifier)
            
        }
    }
    
    
  lazy  var pages = getViewControllerWith(identifiers:"WelcomeViewController",
                                                      "MapViewController",
                                                      "NavigatorViewController",
                                                      "CoinViewController")
        

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false)
        skipButton.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
    }
    
    @objc func tapOnButton(){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let skip = story.instantiateViewController(identifier: "LogInViewController") as! LogInViewController
        let navigation = UINavigationController(rootViewController: skip)
        self.view.addSubview(navigation.view)
        self.present(skip, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageViewController = segue.destination as? UIPageViewController {
            self.pageViewController = pageViewController
        }
    }

}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.firstIndex(of: viewController), index > 0 {
            return pages[index - 1]
        }
        return nil
    }
   
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.firstIndex(of: viewController), index < pages.count - 1 {
            return pages[index + 1]
        }
        return nil
    }
    
   
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentVC = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            self.pageControl.currentPage = currentIndex
        }
    }
}
