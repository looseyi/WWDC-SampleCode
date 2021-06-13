//
//  PhotoView.swift
//  SampleCode-10019
//
//  Created by Edmond on 2021/6/12.
//

import SwiftUI

struct PhotoView: View {

    var photo: SpacePhoto

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: photo.url.href) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(minWidth: 0, minHeight: 400)

            HStack {
                Text(photo.title)
                Spacer()
                SavePhotoButton(photo: photo)
            }
            .padding()
            .background(.thinMaterial)
        }
        .background(.thickMaterial)
        .mask(RoundedRectangle(cornerRadius: 8))
        .padding(.bottom, 8)
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo: NASAResponse.photo)
            .preferredColorScheme(.dark)
    }
}
