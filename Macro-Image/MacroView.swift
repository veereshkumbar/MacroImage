//
//  MacroView.swift
//  Macro-Image
//
//  Created by Veeresh Kumbar on 12/01/23.
//

import UIKit
import CoreImage


/// This enum is used for considering the types of layer
enum LayerType: String {
    case text
    case image
    case filter
}

class MacroView: UIView {
    
    var backgroundLayer = CAShapeLayer()
    var foregroundLayer = CAShapeLayer()
    
    var bgColor = UIColor.white {
        didSet {
            backgroundLayer.backgroundColor = bgColor.cgColor
        }
    }
    
    var foregroundItems: [CALayer] = [] {
        didSet {
            foregroundLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
            foregroundItems.forEach { foregroundLayer.addSublayer($0) }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundLayer.fillColor = bgColor.cgColor
        layer.addSublayer(backgroundLayer)
        
        foregroundLayer.frame = bounds
        layer.addSublayer(foregroundLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        foregroundLayer.frame = bounds
    }
    
    
    /// Adds the text to the foreground layer
    /// It removes the text layer if already existed, else it will add directly
    /// Right now it just supports adding only one text to the layer
    /// - Parameter text: text to be added
    func addText(_ text: String) {
        foregroundItems = foregroundItems.filter { $0.name != LayerType.text.rawValue }
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.alignmentMode = .center
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.frame = CGRect(x: 0, y: 10, width: self.frame.width, height: 60)
        textLayer.name = LayerType.text.rawValue
        foregroundItems.append(textLayer)
    }
    
    
    /// Adds the image to the foreground layer
    /// It removes the image layer if already existed, else it will add directly
    /// Right now it just supports adding only one image to the layer
    /// - Parameter image: image to be added of type UIImage
    func addImage(_ image: UIImage) {
        foregroundItems = foregroundItems.filter { $0.name != LayerType.image.rawValue }
        let imageLayer = CALayer()
        imageLayer.contents = image.cgImage
        imageLayer.contentsGravity = .resizeAspect
        imageLayer.frame = CGRect(x: 0, y: 80, width: self.frame.width, height: self.frame.height-80)
        imageLayer.name = LayerType.image.rawValue
        foregroundItems.append(imageLayer)
    }
    
    
    /// removes the filter
    func removeFilter() {
        foregroundItems = foregroundItems.filter{ $0.name != LayerType.filter.rawValue }
    }
    
    /// Applies the black and white filter
    func applyBlackAndWhiteFilter() {
        guard let image = self.createImage() else { return }
        let ciInput = CIImage(image: image)
        let filter = CIFilter(name: "CIPhotoEffectNoir")
            filter?.setValue(ciInput, forKey: "inputImage")
        
        if let ciOutput = filter?.outputImage {
            let ciContext = CIContext()
            let cgImage = ciContext.createCGImage(ciOutput, from: (ciOutput.extent))
            let filteredCIImageView = UIImageView(frame: bounds)
            filteredCIImageView.image = UIImage(cgImage: cgImage!)
            filteredCIImageView.contentMode = .scaleAspectFit
            let bwLayer = filteredCIImageView.layer
            bwLayer.name = LayerType.filter.rawValue
            foregroundItems.append(filteredCIImageView.layer)
        }
    }
}


extension UIView {
    
    /// Creates a image from the content provided inside a view
    /// - Returns: returns created image
    public func createImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.frame.width, height: self.frame.height), true, 1)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
