//
//  MSSticker+Images.swift
//
//  Created by Radif Sharafullin on 6/30/16.
//  Copyright © 2016 Radif Sharafullin. All rights reserved.
//

import UIKit
import Messages

extension MSSticker {
    //frame Delay aka frame rate
    //number of loops 0 = forever
    
    //usage:
    /*
        var images = [UIImage]()
        ...populate
        let sticker = MSSticker(images: images, frameDelay: 1.0/14.0, numberOfLoops: 0, localizedDescription: "test")
     */

    
    public convenience init(images: [UIImage], frameDelay: CGFloat, numberOfLoops: Int, localizedDescription: String){
        let cacheURL: URL
        let fileManager = FileManager.default
        let directoryName = UUID().uuidString
        let tempPath = NSTemporaryDirectory()
        
        do {
            try cacheURL = URL(fileURLWithPath: tempPath).appendingPathComponent(directoryName)
            try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true, attributes: nil)
        }
        catch { fatalError("Unable to create cache URL: \(error)") }
        
        let fileName = localizedDescription + ".png"
        guard let url = try? cacheURL.appendingPathComponent(fileName) else { fatalError("Unable to create sticker URL") }
        
        mcbAnimatedImagePersister.sharedInstance().persistAnimatedImageSequenceAPNG(images, frameDelay: frameDelay, numberOfLoops: numberOfLoops, to: url)
        
        do { try self.init(contentsOfFileURL: url, localizedDescription: localizedDescription) }
        catch { fatalError("Unable to create sticker: \(error)") }
    }
}
