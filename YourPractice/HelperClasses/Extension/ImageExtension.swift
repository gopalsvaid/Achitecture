//
//  ImageExtension.swift
//  YourPractice
//
//  Created by Devangi Shah on 05/03/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import Foundation
import CoreImage
import UIKit
import Accelerate

enum MVImageFlip : UInt {
    case MVImageFlipXAxis
    case MVImageFlipYAxis
    case MVImageFlipXAxisAndYAxis
    case MVImageFlip_NOTDEFINED
}

extension UIImage{
    
    // Returns true if the image has an alpha layer
    func hasAlpha() -> Bool {
        let alpha: CGImageAlphaInfo = (self.cgImage)!.alphaInfo
        return
            alpha == CGImageAlphaInfo.first ||
                alpha == CGImageAlphaInfo.last ||
                alpha == CGImageAlphaInfo.premultipliedFirst ||
                alpha == CGImageAlphaInfo.premultipliedLast
    }
    
    // Returns a copy of the given image, adding an alpha channel if it doesn't already have one
    func imageWithAlpha() -> UIImage {
        if self.hasAlpha() {
            return self
        }
        
        let imageRef:CGImage = self.cgImage!
        let width  = imageRef.width
        let height = imageRef.height
        
        // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
        let offscreenContext: CGContext = CGContext(
            data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
            space: imageRef.colorSpace!,
            bitmapInfo: 0 /*CGImageByteOrderInfo.orderMask.rawValue*/ | CGImageAlphaInfo.premultipliedFirst.rawValue
            )!
        
        // Draw the image into the context and retrieve the new image, which will now have an alpha layer
        offscreenContext.draw(imageRef, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let imageRefWithAlpha:CGImage = offscreenContext.makeImage()!
        
        return UIImage(cgImage: imageRefWithAlpha)
    }
    
    // Returns a copy of the image with a transparent border of the given size added around its edges.
    // If the image has no alpha layer, one will be added to it.
    func transparentBorderImage(_ borderSize: Int) -> UIImage {
        let image = self.imageWithAlpha()
        
        let newRect = CGRect(
            x: 0, y: 0,
            width: image.size.width + CGFloat(borderSize) * 2,
            height: image.size.height + CGFloat(borderSize) * 2
        )
        
        
        // Build a context that's the same dimensions as the new size
        let bitmap: CGContext = CGContext(
            data: nil,
            width: Int(newRect.size.width), height: Int(newRect.size.height),
            bitsPerComponent: (self.cgImage)!.bitsPerComponent,
            bytesPerRow: 0,
            space: (self.cgImage)!.colorSpace!,
            bitmapInfo: (self.cgImage)!.bitmapInfo.rawValue
            )!
        
        // Draw the image in the center of the context, leaving a gap around the edges
        let imageLocation = CGRect(x: CGFloat(borderSize), y: CGFloat(borderSize), width: image.size.width, height: image.size.height)
        bitmap.draw(self.cgImage!, in: imageLocation)
        let borderImageRef: CGImage = bitmap.makeImage()!
        
        // Create a mask to make the border transparent, and combine it with the image
        let maskImageRef: CGImage = self.newBorderMask(borderSize, size: newRect.size)
        let transparentBorderImageRef: CGImage = borderImageRef.masking(maskImageRef)!
        return UIImage(cgImage:transparentBorderImageRef)
    }
    
    // Creates a mask that makes the outer edges transparent and everything else opaque
    // The size must include the entire mask (opaque part + transparent border)
    // The caller is responsible for releasing the returned reference by calling CGImageRelease
    func newBorderMask(_ borderSize: Int, size: CGSize) -> CGImage {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        
        // Build a context that's the same dimensions as the new size
        let maskContext: CGContext = CGContext(
            data: nil,
            width: Int(size.width), height: Int(size.height),
            bitsPerComponent: 8, // 8-bit grayscale
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo().rawValue | CGImageAlphaInfo.none.rawValue
            )!
        
        // Start with a mask that's entirely transparent
        maskContext.setFillColor(UIColor.black.cgColor)
        maskContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Make the inner part (within the border) opaque
        maskContext.setFillColor(UIColor.white.cgColor)
        maskContext.fill(CGRect(
            x: CGFloat(borderSize),
            y: CGFloat(borderSize),
            width: size.width - CGFloat(borderSize) * 2,
            height: size.height - CGFloat(borderSize) * 2)
        )
        
        // Get an image of the context
        return maskContext.makeImage()!
    }
    
    
    // Creates a copy of this image with rounded corners
    // If borderSize is non-zero, a transparent border of the given size will also be added
    // Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
    func roundedCornerImage(cornerSize:Int, borderSize:Int) -> UIImage
    {
        // If the image does not have an alpha layer, add one
        let image = self.imageWithAlpha()
        
        // Build a context that's the same dimensions as the new size
        let context: CGContext = CGContext(
            data: nil,
            width: Int(image.size.width),
            height: Int(image.size.height),
            bitsPerComponent: (image.cgImage)!.bitsPerComponent,
            bytesPerRow: 0,
            space: (image.cgImage)!.colorSpace!,
            bitmapInfo: (image.cgImage)!.bitmapInfo.rawValue
            )!
        
        // Create a clipping path with rounded corners
        context.beginPath()
        self.addRoundedRectToPath(
            CGRect(
                x: CGFloat(borderSize),
                y: CGFloat(borderSize),
                width: image.size.width - CGFloat(borderSize) * 2,
                height: image.size.height - CGFloat(borderSize) * 2),
            context:context,
            ovalWidth:CGFloat(cornerSize),
            ovalHeight:CGFloat(cornerSize)
        )
        context.closePath()
        context.clip()
        
        // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // Create a CGImage from the context
        let clippedImage: CGImage = context.makeImage()!
        
        // Create a UIImage from the CGImage
        return UIImage(cgImage: clippedImage)
    }
    
    // Adds a rectangular path to the given context and rounds its corners by the given extents
    // Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
    func addRoundedRectToPath(_ rect: CGRect, context: CGContext, ovalWidth: CGFloat, ovalHeight: CGFloat)
    {
        if (ovalWidth == 0 || ovalHeight == 0) {
            context.addRect(rect)
            return
        }
        
        context.saveGState()
        context.translateBy(x: rect.minX, y: rect.minY)
        context.scaleBy(x: ovalWidth, y: ovalHeight)
        let fw = rect.width / ovalWidth
        let fh = rect.height / ovalHeight
        context.move(to: CGPoint(x: fw, y: fh/2))
        context.addArc(tangent1End: CGPoint(x: fw, y: fh), tangent2End: CGPoint(x: fw/2, y: fh), radius: 1)
        context.addArc(tangent1End: CGPoint(x: 0, y: fh), tangent2End: CGPoint(x: 0, y: fh/2), radius: 1)
        context.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: fw/2, y: 0), radius: 1)
        context.addArc(tangent1End: CGPoint(x: fw, y: 0), tangent2End: CGPoint(x: fw, y: fh/2), radius: 1)
        
