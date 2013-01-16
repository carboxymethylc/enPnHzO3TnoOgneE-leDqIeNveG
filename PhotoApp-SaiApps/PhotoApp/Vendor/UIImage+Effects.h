//
//  UIImage+Effects.h
//  PhotoApp
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Effects)

- (UIImage *) imageWithMask:(UIImage *)maskImage;
- (UIImage *) imageWithFilter:(NSUInteger) index;
- (UIImage *) imageWithFilter:(NSUInteger) _index andIntensity:(CGFloat) _intensity;

@end
