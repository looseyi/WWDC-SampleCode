//
//  NASAResponse.swift
//  SampleCode-10019
//
//  Created by Edmond on 2021/6/12.
//

import Foundation

struct NASAResponse: Codable {

    let collection: NASAResponse.Collection

    struct Collection: Codable {
        let items: [Item]
        let metadata: MetaData
        let version: String
        let href: URL?
    }

    struct MetaData: Codable {
        let total_hits: Int
    }

    struct Item: Codable {
        var data: SpacePhoto

        enum Keys: String, CodingKey {
            case data
            case links
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)

            let link = try container.decode([SpacePhoto.Link].self, forKey: Keys.links).first
            self.data = try container.decode([SpacePhoto].self, forKey: Keys.data).first!
            self.data.url = link
        }
    }
}

extension NASAResponse {

    static let photo: SpacePhoto = {
        let decoder = JSONDecoder()
        let data = Data(NASAResponse.json.utf8)
        let response = try! decoder.decode(NASAResponse.self, from: data)
        return response.collection.items[0].data
    }()

    private static let json =
    """
    {
    "collection": {
        "items": [
            {
                "links": [
                    {
                        "render": "image",
                        "rel": "preview",
                        "href": "https://www.nasa.gov/sites/default/files/thumbnails/image/m81-print.jpg"
                    }
                ],
                "data": [
                    {
                        "description_508": "Unicorns and roses are usually the stuff of fairy tales, but a new cosmic image taken by NASA WISE mission shows the Rosette nebula in the constellation Monoceros, or the Unicorn.",
                        "nasa_id": "PIA13126",
                        "title": "WISE Captures the Unicorn Rose",
                        "secondary_creator": "NASA/JPL-Caltech/UCLA",
                        "keywords": [
                            "Wide-field Infrared Survey Explorer WISE"
                        ],
                        "media_type": "image",
                        "description": "Unicorns and roses are usually the stuff of fairy tales, but a new cosmic image taken by NASA WISE mission shows the Rosette nebula in the constellation Monoceros, or the Unicorn.",
                        "date_created": "2010-08-25T23:29:38Z",
                        "center": "JPL"
                    }
                ],
                "href": "https://images-assets.nasa.gov/image/PIA13126/collection.json"
            }
        ],
        "metadata": {
            "total_hits": 6
        },
        "version": "1.0",
        "href": "http://images-api.nasa.gov/search?q=Rose%20Nebula&media_type=image"
    }
    }
    """
}
