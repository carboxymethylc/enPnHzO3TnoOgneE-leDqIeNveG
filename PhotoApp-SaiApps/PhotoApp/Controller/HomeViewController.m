//
//  HomeViewController.m
//  PhotoApp
//
//

#import "HomeViewController.h"
#import "EditorViewController.h"
#import "UIImage+Resize.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void) saveLastWorkedImage:(UIImage*) lastWorked {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:UIImagePNGRepresentation(lastWorked) forKey:@"lastWorked"];
    [defaults synchronize];
}

- (UIImage *) loadLastWorkedImage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"lastWorked"]) {
        return [UIImage imageWithData:[defaults objectForKey:@"lastWorked"]];
    }
    return nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        EditorViewController *_editor = [EditorViewController new];
        UIImage *_img = info[@"UIImagePickerControllerOriginalImage"];
        UIImage *_resizedImg = [_img resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(1000, 1000) interpolationQuality:kCGInterpolationDefault];
        
        [self saveLastWorkedImage:_resizedImg];
        
        [_editor setSelectedImage:_resizedImg];
        [self.navigationController pushViewController:_editor animated:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)continueWithLastImage:(id)sender {
    EditorViewController *_editor = [EditorViewController new];
    UIImage *_img = [self loadLastWorkedImage];
    [_editor setSelectedImage:_img];
    [self.navigationController pushViewController:_editor animated:YES];
}

- (IBAction)showCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{}];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Camera is not available in your device." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }

}

- (IBAction)showGallery:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.lastImage setImage:[self loadLastWorkedImage]];
}

@end

