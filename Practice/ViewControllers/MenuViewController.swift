//
//  MenuViewController.swift
//  Practice
//
//  Created by Cypress on 7/20/21.
//

import Foundation
import UIKit

enum MenuType: Int {
    case user
    case page1
    case page2
}

class MenuViewController: UITableViewController {
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) {
            print("Dismissing: \(menuType)")
        }
    }
    
}
