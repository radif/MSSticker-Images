//
//  mcbAnimatedImagePersister.m
//
//  Created by Radif Sharafullin on 6/30/16.
//  Copyright © 2016 Radif Sharafullin. All rights reserved.
//

#import "mcbAnimatedImagePersister.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation mcbAnimatedImagePersister
+(instancetype)sharedInstance{
    static mcbAnimatedImagePersister * instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=mcbAnimatedImagePersister.new;
    });
    return instance;
}
-(void)persistAnimatedImageSequenceGIF:(NSArray<UIImage *> *)images frameDelay:(CGFloat)frameDelay numberOfLoops:(NSInteger)numberOfLoops toURL:(NSURL *)toURL{
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @(numberOfLoops), // 0 means loop forever
                                             }
                                     };
    
    NSDictionary *frameProperties = @{
                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
                                              (__bridge id)kCGImagePropertyGIFDelayTime: @(frameDelay), // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                              }
                                      };
    
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)toURL, kUTTypeGIF, images.count, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    for (UIImage * image in images) {
        CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
}
-(void)persistAnimatedImageSequenceAPNG:(NSArray<UIImage *> *)images frameDelay:(CGFloat)frameDelay numberOfLoops:(NSInteger)numberOfLoops toURL:(NSURL *)toURL{
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyPNGDictionary: @{
                                             (__bridge id)kCGImagePropertyAPNGLoopCount: @(numberOfLoops), // 0 means loop forever
                                             }
                                     };
    
    NSDictionary *frameProperties = @{
                                      (__bridge id)kCGImagePropertyPNGDictionary: @{
                                              (__bridge id)kCGImagePropertyAPNGDelayTime: @(frameDelay), // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                              }
                                      };
    
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)toURL, kUTTypePNG, images.count, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    for (UIImage * image in images) {
        CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
}

@end
