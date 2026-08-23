import SwiftUI
import UIKit

/// Renderiza cualquier vista SwiftUI (el roadmap) a una UIImage de alta resolución
/// usando ImageRenderer, para poder guardarla en Fotos o compartirla.
@MainActor
enum RoadmapImageGenerator {

    static func render<Content: View>(_ view: Content, scale: CGFloat = 3.0) -> UIImage? {
        let renderer = ImageRenderer(content: view)
        renderer.scale = scale
        return renderer.uiImage
    }
}
