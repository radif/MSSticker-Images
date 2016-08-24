# MSSticker-Images
Initializes a new animated sticker with an array of images and animation settings

# Usage:
```swift
  var images = [UIImage]()
  //...populate
  let sticker = MSSticker(images: images, frameDelay: 1.0/14.0, numberOfLoops: 0, localizedDescription: "generated sticker")


    var images = [UIImage]()

    ...populate

    let sticker :MSSticker
    do {
    try sticker=MSSticker(images: images, format: .apng, frameDelay: 1.0/14.0, numberOfLoops: 0, localizedDescription: localizedDescription)

    }catch MSStickerAnimationInputError.InvalidDimensions {
    try! sticker=MSSticker(contentsOfFileURL:  urlForImageName("invalid_image_size"), localizedDescription: "invalid dimensions")

    }catch MSStickerAnimationInputError.InvalidStickerFileSize {
    try! sticker=MSSticker(contentsOfFileURL: urlForImageName("invalid_file_size"), localizedDescription: "invalid file size")

    } catch { fatalError("other error:\(error)") }
```
1. insert `#import "mcbAnimatedImagePersister.h"` into your swift bridging header
2. frameDelay aka frame rate
3. numberOfLoops: 0 = forever

The current limitation imposed by Apple is 500kb file size and the image dimensions varying 300x300 to 618-618 px. The initializer will throw .InvalidDimensions or .InvalidStickerFileSize if the conditions are not met

To familarize yourself with the use case, see the example project, particularly, files: ExampleCollectionViewCell.swift, MessagesViewController.swift, StickerData.swift
