//
//  ImageTool.swift
//  FirBuilder
//
//  Created by PC on 2022/11/16.
//

import Foundation

struct ImageTool {
    
    /** 从指定路径加载图片，失败返回一个默认NSImage */
    static func loadImageFrom(path:String, placeholder:NSImage = NSImage(imageLiteralResourceName: "AppIcon")) -> NSImage{
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            ParserTool.log("ImageTool:图片加载失败, path: \(path)")
            return placeholder
        }
        guard let ciImage = CIImage(data: data) else {
            ParserTool.log("ImageTool:图片加载失败, path: \(path)")
            return placeholder
        }
        let rep = NSCIImageRep(ciImage: ciImage)
        let resImage = NSImage(size: rep.size)
        resImage.addRepresentation(rep)
        return resImage
    }
    
    
    /** 修改NSImage的大小 */
    static func resize(image:NSImage, size:NSSize) -> NSImage{
        var ratio: Float = 0.0
        let imageWidth = Float(image.size.width)
        let imageHeight = Float(image.size.height)
        let maxWidth = Float(size.width)
        let maxHeight = Float(size.height)

        // Get ratio (landscape or portrait)
        if (imageWidth > imageHeight) {
            // Landscape
            ratio = maxWidth / imageWidth;
        }
        else {
            // Portrait
            ratio = maxHeight / imageHeight;
        }

        // Calculate new size based on the ratio
        let newWidth = imageWidth * ratio
        let newHeight = imageHeight * ratio

        let imageSo = CGImageSourceCreateWithData(image.tiffRepresentation! as CFData, nil)
        let options: [NSString: NSObject] = [
            kCGImageSourceThumbnailMaxPixelSize: max(imageWidth, imageHeight) * ratio as NSObject,
            kCGImageSourceCreateThumbnailFromImageAlways: true as NSObject
        ]
        let size1 = NSSize(width: Int(newWidth), height: Int(newHeight))
        let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSo!, 0, options as CFDictionary).flatMap {
            NSImage(cgImage: $0, size: size1)
        }
        return scaledImage!
    }
    
    
    /** 将NSImage以png格式保存到本地*/
    @discardableResult
    static func PNGRepresentation(image:NSImage, path:String) -> Bool{
        var pngData:Data? = nil
        if let TIFFRepresentation = image.tiffRepresentation, let bitmap = NSBitmapImageRep(data: TIFFRepresentation) {
            pngData = bitmap.representation(using: .png, properties: [:])
        }
//        let status = FileManager.default.createFile(atPath: path, contents: pngData, attributes: nil)
        let status = ParserTool.save(pngData, path: path)
        let ss = status ? "保存成功" : "保存失败"
        ParserTool.log("ImageTool:PNGRepresentation \(ss) path：\(path)")
        return status
    }
    
    /** 将NSImage以jpeg格式保存到本地，占用空间更小 */
    @discardableResult
    static func JPGRepresentation(image:NSImage, path:String) -> Bool{
        var pngData:Data? = nil
        if let TIFFRepresentation = image.tiffRepresentation, let bitmap = NSBitmapImageRep(data: TIFFRepresentation) {
            pngData = bitmap.representation(using: .jpeg, properties: [:])
        }
//        let status = FileManager.default.createFile(atPath: path, contents: pngData, attributes: nil)
        let status = ParserTool.save(pngData, path: path)
        let ss = status ? "保存成功" : "保存失败"
        ParserTool.log("ImageTool:JPGRepresentation \(ss) path：\(path)")
        return status
    }
}


