//
//  UIImageView+Scale.m
//  PhotoApp
//
//

#import "UIImageView+Scale.h"

@implementation UIImageView (Scale)
- (CGRect) displayRect {
    
    if (self.image == nil) {
        return CGRectNull;
    }
    
    CGFloat sx = self.frame.size.width / self.image.size.width;
    CGFloat sy = self.frame.size.height / self.image.size.height;
    CGSize _scaleFactor;
    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFit:
            _scaleFactor = CGSizeMake(fminf(sx, sy), fminf(sx, sy));
            break;
            
        case UIViewContentModeScaleAspectFill:
            _scaleFactor = CGSizeMake(fmaxf(sx, sy), fmaxf(sx, sy));
            break;
            
        case UIViewContentModeScaleToFill:
            _scaleFactor = CGSizeMake(sx, sy);
            break;
            
        default:
            _scaleFactor = CGSizeMake(1.0, 1.0);
    }
    
    CGSize _displaySize = CGSizeMake(self.image.size.width * _scaleFactor.width, self.image.size.height * _scaleFactor.height);
    
    CGFloat _x = (self.frame.size.width - _displaySize.width)/2;
    CGFloat _y = (self.frame.size.height - _displaySize.height)/2;
    
    return CGRectMake(_x, _y, _displaySize.width, _displaySize.height);
}
@end
