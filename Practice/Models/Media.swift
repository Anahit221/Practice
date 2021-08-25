//
//  Media.swift
//  Practice
//
//  Created by Cypress on 17.08.21.
//

import Foundation

struct Media {
    enum Source {
        case audio
        case video
        case unknown

        init(name: String) {
            let ext = name.components(separatedBy: ".").last?.lowercased()
            switch ext {
            case "mp3", "wav", "aac":
                self = .audio
            case "mov", "mp4":
                self = .video
            default:
                self = .unknown
            }
        }
    }

    let id = UUID().uuidString
    let fileName: String

    var name: String {
        fileName.components(separatedBy: ".").dropLast().joined()
    }

    var source: Source {
        Source(name: fileName)
    }
}

extension Media: Equatable {
    static func ==(lhs: Media, rhs: Media) -> Bool {
        lhs.id == rhs.id
    }
}
