//
//  SmoothedBIView.h
//  PhotoApp
//
//

#import <UIKit/UIKit.h>
#import "UIImage+Effects.h"
#import "UIImage+Resize.h"

@interface SmoothedBIView : UIView

- (UIImage *) currentImage;
- (void) setLineWidth:(CGFloat) _width;
- (void) enableErasor;
- (void) disableErasor;

@end
