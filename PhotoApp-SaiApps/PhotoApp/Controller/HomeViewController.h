//
//  HomeViewController.h
//  PhotoApp
//
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *lastImage;
@property (strong) UIImage *selectedImage;
- (IBAction)continueWithLastImage:(id)sender;

- (IBAction)showCamera:(id)sender;
- (IBAction)showGallery:(id)sender;

@end
