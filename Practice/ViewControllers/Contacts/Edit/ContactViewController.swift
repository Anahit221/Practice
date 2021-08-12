//
//  ContactViewController.swift
//  Practice
//
//  Created by Cypress on 09.08.21.
//

import Foundation
import RxSwift
import UIKit

class ContactViewController: UIViewController {
    // MARK: Dependencies

    private let viewModel = ContactViewModel()
    
    var contact: Contact!
    var isInEditingMode = false

    // MARK: - Subviews

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var firstNameTextField: UITextField!
    @IBOutlet private var lastNameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleToFill
        button.tintColor = .darkGray
        return button
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitle("Save", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        doBinding()
        viewModel.contact.accept(contact)
        viewModel.isInEditingMode.accept(isInEditingMode)
        
        let barButtonItemStackView = UIStackView(arrangedSubviews: [editButton, saveButton])
        let barButtonItem = UIBarButtonItem()
        barButtonItem.customView = barButtonItemStackView
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private let disposeBag = DisposeBag()
    private func doBinding() {
        bindOutputs()
        bindInputs()
    }

    private func bindInputs() {
        firstNameTextField.rx.text.orEmpty
            .bind(to: viewModel.firstName)
            .disposed(by: disposeBag)
        
        lastNameTextField.rx.text.orEmpty
            .bind(to: viewModel.lastName)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .map { true }
            .bind(to: viewModel.isInEditingMode)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind(to: viewModel.save)
            .disposed(by: disposeBag)
    }
    
    private func bindOutputs() {
        viewModel.contact.map(\.image)
            .bind(to: avatarImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.contact.map(\.givenName)
            .bind(to: firstNameTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.contact.map(\.familyName)
            .bind(to: lastNameTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.contact.map(\.email)
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
    
        viewModel.isInEditingMode
            .bind(to: editButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isInEditingMode
            .map { !$0 }
            .bind(to: saveButton.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isInEditingMode
            .bind(to: firstNameTextField.rx.isUserInteractionEnabled,
                  lastNameTextField.rx.isUserInteractionEnabled,
                  emailTextField.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
    }
}
