//
//  MainImageViewController.h
//  PhotoApp
//
//

#import <UIKit/UIKit.h>
#import "UIImage+Effects.h"
#import "UIImage+Resize.h"
#import "UIImageView+Scale.h"
#import "UIView+Layout.h"

@interface MainImageViewController : UIViewController

- (void) revert;

- (void) updateImage:(UIImage*) _image;

- (void) setBaseImage:(UIImage *) _image;

- (void) applyEffect:(NSUInteger) _effect withIntensty:(CGFloat) _intensity;
- (void) applyFrame:(NSUInteger) _frame;

- (void) undo;
- (void) redo;

- (void) applyMask:(UIImage *) _mask withEffect:(NSUInteger) effect;

- (void) applyMask:(UIImage *) _mask;
- (void) removeMask;


- (UIImage *) imageToCrop;
- (UIImage *) visibleImage;
- (UIImage *) sharingImage;

- (void) flattenMask;

@end
