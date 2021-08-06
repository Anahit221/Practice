//
//  LoginViewModel.swift
//  Practice
//
//  Created by Cypress on 7/21/21.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {
    private let disposeBag = DisposeBag()

    // MARK: Input

    let emailTextInput = PublishRelay<String>()
    let passwordTextInput = PublishRelay<String>()

    // MARK: Outputs

    let emailError = BehaviorRelay<String?>(value: nil)
    let passwordError = BehaviorRelay<String?>(value: nil)
    let isLogInEnabled = BehaviorRelay(value: false)

    init() {
        doBidings()
    }

    private func doBidings() {
        emailTextInput
            .filter { !$0.isEmpty }
            .map { [weak self] in self?.validate(email: $0) }
            .bind(to: emailError)
            .disposed(by: disposeBag)

        passwordTextInput
            .map { [weak self] in self?.validate(password: $0) }
            .bind(to: passwordError)
            .disposed(by: disposeBag)

        Observable.combineLatest(emailError, passwordError) {
            $0 == nil && $1 == nil
        }
        .bind(to: isLogInEnabled)
        .disposed(by: disposeBag)
    }

    private func validate(email: String) -> String? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValid = emailPred.evaluate(with: email)
        return isValid ? nil : "Email is not valid!"
    }

    private func validate(password: String) -> String? {
        let isValid = !password.isEmpty
        return isValid ? nil : "Password cannot be empty!"
    }
}
