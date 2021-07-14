//
//  WelcomeViewController.swift
//  Practice
//
//  Created by Cypress on 7/1/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeImage: UIImageView!
    
  
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.lineBreakMode = .byTruncatingTail
       
        

        
    }
    
}
