import SwiftUI
import Combine

class ImageProcessingViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var boundingBox: CGRect = .zero
    @Published var cornerPoints: [CGPoint] = []
    
    private let cornerSize: CGFloat = 16.0
    
    init(image: UIImage?) {
        self.image = image
        resetBoundingBox()
    }
    
    func resetBoundingBox() {
        guard let image = image else { return }
        let imageSize = image.size
        let padding: CGFloat = 20
        boundingBox = CGRect(x: padding, y: padding,
                             width: imageSize.width - 2 * padding,
                             height: imageSize.height - 2 * padding)
        updateCornerPoints()
    }
    
    func updateCornerPoints() {
        cornerPoints = [
            CGPoint(x: boundingBox.minX, y: boundingBox.minY),
            CGPoint(x: boundingBox.maxX, y: boundingBox.minY),
            CGPoint(x: boundingBox.minX, y: boundingBox.maxY),
            CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
        ]
    }
    
    func moveCorner(at index: Int, to point: CGPoint) {
        guard index >= 0 && index < 4 else { return }
        
        var newBox = boundingBox
        switch index {
        case 0: // Top-left
            newBox.origin = point
        case 1: // Top-right
            newBox.size.width = point.x - newBox.origin.x
            newBox.origin.y = point.y
        case 2: // Bottom-left
            newBox.size.height = point.y - newBox.origin.y
            newBox.origin.x = point.x
        case 3: // Bottom-right
            newBox.size.width = point.x - newBox.origin.x
            newBox.size.height = point.y - newBox.origin.y
        default:
            break
        }
        
        boundingBox = newBox
        updateCornerPoints()
    }
    
    func cropImage() -> UIImage? {
        guard let image = image else { return nil }
        let scale = image.scale
        let scaledRect = CGRect(x: boundingBox.origin.x * scale,
                                y: boundingBox.origin.y * scale,
                                width: boundingBox.size.width * scale,
                                height: boundingBox.size.height * scale)
        
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: image.imageOrientation)
    }
}