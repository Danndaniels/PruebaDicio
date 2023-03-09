//
//  Extension+UIImage.swift
//  PruebaDicio
//
//  Created by Daniel Acosta on 08/03/23.
//
import UIKit

extension UIImage {

    enum Format: String {
        case png = "png"
        case jpeg = "jpeg"
    }
    
    func cropToBoundsCenter(width: Double, height: Double) -> UIImage {

        let contextImage: UIImage = UIImage(cgImage: self.cgImage!)

        let contextSize: CGSize = contextImage.size

        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }

        let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        return image
    }

    func toBase64(type: Format = .png, quality: CGFloat = 1, addMimePrefix: Bool = false) -> String? {
        let imageData: Data?
        switch type {
        case .jpeg: imageData = jpegData(compressionQuality: quality)
        case .png:  imageData = pngData()
        }
        guard let data = imageData else { return nil }

        let base64 = data.base64EncodedString()

        var result = base64
        if addMimePrefix {
            let prefix = "data:image/\(type.rawValue);base64,"
            result = prefix + base64
        }
        return result
    }
}
