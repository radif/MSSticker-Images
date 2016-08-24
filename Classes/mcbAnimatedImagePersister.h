//
//  mcbAnimatedImagePersister.h
//
//  Created by Radif Sharafullin on 6/30/16.
//  Copyright © 2016 Radif Sharafullin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mcbAnimatedImagePersister : NSObject
+(instancetype)shared;

-(void)persistAnimatedImageSequenceGIF:(NSArray<UIImage *> *)images frameDelay:(CGFloat)frameDelay numberOfLoops:(NSInteger)numberOfLoops toURL:(NSURL *)toURL;
-(void)persistAnimatedImageSequenceAPNG:(NSArray<UIImage *> *)images frameDelay:(CGFloat)frameDelay numberOfLoops:(NSInteger)numberOfLoops toURL:(NSURL *)toURL;

@end
