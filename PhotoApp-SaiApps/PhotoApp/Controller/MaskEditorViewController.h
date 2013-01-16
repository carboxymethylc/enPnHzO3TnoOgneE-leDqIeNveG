//
//  MaskEditorViewController.h
//  PhotoApp
//
//

#import <UIKit/UIKit.h>
#import "UIImage+Effects.h"
#import "SmoothedBIView.h"
#import "UIImageView+Scale.h"

@interface MaskEditorViewController : UIViewController <UIGestureRecognizerDelegate>
{
    BOOL isOpened;
}
- (IBAction)toggleMove:(UIBarButtonItem *)sender;

- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)setBrushSize:(id)sender;

- (IBAction)enableBrush:(id)sender;

- (IBAction)enableErasor:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *brushSelectorView;

@property (weak, nonatomic) IBOutlet UIView *transformView;

@property (weak, nonatomic) IBOutlet SmoothedBIView *maskView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong) UIImageView *maskImageView;
@property (assign) NSUInteger effect;
@end
