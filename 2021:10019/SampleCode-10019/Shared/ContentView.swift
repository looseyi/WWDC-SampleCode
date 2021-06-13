//
//  ContentView.swift
//  SampleCode-10019
//
//  Created by Edmond on 2021/6/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CatalogView().tabItem {
                Label("Catalog", systemImage: "book")
            }
            SavedView().tabItem {
                Label("Saved", systemImage: "folder")
            }
        }
        .accentColor(.purple)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
