//
//  AddView.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 13/11/24.
//



import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct AddView: View {
    @ObservedObject var viewModel: SwipeVM
    @State private var isPickerPresented = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                Spacer()
                    Text("Add New Product")
                        .font(.customTitleFont(size: 23))
                        .foregroundColor(.white)
                .padding()
                VStack(spacing: 10) {
                    Text("Select the Product Type")
                        .font(.customFont(size: 23))
                        .foregroundColor(.white)
                    Picker("Product Type", selection: $viewModel.productType) {
                        Text("Select Product Type").tag("")
                        Text("Electronics").tag("Electronics")
                        Text("Clothing").tag("Clothing")
                        Text("Groceries").tag("Groceries")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(.white)
                    
                    Text("Enter the Product Name")
                        .font(.customFont(size: 23))
                        .foregroundColor(.white)
                    TextFieldView(text: $viewModel.productName, value: .constant(0), isNumeric: false)
                    
                    Text("Enter the Price")
                        .font(.customFont(size: 23))
                        .foregroundColor(.white)
                    TextFieldView(text: .constant(""), value: $viewModel.price, isNumeric: true)
                        .keyboardType(.numberPad)
                    
                    Text("Enter the Tax Rate")
                        .font(.customFont(size: 23))
                        .foregroundColor(.white)
                    TextFieldView(text: .constant(""), value: $viewModel.taxRate, isNumeric: true)
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        isPickerPresented = true
                    }) {
                        Text("Select Image")
                            .font(.customFont(size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                    .padding(.top, 10)
                    .sheet(isPresented: $isPickerPresented) {
                        PhotoPicker(selectedImage: $viewModel.selectedImage)
                    }

                    // Display selected image
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding(.top, 10)
                    }
                }

                Button(action: {
                    viewModel.postSwipeData()
                    
                }) {
                    Text("Add Product")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                }
                .padding()
                

              

                // Displaying Feedback Messages
                if !viewModel.successMessage.isEmpty {
                    Text(viewModel.successMessage)
                        .foregroundColor(.green)
                } else if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .background(Color.customBlack)
        .frame(maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
    }
}



struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // Only allow image selection
        configuration.selectionLimit = 1 // Limit to 1 selection
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            // Load the image
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self, let image = image as? UIImage else { return }
                    let resizedImage = self.resizeToSquare(image: image) // Crop to 1:1
                    DispatchQueue.main.async {
                        print("Selected Image: \(resizedImage)")
                        self.parent.selectedImage = resizedImage
                    }
                }
            } else {
                print("Selected file is not a supported image.")
            }
        }

        private func resizeToSquare(image: UIImage) -> UIImage? {
            // Ensure the image has both width and height
            let sideLength = min(image.size.width, image.size.height) // Ensure the side length is the smaller dimension

            // Calculate the cropping rectangle
            let rect = CGRect(
                x: (image.size.width - sideLength) / 2,  // X origin for centering
                y: (image.size.height - sideLength) / 2, // Y origin for centering
                width: sideLength,  // Width of the square
                height: sideLength   // Height of the square
            )
            
            // Crop the image to a square (1:1 ratio)
            guard let cgImage = image.cgImage?.cropping(to: rect) else {
                print("Failed to crop image to square.")
                return nil
            }

            // Return the cropped image as a UIImage
            
            return UIImage(cgImage: cgImage)
        }

    }
}


struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        let swipeVM = SwipeVM()
        AddView(viewModel: swipeVM)
    }
}

