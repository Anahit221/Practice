//
//  OnboardingViewModel.swift
//  Practice
//
//  Created by Cypress on 7/21/21.
//

import Foundation
import RxSwift
import RxCocoa


class OnboardingViewModel {
    
    private let bag = DisposeBag()
    private let skipButtonTap = PublishRelay<Void>()
    private let doneButtonTap = PublishRelay<Void>()
    
}
