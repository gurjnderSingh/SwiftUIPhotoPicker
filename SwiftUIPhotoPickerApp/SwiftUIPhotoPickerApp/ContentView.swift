//
//  ContentView.swift
//  SwiftUIPhotoPickerApp
//
//  Created by Gurjinder Singh on 04/01/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        VStack {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("Choose Photo")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(width: 350, height: 50)
                        .background(Capsule().stroke(lineWidth: 2))
                }
                .onChange(of: selectedItem) { newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
