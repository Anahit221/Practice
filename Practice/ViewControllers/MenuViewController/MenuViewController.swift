//
//  MenuViewController.swift
//  Practice
//
//  Created by Cypress on 7/20/21.
//

import Foundation
import UIKit

enum MenuItem: Int {
    case user
    case contacts
    case media
}

protocol MenuDelegate: AnyObject {
    func didSelect(_ item: MenuItem)
}

class MenuViewController: UITableViewController {
    weak var delegate: MenuDelegate?

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = MenuItem(rawValue: indexPath.row) else { return }
        delegate?.didSelect(item)
        dismiss(animated: true)
    }
}
