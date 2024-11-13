import SwiftUI
import AVFoundation

struct HomeView: View {
    @StateObject private var cameraViewModel = CameraViewModel()
    @State private var showingImageReview = false
    @State private var capturedImage: UIImage?
    
    var body: some View {
        ZStack {
            CameraPreview(session: cameraViewModel.session)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Take a pic of your homework")
                    .font(.headline)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                Spacer()
                
                Button(action: capturePhoto) {
                    Image(systemName: "camera")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            cameraViewModel.checkCameraPermissions()
        }
        .fullScreenCover(isPresented: $showingImageReview) {
            imageReviewView()
        }
    }
    
    private func capturePhoto() {
        cameraViewModel.capturePhoto { image in
            capturedImage = image
            showingImageReview = true
        }
    }
    
    @ViewBuilder
    private func imageReviewView() -> some View {
        if let image = capturedImage {
            ImageReviewView(image: image) { croppedImage in
                // Handle the cropped image (e.g., send to AI for processing)
                print("Cropped image received, size: \(croppedImage.size)")
            }
        }
    }
}

