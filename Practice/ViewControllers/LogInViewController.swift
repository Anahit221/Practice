//
//  LogInViewController.swift
//  Practice
//
//  Created by Cypress on 7/2/21.
//

import UIKit
import RxSwift
import RxCocoa

class LogInViewController: UIViewController {
    
    var emailSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var logIn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var hidePasswordButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var fbImage: UIImageView!
    @IBOutlet weak var errorLable: UILabel!
    
    // MARK: - Lifecycel
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupBidings()
        logInView.layer.cornerRadius = 10.0
        logInView.layer.shadowColor = UIColor.gray.cgColor
        logInView.layer.shadowOpacity = 1
        logInView.layer.shadowOffset = .zero
        logInView.layer.shadowRadius = 10
        logIn.layer.cornerRadius = 10.0
        addHideButton()
        errorLable.isHidden = true
    }
    
    // MARK: - Actions
    
    
    @IBAction func logInButton(_ sender: Any) {
        guard let email = emailTextField.text, emailTextField.text?.count != 0 else { return }
        if validateEmail(emailID: email) == false {
            errorLable.isHidden = false
            errorLable.text = "email is not valid !"
        }
        guard let _ = passwordTextField.text, passwordTextField.text?.count != 0 else { return }
      
        let logInViewController = UIStoryboard.main.instantiateViewController(identifier: "MainMenuViewController")
        navigationController?.setViewControllers([logInViewController], animated: true)
        
    }
    
    @IBAction func hideButtonTapped(_ sender: Any) {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
        
    }
   
    func validateEmail(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailID)
        
    }

//    func setupBidings() {
//        emailTextField.rx.text.bind(to: emailSubject).disposed(by: disposeBag)
//        passwordTextField.rx.text.bind(to: emailSubject).disposed(by: disposeBag)
//        emailSubject
//            .map { $0!.validateEmail() && self.passwordTextField.text != ""  }
//            .bind(to: logIn.rx.isEnabled)
//            .disposed(by: disposeBag)
//    }
   
    func addHideButton() {
        passwordTextField.addSubview(hidePasswordButton)
        passwordTextField.rightView = hidePasswordButton
        hidePasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        passwordTextField.rightViewMode = .always
    }
}

