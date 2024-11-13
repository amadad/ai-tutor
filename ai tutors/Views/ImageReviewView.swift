import SwiftUI

struct ImageReviewView: View {
    @StateObject private var viewModel: ImageProcessingViewModel
    @Environment(\.dismiss) private var dismiss
    var onConfirm: (UIImage) -> Void
    
    init(image: UIImage?, onConfirm: @escaping (UIImage) -> Void) {
        _viewModel = StateObject(wrappedValue: ImageProcessingViewModel(image: image))
        self.onConfirm = onConfirm
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            BoundingBoxOverlay(viewModel: viewModel)
                        )
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                        Spacer()
                        Button(action: confirmImage) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func confirmImage() {
        if let croppedImage = viewModel.cropImage() {
            onConfirm(croppedImage)
        }
        dismiss()
    }
}

struct BoundingBoxOverlay: View {
    @ObservedObject var viewModel: ImageProcessingViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.5)
                    .mask(
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .overlay(
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: viewModel.boundingBox.width, height: viewModel.boundingBox.height)
                                    .position(x: viewModel.boundingBox.midX, y: viewModel.boundingBox.midY)
                            )
                            .compositingGroup()
                            .luminanceToAlpha()
                    )
                
                ForEach(0..<4) { index in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 16, height: 16)
                        .position(viewModel.cornerPoints[index])
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    viewModel.moveCorner(at: index, to: value.location)
                                }
                        )
                }
            }
        }
    }
}