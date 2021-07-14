//
//  NavigatorViewController.swift
//  Practice
//
//  Created by Cypress on 7/1/21.
//

import UIKit

class NavigatorViewController: UIViewController {

    @IBOutlet weak var navigatorImage: UIImageView!
    
    @IBOutlet weak var navigatorLabel: UILabel!
    
    var text: NSString = "Remember: you’ll need to stay inside a zone for at least one hour to receive any Coins."
    var mutableText = NSMutableAttributedString()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mutableText = NSMutableAttributedString(string: text as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Open Sans", size: 16.0)!])
        mutableText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.otherYellow.self, range: NSRange(location:0,length:9))
             navigatorLabel.attributedText = mutableText
       

    }
}