        context.closePath();
        context.restoreGState()
    }
    
    // Returns a copy of this image that is cropped to the given bounds.
    // The bounds will be adjusted using CGRectIntegral.
    // This method ignores the image's imageOrientation setting.
    func croppedImage(_ bounds: CGRect) -> UIImage {
        let imageRef: CGImage = (self.cgImage)!.cropping(to: bounds)!
        return UIImage(cgImage: imageRef)
    }
    
    // Returns a copy of this image that is squared to the thumbnail size.
    // If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
    func thumbnailImage(_ thumbnailSize: Int, transparentBorder borderSize:Int, cornerRadius:Int, interpolationQuality quality:CGInterpolationQuality) -> UIImage {
        let resizedImage = self.resizedImageWithContentMode(.scaleAspectFill, bounds: CGSize(width: CGFloat(thumbnailSize), height: CGFloat(thumbnailSize)), interpolationQuality: quality)
        
        // Crop out any part of the image that's larger than the thumbnail size
        // The cropped rect must be centered on the resized image
        // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
        let cropRect = CGRect(
            x: round((resizedImage.size.width - CGFloat(thumbnailSize))/2),
            y: round((resizedImage.size.height - CGFloat(thumbnailSize))/2),
            width: CGFloat(thumbnailSize),
            height: CGFloat(thumbnailSize)
        )
        
        let croppedImage = resizedImage.croppedImage(cropRect)
        let transparentBorderImage = borderSize != 0 ? croppedImage.transparentBorderImage(borderSize) : croppedImage
        
        return transparentBorderImage.roundedCornerImage(cornerSize: cornerRadius, borderSize: borderSize)
    }
    
    // Returns a rescaled copy of the image, taking into account its orientation
    // The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
    func resizedImage(_ newSize: CGSize, interpolationQuality quality: CGInterpolationQuality) -> UIImage {
        var drawTransposed: Bool
        
        switch(self.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            drawTransposed = true
        default:
            drawTransposed = false
        }
        
        return self.resizedImage(
            newSize,
            transform: self.transformForOrientation(newSize),
            drawTransposed: drawTransposed,
            interpolationQuality: quality
        )
    }
    
    // Resizes the image according to the given content mode, taking into account the image's orientation
    func resizedImageWithContentMode(_ contentMode: UIView.ContentMode, bounds: CGSize, interpolationQuality quality: CGInterpolationQuality) -> UIImage {
        let horizontalRatio = bounds.width / self.size.width
        let verticalRatio = bounds.height / self.size.height
        var ratio: CGFloat = 1
        
        switch(contentMode) {
        case .scaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .scaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        default:
            fatalError("Unsupported content mode \(contentMode)")
        }
        
        let newSize: CGSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        return self.resizedImage(newSize, interpolationQuality: quality)
    }
    
    func normalizeBitmapInfo(_ bI: CGBitmapInfo) -> UInt32 {
        var alphaInfo: UInt32 = bI.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        if alphaInfo == CGImageAlphaInfo.last.rawValue {
            alphaInfo =  CGImageAlphaInfo.premultipliedLast.rawValue
        }
        
        if alphaInfo == CGImageAlphaInfo.first.rawValue {
            alphaInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        }
        
        var newBI: UInt32 = bI.rawValue & ~CGBitmapInfo.alphaInfoMask.rawValue;
        
        newBI |= alphaInfo;
        
        return newBI
    }
    // Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
    // The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
    // If the new size is not integral, it will be rounded up
    func resizedImage(_ newSize: CGSize, transform: CGAffineTransform, drawTransposed transpose: Bool, interpolationQuality quality: CGInterpolationQuality) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        let transposedRect = CGRect(x: 0, y: 0, width: newRect.size.height, height: newRect.size.width)
        let imageRef: CGImage = self.cgImage!
        
        // Build a context that's the same dimensions as the new size
        let bitmap: CGContext = CGContext(
            data: nil,
            width: Int(newRect.size.width),
            height: Int(newRect.size.height),
            bitsPerComponent: imageRef.bitsPerComponent,
            bytesPerRow: 0,
            space: imageRef.colorSpace!,
            bitmapInfo: normalizeBitmapInfo(imageRef.bitmapInfo)
            )!
        
        // Rotate and/or flip the image if required by its orientation
        bitmap.concatenate(transform)
        
        // Set the quality level to use when rescaling
        bitmap.interpolationQuality = quality
        
        // Draw into the context; this scales the image
        bitmap.draw(imageRef, in: transpose ? transposedRect: newRect)
        
        // Get the resized image from the context and a UIImage
        let newImageRef: CGImage = bitmap.makeImage()!
        return UIImage(cgImage: newImageRef)
    }
    
    // Returns an affine transform that takes into account the image orientation when drawing a scaled image
    func transformForOrientation(_ newSize: CGSize) -> CGAffineTransform {
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch (self.imageOrientation) {
        case .down, .downMirrored:
            // EXIF = 3 / 4
            transform = transform.translatedBy(x: newSize.width, y: newSize.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            // EXIF = 6 / 5
            transform = transform.translatedBy(x: newSize.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            // EXIF = 8 / 7
            transform = transform.translatedBy(x: 0, y: newSize.height)
            transform = transform.rotated(by: -.pi / 2)
        default:
            break
        }
        
        switch(self.imageOrientation) {
        case .upMirrored, .downMirrored:
            // EXIF = 2 / 4
            transform = transform.translatedBy(x: newSize.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            // EXIF = 5 / 7
            transform = transform.translatedBy(x: newSize.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        return transform
    }
    
    
    // MARK: - Effects
    
    func appliedLightEffect() -> UIImage? {
        let tintColor = UIColor(white: 1.0, alpha: 0.3)
        return appliedBlur(withRadius: 60, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func appliedExtraLightEffect() -> UIImage? {
        let tintColor = UIColor(white: 0.97, alpha: 0.82)
        return appliedBlur(withRadius: 40, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func appliedDarkEffect() -> UIImage? {
        let tintColor = UIColor(white: 0.11, alpha: 0.73)
        return appliedBlur(withRadius: 40, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func appliedTintEffectWithColor(tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        if tintColor.cgColor.numberOfComponents == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
            if tintColor.getRed(&r, green: &g, blue: &b, alpha: nil) {
                effectColor = UIColor(red: r, green: g, blue: b, alpha: effectColorAlpha)
            }
        }
        return appliedBlur(withRadius: 20, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
    
    // MARK: - Implementation
    
    /// Applies a blur, tint color, and saturation adjustment to inputImage,
    /// optionally within the area specified by @a maskImage.
    ///
    /// - Parameter blurRadius:
    ///         The radius of the blur in points.
    /// - Parameter tintColor:
    ///         An optional UIColor object that is uniformly blended with the result of the blur and saturation operations.
    ///         The alpha channel of this color determines how strong the tint is.
    /// - Parameter saturationDeltaFactor:
    ///         A value of 1.0 produces no change in the resulting image.
    ///         Values less than 1.0 will desaturation the resulting image
    ///         while values greater than 1.0 will have the opposite effect.
    /// - Parameter maskImage:
    ///         If specified, inputImage is only modified in the area(s) defined by this mask.
    ///         This must be an image mask or it must meet the requirements of the mask parameter of CGContextClipToMask.
    func appliedBlur(withRadius blurRadius: CGFloat, tintColor: UIColor? = nil, saturationDeltaFactor: CGFloat = 1.0, maskImage: UIImage? = nil) -> UIImage? {
        // Check pre-conditions.
        if size.width < 1 || size.height < 1 {
            NSLog("*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", size.width, size.height, self)
            return nil
        }
        guard let inputCGImage = cgImage else {
            NSLog("*** error: inputImage must be backed by a CGImage: %@", self)
            return nil
        }
        if let maskImage = maskImage, maskImage.cgImage == nil {
            NSLog("*** error: effectMaskImage must be backed by a CGImage: %@", maskImage)
            return nil
        }
        
        let hasBlur = blurRadius > .ulpOfOne
        let hasSaturationChange = abs(saturationDeltaFactor - 1.0) > .ulpOfOne
        
        let inputImageScale = scale
        let inputImageAlphaInfo = CGImageAlphaInfo(rawValue: inputCGImage.bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
        
        let outputImageSizeInPoints = size
        let outputImageRectInPoints = CGRect(origin: .zero, size: outputImageSizeInPoints)
        
        // Set up output context.
        let useOpaqueContext = inputImageAlphaInfo == .none || inputImageAlphaInfo == .noneSkipLast || inputImageAlphaInfo == .noneSkipFirst
        UIGraphicsBeginImageContextWithOptions(outputImageRectInPoints.size, useOpaqueContext, inputImageScale)
        defer { UIGraphicsEndImageContext() }
        let outputContext = UIGraphicsGetCurrentContext()!
        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -outputImageRectInPoints.size.height)
        
        if hasBlur || hasSaturationChange {
            // requests a BGRA buffer.
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
            var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                              bitsPerPixel: 32,
                                              colorSpace: nil,
                                              bitmapInfo: bitmapInfo,
                                              version: 0,
                                              decode: nil,
                                              renderingIntent: CGColorRenderingIntent.defaultIntent)
            
            var inputBuffer = vImage_Buffer()
            var outputBuffer = vImage_Buffer()
            
            let e: vImage_Error = vImageBuffer_InitWithCGImage(&inputBuffer, &format, nil, inputCGImage, vImage_Flags(kvImagePrintDiagnosticsToConsole))
            if e != kvImageNoError {
                NSLog("*** error: vImageBuffer_InitWithCGImage returned error code %zi for inputImage: %@", e, self)
                return nil
            }
            
            vImageBuffer_Init(&outputBuffer, inputBuffer.height, inputBuffer.width, format.bitsPerPixel, vImage_Flags(kvImageNoFlags))
            
            if hasBlur {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                var inputRadius = blurRadius * inputImageScale
                if inputRadius - 2.0 < .ulpOfOne {
                    inputRadius = 2.0
                }
                
                var radius = UInt32(floor((inputRadius * 3.0 * sqrt(2 * .pi) as CGFloat / 4 + 0.5) / 2) as CGFloat)
                
                radius |= 1 // force radius to be odd so that the three box-blur methodology works.
                
                let tempBufferSize = vImageBoxConvolve_ARGB8888(&inputBuffer, &outputBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageGetTempBufferSize | kvImageEdgeExtend))
                let tempBuffer = malloc(tempBufferSize)
                
                vImageBoxConvolve_ARGB8888(&inputBuffer, &outputBuffer, tempBuffer, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&outputBuffer, &inputBuffer, tempBuffer, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&inputBuffer, &outputBuffer, tempBuffer, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                
                free(tempBuffer)
                
                let temp = inputBuffer
                inputBuffer = outputBuffer
                outputBuffer = temp
            }
            
            if hasSaturationChange {
                let s = saturationDeltaFactor
                // These values from Apple appear in the W3C Filter Effects spec:
                // https://www.w3.org/TR/filter-effects-1/#grayscaleEquivalent
                //
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.072_2 + 0.927_8 * s,  0.072_2 - 0.072_2 * s,  0.072_2 - 0.072_2 * s,  0,
                    0.715_2 - 0.715_2 * s,  0.715_2 + 0.284_8 * s,  0.715_2 - 0.715_2 * s,  0,
                    0.212_6 - 0.212_6 * s,  0.212_6 - 0.212_6 * s,  0.212_6 + 0.787_3 * s,  0,
                    0,                      0,                      0,                      1,
                    ]
                let divisor: CGFloat = 256
                let saturationMatrix: [Int16] = floatingPointSaturationMatrix.map { Int16(roundf(Float($0 * divisor))) }
                vImageMatrixMultiply_ARGB8888(&inputBuffer, &outputBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                
                let temp = inputBuffer
                inputBuffer = outputBuffer
                outputBuffer = temp
            }
            
            ///  Helper function to handle deferred cleanup of a buffer.
            func cleanupBuffer(_ userData: UnsafeMutableRawPointer?, _ bufData: UnsafeMutableRawPointer?) {
                free(bufData)
            }
            
            var effectCGImage = vImageCreateCGImageFromBuffer(&inputBuffer, &format, cleanupBuffer, nil, vImage_Flags(kvImageNoAllocate), nil)?.takeRetainedValue()
            if effectCGImage == nil {
                effectCGImage = vImageCreateCGImageFromBuffer(&inputBuffer, &format, nil, nil, vImage_Flags(kvImageNoFlags), nil)!.takeRetainedValue()
                free(inputBuffer.data)
            }
            if maskImage != nil {
                // Only need to draw the base image if the effect image will be masked.
                outputContext.draw(inputCGImage, in: outputImageRectInPoints)
            }
            
            // draw effect image
            outputContext.saveGState()
            if let maskImage = maskImage {
                outputContext.clip(to: outputImageRectInPoints, mask: maskImage.cgImage!)
            }
            outputContext.draw(effectCGImage!, in: outputImageRectInPoints)
            outputContext.restoreGState()
            
            // Cleanup
            free(outputBuffer.data)
        } else {
            // draw base image
            outputContext.draw(inputCGImage, in: outputImageRectInPoints)
        }
        
        // Add in color tint.
        if let tintColor = tintColor {
            outputContext.saveGState()
            outputContext.setFillColor(tintColor.cgColor)
            outputContext.fill(outputImageRectInPoints)
            outputContext.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        return outputImage
    }
    
    func fixedOrientation() -> UIImage {
        
        if imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi))
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        switch imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(origin: CGPoint.zero, size: size))
        default:
            ctx.draw(self.cgImage!, in: CGRect(origin: CGPoint.zero, size: size))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
    
    
    func flippedImage(byAxis axis: MVImageFlip) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        if axis == .MVImageFlipXAxis {
            // Do nothing, X is flipped normally in a Core Graphics Context
        } else if axis == .MVImageFlipYAxis {
            // fix X axis
            context?.translateBy(x: 0, y: size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            
            // then flip Y axis
            context?.translateBy(x: size.width, y: 0)
            context?.scaleBy(x: -1.0, y: 1.0)
        } else if axis == .MVImageFlipXAxisAndYAxis {
            // just flip Y
            context?.translateBy(x: size.width, y: 0)
            context?.scaleBy(x: -1.0, y: 1.0)
        }
        
        context?.draw(cgImage!, in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        
       // context?.draw(in: cgImage, image: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        
        let flipedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return flipedImage
    }
}
