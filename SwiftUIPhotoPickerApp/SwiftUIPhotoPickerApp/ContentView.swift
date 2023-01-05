//
//  ContentView.swift
//  SwiftUIPhotoPickerApp
//
//  Created by Gurjinder Singh on 04/01/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    //MARK: - Properties
    
    @State private var selectedItem: [PhotosPickerItem] = [PhotosPickerItem]()
    @State private var selectedImageData: [Data]? = [Data]()
    
    //MARK: - Body
    
    var body: some View {
        VStack {

                PhotosPicker(
                    selection: $selectedItem,
                    maxSelectionCount: 2,
                    matching: .images,
                    photoLibrary: .shared()
                    
                ) {
                    Text("Choose Photos from Gallery")
                        .frame(width: 350, height: 50)
                        .background(Capsule().stroke(lineWidth: 2))
                }
                .onChange(of: selectedItem) { newValue in
                    Task {
                        if let data = try? await newValue.first!.loadTransferable(type: Data.self) {
                            selectedImageData?.append(data)
                        }
                        if let data = try? await newValue.last!.loadTransferable(type: Data.self) {
                            selectedImageData?.append(data)
                        }
                    }
                }
            
            ForEach(selectedImageData!,id: \.self) { item in
                if let uiImage = UIImage(data: (item)) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16).stroke(Color.yellow, lineWidth: 8)
                        )
                }
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
