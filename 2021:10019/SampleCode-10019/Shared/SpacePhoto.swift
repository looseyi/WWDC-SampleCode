//
//  SpacePhoto.swift
//  SampleCode-10019
//
//  Created by Edmond on 2021/6/12.
//

import Foundation

struct SpacePhoto {

    let id: String
    let title: String
    let description: String
    let date: String
    let mediaType: String
    var url: Link!

    struct Link: Codable {
        let render: String
        let rel: String
        let href: URL
    }
}

extension SpacePhoto: Codable {

    enum Keys: String, CodingKey {
        case id = "nasa_id"
        case title
        case description
        case date = "date_created"
        case copyright
        case mediaType = "media_type"
    }

    var isImage: Bool {
        return mediaType == "image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        self.id = try container.decode(String.self, forKey: Keys.id)
        self.title = try container.decode(String.self, forKey: Keys.title)
        self.description = try container.decode(String.self, forKey: Keys.description)
        self.date = try container.decode(String.self, forKey: Keys.date)
        self.mediaType = try container.decode(String.self, forKey: Keys.mediaType)
    }
}

extension SpacePhoto: Identifiable {}
