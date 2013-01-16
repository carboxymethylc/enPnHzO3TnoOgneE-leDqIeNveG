//
//  CropViewController.h
//  PhotoApp
//
//  Created on 10/12/12.
//  Copyright (c) 2012 OrganizationName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Layout.h"

@interface CropViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIView *mainView;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
