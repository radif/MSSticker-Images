# MSSticker-Images
Initializes a new animated sticker with an array of images and animation settings

# Usage:
```swift
  var images = [UIImage]()
  //...populate
  let sticker = MSSticker(images: images, frameDelay: 1.0/14.0, numberOfLoops: 0, localizedDescription: "generated sticker")
```
1. frameDelay aka frame rate
2. numberOfLoops: 0 = forever
