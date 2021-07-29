//
//  LogInViewModel.swift
//  Practice
//
//  Created by Cypress on 7/21/21.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    // MARK: Input
    public let loginButtonTap = PublishRelay<Void>()
    private let bag = DisposeBag()
    
}
