//
//  ExampleCollectionViewCell.swift
//  Example
//
//  Created by Radif Sharafullin on 8/24/16.
//  Copyright © 2016 Radif Sharafullin. All rights reserved.
//

import UIKit
import Messages

class ExampleCollectionViewCell: UICollectionViewCell {
    static let kReuseIdentifier = "ExampleCollectionViewCell"
    @IBOutlet weak var _spinner: UIActivityIndicatorView!
    @IBOutlet weak var _stickerHolderView: UIView!
    
    var _stickerView: MSStickerView? = nil
    private var _stickerData : StickerData?=nil
    var stickerData : StickerData? {get {return _stickerData}}
    
    override func prepareForReuse() {
        if let v = _stickerView {
            v.stopAnimating()
            v.sticker=nil
            v.removeFromSuperview()
        }
        _stickerView = nil
        _stickerData = nil
        
        hideSpinner()
    }
    
    func render(stickerData: StickerData){
        _stickerData=stickerData
        loadCurrentStickerAsync()
    }
    
    func loadCurrentStickerAsync(){
        if let stickerData = _stickerData {
            showSpinner()
            
            let images = stickerData.images
            let localizedDescription = stickerData.name
            let frameDelay = CGFloat(stickerData.frameDelay)
            
            //async...
            DispatchQueue.main.async() { [weak self] in
                
                var imgs = [UIImage]()
                for imageName in images{
                    let img = UIImage(named: imageName)
                    if let i = img{ imgs.append(i) }
                }
                
                let urlForImageName = { (_ name:String)->URL in
                    var url = Bundle.main.resourceURL!
                    url.appendPathComponent(name + ".png")
                    return url
                }
                
                let sticker :MSSticker
                do {
                    try sticker=MSSticker(images: imgs, format: .apng, frameDelay: frameDelay, numberOfLoops: 0, localizedDescription: localizedDescription)
                    
                }catch MSStickerAnimationInputError.InvalidDimensions {
                    try! sticker=MSSticker(contentsOfFileURL:  urlForImageName("invalid_image_size"), localizedDescription: "invalid dimensions")
                    
                }catch MSStickerAnimationInputError.InvalidStickerFileSize {
                    try! sticker=MSSticker(contentsOfFileURL: urlForImageName("invalid_file_size"), localizedDescription: "invalid file size")
                    
                } catch {
                    fatalError("other error:\(error)")
                }
                
                if let s=self{
                    if localizedDescription == s._stickerData?.name{
                        let sv = MSStickerView(frame: s._stickerHolderView.bounds, sticker: sticker)
                        s._stickerHolderView.addSubview(sv)
                        sv.startAnimating()
                        s._stickerView = sv
                        s.hideSpinner()
                    }
                }
            }
            
        }
    }
    
    func showSpinner(){
        _spinner.isHidden = false
        _spinner.startAnimating()
    }
    func hideSpinner(){
        _spinner.stopAnimating()
        _spinner.isHidden = true
    }

}
