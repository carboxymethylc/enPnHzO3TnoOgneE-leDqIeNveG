//
//  EditorViewController.h
//  PhotoApp
//
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "UIView+Layout.h"

#import "UIImage+Effects.h"

#import "UIImage+Alpha.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "MainImageViewController.h"

#import "CropViewController.h"

@interface EditorViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UIPrintInteractionControllerDelegate>

@property (strong, nonatomic) IBOutlet MainImageViewController *mainImageController;

@property (strong) UIView *effectsView;
@property (strong) UIScrollView *effectsScroll;
@property (strong) UIScrollView *framesScroll;
@property (strong) UIImage *selectedImage;

@property (strong) UIImage *mask;

- (IBAction)back:(id)sender;
- (IBAction)showEffects:(id)sender;
- (IBAction)showFrames:(id)sender;
- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;
- (IBAction)crop:(id)sender;
- (IBAction)makeImageMask:(id)sender;
- (IBAction)clearImageMask:(id)sender;
- (IBAction)share:(id)sender;

@end
