import SwiftUI

struct ImageReviewView: View {
    let image: UIImage
    @State private var boundingBox = CGRect(x: 50, y: 50, width: 200, height: 200)
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                BoundingBoxView(rect: $boundingBox)

                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        Spacer()
                        Button(action: {
                            // TODO: Implement confirmation action
                        }) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BoundingBoxView: View {
    @Binding var rect: CGRect
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .mask(
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .overlay(
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: rect.width, height: rect.height)
                                .position(x: rect.midX, y: rect.midY)
                        )
                        .compositingGroup()
                        .luminanceToAlpha()
                )
            
            Path { path in
                path.addRect(rect)
            }
            .stroke(Color.white, lineWidth: 2)
            
            ForEach(0..<4) { i in
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .position(cornerPosition(for: i))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                updateRect(for: i, with: value)
                            }
                    )
            }
        }
    }
    
    private func cornerPosition(for index: Int) -> CGPoint {
        switch index {
        case 0: return CGPoint(x: rect.minX, y: rect.minY)
        case 1: return CGPoint(x: rect.maxX, y: rect.minY)
        case 2: return CGPoint(x: rect.maxX, y: rect.maxY)
        case 3: return CGPoint(x: rect.minX, y: rect.maxY)
        default: return .zero
        }
    }
    
    private func updateRect(for index: Int, with value: DragGesture.Value) {
        var newRect = rect
        switch index {
        case 0:
            newRect.origin = CGPoint(x: min(value.location.x, rect.maxX - 50), y: min(value.location.y, rect.maxY - 50))
            newRect.size = CGSize(width: rect.maxX - newRect.origin.x, height: rect.maxY - newRect.origin.y)
        case 1:
            newRect.size.width = max(value.location.x - rect.minX, 50)
            newRect.origin.y = min(value.location.y, rect.maxY - 50)
            newRect.size.height = rect.maxY - newRect.origin.y
        case 2:
            newRect.size = CGSize(width: max(value.location.x - rect.minX, 50), height: max(value.location.y - rect.minY, 50))
        case 3:
            newRect.origin.x = min(value.location.x, rect.maxX - 50)
            newRect.size = CGSize(width: rect.maxX - newRect.origin.x, height: max(value.location.y - rect.minY, 50))
        default:
            break
        }
        rect = newRect
    }
}