//
//  AlbumsService.swift
//  Practice
//
//  Created by Cypress on 8/4/21.
//

import Foundation
import RxAlamofire
import RxRelay
import RxSwift

class AlbumsDataManager {
    static var shared = AlbumsDataManager()

    private init() {}
    private let disposeBag = DisposeBag()

    func getAlbums(for userID: String) -> Observable<[Album]> {
        Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }

            let fetchFromNetwork = PublishRelay<Void>()
            let dbAlbums = DBService.shared.albums(for: userID).share()

            dbAlbums
                .bind(to: observer)
                .disposed(by: self.disposeBag)

            dbAlbums
                .map { _ in () }
                .bind(to: fetchFromNetwork)
                .disposed(by: self.disposeBag)

            fetchFromNetwork
                .flatMapLatest {
                    RxAlamofire.request(.get, URL.albumsURL(for: userID))
                        .validate(statusCode: 200 ..< 300)
                        .data()
                        .compactMap { data in
                            guard let users = try? JSONDecoder.default.decode([Album].self, from: data)
                            else { return nil }
                            return users
                        }
                }
                .catchAndReturn([])
                .flatMap { albums in
                    DBService.shared.save(albums: albums)
                }
                .flatMap {
                    DBService.shared.albums(for: userID)
                }
                .bind(to: observer)
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
}
