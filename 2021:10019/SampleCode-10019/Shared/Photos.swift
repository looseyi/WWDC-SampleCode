//
//  Photos.swift
//  SampleCode-10019
//
//  Created by Edmond on 2021/6/12.
//

import Foundation

// the current collection of space photos.

@MainActor
class Photos: ObservableObject {

    @Published private(set) var items: [SpacePhoto] = []

    // Updates `items` to a new, random list of photos.
    func updateItems() async {
        let fetched = await fetchPhotos()
        items = fetched
    }

    // Fetches a new, random list of photos.
    func fetchPhotos() async -> [SpacePhoto] {
        var downloaded: [SpacePhoto] = []
        for query in Photos.keys {
            let url = SpacePhoto.request(key: query)
            if let photo = await fetchPhoto(from: url) {
                downloaded.append(photo)
            }
        }
        return downloaded
    }

    func fetchPhoto(from url: URL) async -> SpacePhoto? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(NASAResponse.self, from: data)
            return response.collection.items.randomElement()?.data
        } catch {
            print(error)
            return nil
        }
    }
}

extension SpacePhoto {

    // [api docs](https://images.nasa.gov/docs/images.nasa.gov_api_docs.pdf)
    static func request(key: String) -> URL {
        let baseURL = URL(string: "https://images-api.nasa.gov/search")!
        let queryParams = [
            "q": key,
            "media_type": "image",
        ]
        let url = baseURL.withQueries(queryParams)!

        return url
    }
}

extension Photos {

    static let keys = [
        "Messier 81",
        "Sh2-86 and NGC 6823",
        "NGC 281",
        "Milky Way",
        "Valentine Rose Nebula",
        "NGC 2237",
        "Messier 51",
        "Milky Way over Observatory",
        "IC1318, Butterfly Nebula",
        "Rosette Nebula"
    ]
}

extension URL {

    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap({ URLQueryItem(name: $0.0, value: $0.1) })
        return components?.url
    }
}

private let ISODateFormatter = ISO8601DateFormatter()
private let DefautlDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd"
    return  f
}()
