//
//  UsersViewController.swift
//  Practice
//
//  Created by Cypress on 7/23/21.
//


import UIKit
import RxSwift

class UsersViewController: NavigationBarViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = UsersViewModel()
    
    @IBOutlet var tableView: UITableView!

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doBindings()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refresh.accept(())
    }
    private func doBindings() {
        bindOutputs()
    }
    
    private func bindOutputs() {
        viewModel.users
            .bind(to: tableView.rx.items) { tv, row, user in
                let indexPath = IndexPath(row: row, section: 0)
                
                guard let cell = tv.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell
                else { fatalError() }
                cell.user = user
                return cell
            }
            .disposed(by: disposeBag)
        
//        tableView.rx.modelSelected(User.self)
//            .subscribe(onNext: {[weak self] user in
//                self?.performSegue(withIdentifier: "segue", sender: self)
//            })
//    }
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if let destination = segue.destination as? UsersViewController {
//                destination.user = sender as? User
//            }
//        }

   
     }

}
