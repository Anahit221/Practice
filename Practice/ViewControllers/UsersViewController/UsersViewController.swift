//
//  UsersViewController.swift
//  Practice
//
//  Created by Cypress on 7/23/21.
//


import UIKit
import Alamofire

class UsersViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView! {
        didSet {
          
            tableView.dataSource = self
        }
    }

    var allUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersAlamofire()
    }
    

    private func getUsersAlamofire() {
        guard
            let url = URL.usersURL
        else { return }
        let decoder = JSONDecoder()
        AF.request(url).responseDecodable(
            of: [User].self,
            queue: .main,
            decoder: decoder
        ) { [weak self] response in
            if let users = response.value {
                self?.allUsers += users
                  self?.tableView.reloadData()
                
            }
        }
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        cell.configure(with: allUsers[indexPath.row])
        return cell
    }   
}


