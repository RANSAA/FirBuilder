//
//  NSImage+Resize.h
//  FirBuilder
//
//  Created by PC on 2022/2/15.
//

#import <Cocoa/Cocoa.h>
#import <SDWebImage.h>
#import "UIImage+Transform.h"


NS_ASSUME_NONNULL_BEGIN

@interface NSImage (Resize)
- (nullable UIImage *)sd_resizedImageWithSizeFixed:(CGSize)size scaleMode:(SDImageScaleMode)scaleMode;
@end

NS_ASSUME_NONNULL_END
