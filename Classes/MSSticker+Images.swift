//
//  MSSticker+Images.swift
//
//  Created by Radif Sharafullin on 6/30/16.
//  Copyright © 2016 Radif Sharafullin. All rights reserved.
//

import UIKit
import Messages

public enum MSStickerAnimationFormat {
    case apng
    case gif
}
public enum MSStickerAnimationInputError: Error {
    case InvalidDimensions //should be less than 500 kb in order to "stick" to the message
    case InvalidStickerFileSize //should be less than 500 kb in order to "stick" to the message
}

extension MSSticker {
    //frame Delay aka frame rate
    //number of loops 0 = forever
    //localizedDescription will be used for the temporary file name
    
    //The current limitation imposed by Apple is 500kb file size and the image dimensions varying 300x300 to 618-618 px. The initializer will throw .InvalidDimensions or .InvalidStickerFileSize if the conditions are not met
    
    //usage:
    /*
        var images = [UIImage]()
     
        ...populate
     
         let sticker :MSSticker
         do {
         try sticker=MSSticker(images: images, format: .apng, frameDelay: 1.0/14.0, numberOfLoops: 0, localizedDescription: localizedDescription)
         
         }catch MSStickerAnimationInputError.InvalidDimensions {
         try! sticker=MSSticker(contentsOfFileURL:  urlForImageName("invalid_image_size"), localizedDescription: "invalid dimensions")
         
         }catch MSStickerAnimationInputError.InvalidStickerFileSize {
         try! sticker=MSSticker(contentsOfFileURL: urlForImageName("invalid_file_size"), localizedDescription: "invalid file size")
         
         } catch {
         fatalError("other error:\(error)")
         }

     
     
     */
    
    public convenience init(images: [UIImage], format:MSStickerAnimationFormat, frameDelay: CGFloat, numberOfLoops: Int, localizedDescription: String) throws{
        
        //check if all image dimensions
        let isImageDimensionValid = { (_ dimension:CGFloat)->Bool in return dimension >= 300 && dimension <= 618 }
        for image in images{ guard isImageDimensionValid(image.size.width) && isImageDimensionValid(image.size.height) else { throw MSStickerAnimationInputError.InvalidDimensions } }
        
        let cacheURL: URL
        let fileManager = FileManager.default
        let directoryName = UUID().uuidString
        let tempPath = NSTemporaryDirectory()
        
        cacheURL = URL(fileURLWithPath: tempPath).appendingPathComponent(directoryName)
        do { try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true, attributes: nil) } catch { fatalError("Unable to create cache URL: \(error)") }
        
        let fileName = localizedDescription + (format == .apng ? ".png" : ".gif") // ".png" extension is used instead of .apng for backwards compatibility with viewers not supporting apng - they will see it's first frame as static png image
        
        let url = cacheURL.appendingPathComponent(fileName)
        
        if format == .apng {
        mcbAnimatedImagePersister.shared().persistAnimatedImageSequenceAPNG(images, frameDelay: frameDelay, numberOfLoops: numberOfLoops, to: url)
        }else{
        mcbAnimatedImagePersister.shared().persistAnimatedImageSequenceGIF(images, frameDelay: frameDelay, numberOfLoops: numberOfLoops, to: url)
        }
        
        
        //check the animated file size
        var fileSize: UInt64 = 0
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fSize = fileAttributes[FileAttributeKey.size]  {
                fileSize = (fSize as! NSNumber).uint64Value
            } else { print("Failed to get a size attribute from path: \(url.path)") }
        } catch { print("Error: \(error)") }
        
        if fileSize/1000 > 500 { throw MSStickerAnimationInputError.InvalidStickerFileSize }
        
        
        do { try self.init(contentsOfFileURL: url, localizedDescription: localizedDescription) }
        catch { fatalError("Unable to create sticker: \(error)") }
    }
}
