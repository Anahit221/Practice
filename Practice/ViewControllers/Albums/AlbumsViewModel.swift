//
//  AlbumsViewModel.swift
//  Practice
//
//  Created by Cypress on 8/5/21.
//

import Foundation
import RxRelay
import RxSwift

final class AlbumsViewModel {
    // MARK: - Properties

    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    let refresh = PublishRelay<Void>()
    let userID = BehaviorRelay<String?>(value: nil)

    // MARK: - Outputs

    let albums = PublishRelay<[Album]>()

    init() {
        doBindings()
    }

    private func doBindings() {
        refresh
            .withLatestFrom(userID).compactMap { $0 }
            .flatMapLatest { userID in
                AlbumsDataManager.shared.getAlbums(for: userID)
            }
            .bind(to: albums)
            .disposed(by: disposeBag)
    }
}
