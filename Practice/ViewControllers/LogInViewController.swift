//
//  LogInViewController.swift
//  Practice
//
//  Created by Cypress on 7/2/21.
//

import UIKit

class LogInViewController: UIViewController {
    
    // MARK: 
    @IBOutlet weak var emailTextField: BidingTextField!
    @IBOutlet weak var password: BidingTextField!
    @IBOutlet weak var emailError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()

        
    }
    
    @IBAction func showPassword(_ sender: Any) {
        password.isSecureTextEntry = false
    }
    
    
    private func setUpTextField() {
        emailTextField.bind { [weak self] (text) in
           
           if let isValid = self?.isValidEmail(email: text) {
            self?.emailError.text = isValid ? "" : "email is not valid!"
           }
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

class BidingTextField: UITextField {
    
    var textEdited: ((String) -> Void)? = nil
    
    
    
    func bind(completion: @escaping (String) -> Void) {
        textEdited = completion
        addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        
    }
    
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textEdited?(text)
    }
}
