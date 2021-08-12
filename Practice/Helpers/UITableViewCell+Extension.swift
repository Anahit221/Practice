//
//  UITableViewCell+Extension.swift
//  Practice
//
//  Created by Cypress on 8/4/21.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
