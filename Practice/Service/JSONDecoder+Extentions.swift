//
//  JSONDecoder+Extentions.swift
//  Practice
//
//  Created by Cypress on 8/6/21.
//

import Foundation

extension JSONDecoder {
    static let `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
