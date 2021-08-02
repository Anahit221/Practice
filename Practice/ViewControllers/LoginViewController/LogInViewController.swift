//
//  LogInViewController.swift
//  Practice
//
//  Created by Cypress on 7/2/21.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture


class LogInViewController: UIViewController {
    
        private let defaultsHelper = DefaultsHelper()
        private let viewModel = LoginViewModel()
        private let disposeBag = DisposeBag()
        
        
        // MARK: - Outlets
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var logInView: UIView!
        @IBOutlet weak var logInButton: UIButton!
        @IBOutlet weak var fbButton: UIButton!
        @IBOutlet weak var fbImage: UIImageView!
        @IBOutlet weak var emailErrorLabel: UILabel!
        @IBOutlet weak var passwordErrorLabel: UILabel!
    
    private lazy var eyeButton: UIButton = {
        let eyeButton = UIButton()
        eyeButton.tintColor = .gray
        let eyeImage = UIImage(systemName: "eye")
        eyeButton.setImage(eyeImage, for: .normal)
        return eyeButton
    }()
        
        // MARK: - Lifecycel
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupLoginView()
            logInButton.layer.cornerRadius = 10.0
            addHideButton()
            emailErrorLabel.isHidden = true
            passwordErrorLabel.isHidden = true
            setupTextField()
            doBidings()
            self.view.backgroundColor = .white
        }
        
        // MARK: - Reactive
    
    func doBidings() {
        bindOutputs()
        bindInputs()
        bindUI()
        bindNavigation()
    }
    
    private func bindInputs() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        eyeButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                let isSelected = self?.eyeButton.tintColor == .tweegoRed
                self?.eyeButton.tintColor = isSelected ? .gray : .tweegoRed
                self?.passwordTextField.isSecureTextEntry = isSelected
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(){
        logInButton.rx.tap
            .do(onNext: {[weak self] in
                self?.defaultsHelper.setLogin(isSeen: true)
            })
            .subscribe(onNext: {[weak self] in
                let logInViewController = UIStoryboard.main.instantiateViewController(identifier: "MainScreenViewController")
                self?.navigationController?.setViewControllers([logInViewController], animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutputs() {
        viewModel.emailError.skip(1)
            .subscribe(onNext: {[weak self] error in
                if let error = error {
                    self?.emailErrorLabel.text = error
                    self?.emailErrorLabel.isHidden = false
                } else {
                    self?.emailErrorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.passwordError.skip(2)
            .subscribe(onNext: {[weak self] error in
                if let error = error {
                    self?.passwordErrorLabel.text = error
                    self?.passwordErrorLabel.isHidden = false
                } else {
                    self?.passwordErrorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLogInEnabled
            .bind(to: logInButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    
    func setupLoginView() {
        logInView.layer.cornerRadius = 10.0
        logInView.layer.shadowColor = UIColor.gray.cgColor
        logInView.layer.shadowOpacity = 1
        logInView.layer.shadowOffset = .zero
        logInView.layer.shadowRadius = 10
    }
        
    func setupTextField() {
        let foregroundColor = UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
            emailTextField.attributedPlaceholder = NSAttributedString(
                string: "E-mail",
                attributes: [.foregroundColor: foregroundColor ]
                )
            passwordTextField.attributedPlaceholder = NSAttributedString(
                string: "Password",
                attributes: [.foregroundColor: foregroundColor]
                )
        }
        
        
     
   
    func addHideButton() {
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
    }

}
