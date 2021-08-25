//
//  LogInViewController.swift
//  Practice
//
//  Created by Cypress on 7/2/21.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

class LogInViewController: UIViewController {
    // MARK: - Properties

    private let defaultsHelper = DefaultsHelper.shared
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - Outlets

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logInView: UIView!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var fbButton: UIButton!
    @IBOutlet var fbImage: UIImageView!
    @IBOutlet var emailErrorLabel: UILabel!
    @IBOutlet var passwordErrorLabel: UILabel!
    private lazy var eyeButton: UIButton = {
        let eyeButton = UIButton()
        eyeButton.tintColor = .gray
        let eyeImage = UIImage(systemName: "eye")
        eyeButton.setImage(eyeImage, for: .normal)
        return eyeButton
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        addHideButton()
        setupTextField()
        doBidings()
        setupLoginButton()
        hideErrorLabel()
        closeKeyboardWhenTapped()
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
            .bind(to: viewModel.emailTextInput)
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordTextInput)
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

    private func bindNavigation() {
        logInButton.rx.tap
            .do(onNext: { [weak self] in
                self?.defaultsHelper.set(loggedIn: true)
            })
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.setNavigationBarHidden(false, animated: true)
                let mainScreen = UIStoryboard.main.instantiateViewController(identifier: "MainScreenViewController")
                self?.navigationController?.setViewControllers([mainScreen], animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
        viewModel.emailError.skip(1)
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.emailErrorLabel.text = error
                    self?.emailErrorLabel.isHidden = false
                } else {
                    self?.emailErrorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        viewModel.passwordError.skip(2)
            .subscribe(onNext: { [weak self] error in
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

    // MARK: - Methods

    func setupLoginView() {
        logInView.layer.cornerRadius = 10.0
        logInView.layer.shadowColor = UIColor.gray.cgColor
        logInView.layer.shadowOpacity = 1
        logInView.layer.shadowOffset = .zero
        logInView.layer.shadowRadius = 10
    }

    func setupTextField() {
        let foregroundColor = UIColor(red: 190 / 255, green: 190 / 255, blue: 190 / 255, alpha: 1)

        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "E-mail",
            attributes: [.foregroundColor: foregroundColor]
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

    func setupLoginButton() {
        logInButton.layer.cornerRadius = 10.0
    }

    func hideErrorLabel() {
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    private func closeKeyboardWhenTapped() {
        let tapBackground = UITapGestureRecognizer()
        view.addGestureRecognizer(tapBackground)
        tapBackground.rx.event
            .subscribe(onNext: {[weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}
