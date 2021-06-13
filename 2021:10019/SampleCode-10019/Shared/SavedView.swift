//
//  SavedView.swift
//  SampleCode-10019
//
//  Created by Edmond on 2021/6/12.
//

import SwiftUI

struct SavedView: View {

    var body: some View {
        HStack {
            Text(NASAResponse.photo.title)
            Spacer()
            SavePhotoButton(photo: NASAResponse.photo)
        }
    }
}

struct SavePhotoButton: View {

    var photo: SpacePhoto
    @State private var isSaving = false

    var body: some View {
        Button {
            async {
                isSaving = true
                await photo.save()
                isSaving = false
            }
        } label: {
            Text("Saved")
                .opacity(isSaving ? 0 : 1)
                .overlay {
                    if isSaving {
                        ProgressView()
                    }
                }
        }
        .disabled(isSaving)
        .buttonStyle(.bordered)
        .controlSize(.small) // .large, .medium or .small
    }
}

extension SpacePhoto {

    public func save() async {
        DispatchQueue.global().sync {
            Dispatch.sleep(3)
            print("sleep 3")
        }
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
            .preferredColorScheme(.dark)
//            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
