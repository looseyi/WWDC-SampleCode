//
//  CatalogView.swift
//  Shared
//
//  Created by Edmond on 2021/6/12.
//

import SwiftUI

struct CatalogView: View {

    @StateObject private var photos = Photos()

    private var photoKey = [String : SpacePhoto]()

    var body: some View {
        NavigationView {
            List {
                ForEach(photos.items) { item in
                    PhotoView(photo: item)
                        .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Catalog")
            .listStyle(.plain)
            .refreshable {
                await photos.updateItems()
            }
        }
        .task {
            await photos.updateItems()
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
            .preferredColorScheme(.dark)
            .previewLayout(PreviewLayout.sizeThatFits)

    }
}
