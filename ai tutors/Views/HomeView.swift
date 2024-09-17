import SwiftUI
import AVFoundation

struct HomeView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var isImageReviewPresented = false

    var body: some View {
        ZStack {
            CameraPreviewView(session: viewModel.session)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Take a pic of your homework")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(10)
                    .padding(.top, 50)

                Spacer()

                Button(action: {
                    viewModel.capturePhoto()
                    isImageReviewPresented = true
                }) {
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear(perform: viewModel.startCameraSession)
        .sheet(isPresented: $isImageReviewPresented) {
            if let capturedImage = viewModel.capturedImage {
                ImageReviewView(image: capturedImage)
            }
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}