//
//  EditorViewController.m
//  FiltersApp
//
//

#import "EditorViewController.h"
#import "MaskEditorViewController.h"

@interface EditorViewController ()

@property NSUInteger currentEffect;
@property BOOL showImageMaskEditor;

@end

@implementation EditorViewController

- (void) togglePicker:(UIView *) _pickerView {
    [UIView animateWithDuration:0.3 animations:^{
        if (CGAffineTransformIsIdentity(_pickerView.transform)) {
            _pickerView.transform = CGAffineTransformMakeTranslation(0, (-1)*_pickerView.frame.size.height);
        }
        else {
            _pickerView.transform = CGAffineTransformIdentity;
        }
    }];
}

- (void) toggleFramesPicker {
    [self togglePicker:self.framesScroll];
}

- (void) toggleEffectsPicker {
    [self togglePicker:self.effectsView];
}

- (void) selectItemWithTag:(NSUInteger) tag inView:(UIView *) _mainView {
    NSArray *_views = [_mainView subviews];
    for (UIView *_subView in _views) {
        _subView.layer.shadowColor = [[UIColor clearColor] CGColor];
    }
    
    UIView *_selectedView = [_mainView viewWithTag:tag];
    _selectedView.layer.shadowColor = [[UIColor whiteColor] CGColor];
    _selectedView.layer.shadowOffset = CGSizeMake(1, 1);
    _selectedView.layer.shadowOpacity = 1;
    _selectedView.layer.shadowRadius = 10;
}

- (void) applyEffect:(NSUInteger) _effect withIntensty:(CGFloat)_intensity {
    [self.mainImageController applyEffect:_effect withIntensty:_intensity];
    [self selectItemWithTag:_effect inView:self.effectsScroll];
}

- (void) applyEffect:(id) sender {
    [self toggleEffectsPicker];
    if (self.showImageMaskEditor) {
        MaskEditorViewController *_maskEditor = [MaskEditorViewController new];
        [self presentViewController:_maskEditor animated:NO completion:^{
            //set the effect to be set on the mask
            [_maskEditor setEffect:[sender tag]];
            [_maskEditor.backgroundImage setImage:[self.mainImageController visibleImage]];
        }];
        self.showImageMaskEditor = NO;
        return;
    }
    
    self.currentEffect = [sender tag];
    UISlider *intensitySlider = (UISlider*)[self.effectsView viewWithTag:100];
    [self applyEffect:self.currentEffect withIntensty:intensitySlider.value];
}

- (void) applyFrame:(id) sender {
    [self selectItemWithTag:[sender tag] inView:self.framesScroll];
    [self.mainImageController applyFrame:[sender tag]];
    [self toggleFramesPicker];
}

- (void) sliderChanged:(id) sender {
    if (self.showImageMaskEditor) {
        return;
    }
    
    UISlider *slider = (UISlider *) sender;
    [self applyEffect:self.currentEffect withIntensty:slider.value];
}

- (void) setupEffects {
    if (self.effectsScroll != nil) {
        return;
    }
    
    self.effectsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 100)];
    self.effectsView.backgroundColor = [UIColor whiteColor];
    
    self.effectsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 74)];
    self.effectsScroll.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i < 11; i++) {
        UIButton *_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 60, 60)];
        UIImage *_img = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        [_button setImage:[_img roundedCornerImage:10 borderSize:0] forState:UIControlStateNormal];
        _button.tag = i;
        [_button addTarget:self action:@selector(applyEffect:) forControlEvents:UIControlEventTouchUpInside];
        [self.effectsScroll addSubview:_button];
    }
    
    [self.effectsView addSubview:self.effectsScroll];
    [self.effectsScroll relayoutChildrenHorizontallyWithMargin:5];

    [self.view addSubview:self.effectsView];
    //add slider to effectsView
    
    UISlider *intensitySlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 74, 300, 26)];
    [intensitySlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventTouchUpInside];
    intensitySlider.tag = 100;
    intensitySlider.value = 0.5;
    [self.effectsView addSubview:intensitySlider];
    
}

- (void) setupFrames {
    if (self.framesScroll != nil) {
        return;
    }
    
    self.framesScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 84)];
    self.framesScroll.backgroundColor = [UIColor whiteColor];
    
    UIButton *_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 60, 60)];
    _button.tag = 0;
    _button.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    _button.backgroundColor = [UIColor lightGrayColor];
    
    [_button addTarget:self action:@selector(applyFrame:) forControlEvents:UIControlEventTouchUpInside];
    [self.framesScroll addSubview:_button];
    
    for (int i=1; i < 8; i++) {
        UIButton *_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 60, 60)];
        UIImage *_img = [UIImage imageNamed:[NSString stringWithFormat:@"frame%d.png", i]];
        [_button setImage:[_img roundedCornerImage:10 borderSize:0] forState:UIControlStateNormal];
        _button.tag = i;
        [_button addTarget:self action:@selector(applyFrame:) forControlEvents:UIControlEventTouchUpInside];
        [self.framesScroll addSubview:_button];
    }
    
    [self.view addSubview:self.framesScroll];
    [self.framesScroll relayoutChildrenHorizontallyWithMargin:5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyImageMask:) name:@"APPLY_MASK" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyCrop:) name:@"APPLY_CROP" object:nil];
    
    self.showImageMaskEditor = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.mainImageController setBaseImage:self.selectedImage];
    [self setupEffects];
    [self setupFrames];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showEffects:(id)sender {
    [self toggleEffectsPicker];
}

- (IBAction)showFrames:(id)sender {
    [self toggleFramesPicker];
}

- (IBAction)undo:(id)sender {
    [self.mainImageController undo];
}

- (IBAction)redo:(id)sender {
    [self.mainImageController redo];
}

- (IBAction)crop:(id)sender {
    CropViewController *_cropController = [CropViewController new];
    [self presentViewController:_cropController animated:NO completion:^{
        [_cropController.mainImage setImage:[self.mainImageController imageToCrop]];
    }];
}

- (IBAction)makeImageMask:(id)sender {
    self.showImageMaskEditor = !self.showImageMaskEditor;
    //show effects picker
    [self toggleEffectsPicker];
}

- (void)applyCrop:(NSNotification *) notification {
    [self.mainImageController revert];
    [self.mainImageController updateImage:[notification object]];
}

- (void)applyImageMask:(NSNotification *) notification {
    NSDictionary *obj = [notification object];
    //flatten current image
    [self.mainImageController flattenMask];
    //apply new mask
    self.currentEffect = [obj[@"effect"] intValue];
    [self.mainImageController applyMask:obj[@"mask"] withEffect:self.currentEffect];
}

- (IBAction)clearImageMask:(id)sender {
    [self.mainImageController revert];
}

- (IBAction)share:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", @"Save to Photos", @"Email", @"Print", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    SLComposeViewController *_sl;
    UIAlertView *alert;
    MFMailComposeViewController *mailViewController;
    UIPrintInteractionController *pic;
    
    switch (buttonIndex) {
        case 0:
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                _sl = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            }
            break;
        }
        case 1:
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                _sl = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            }
            break;
        }
        case 2:
        {
            UIImageWriteToSavedPhotosAlbum([self.mainImageController sharingImage], nil, nil, nil);
            alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Photo saved!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case 3:
        {
            if ([MFMailComposeViewController canSendMail]) {
                mailViewController = [[MFMailComposeViewController alloc] init];
                mailViewController.mailComposeDelegate = self;
                NSData *myData = UIImagePNGRepresentation([self.mainImageController sharingImage]);
                [mailViewController addAttachmentData:myData mimeType:@"image/png" fileName:@"wonderCam.png"];
                [self presentViewController:mailViewController animated:YES completion:nil];
            }
            else {
                alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please confirgure email setting before trying this." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
            break;
        }
        case 4:
        {
            pic = [UIPrintInteractionController sharedPrintController];
            NSData *myData = UIImagePNGRepresentation([self.mainImageController sharingImage]);

            if(pic && [UIPrintInteractionController canPrintData:myData]) {
                
                pic.delegate = self;
                
                UIPrintInfo *printInfo = [UIPrintInfo printInfo];
                printInfo.outputType = UIPrintInfoOutputGeneral;
                printInfo.jobName = @"WonderCam.png";
                printInfo.duplex = UIPrintInfoDuplexLongEdge;
                pic.printInfo = printInfo;
                pic.showsPageRange = YES;
                pic.printingItem = myData;
                
                void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
                    if (!completed && error) {
                        NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
                    } 
                };
                
                [pic presentAnimated:YES completionHandler:completionHandler];
                
            }
            break;
        }
        default:
        {
            return;
            break;
        }
    }
    
    if (_sl) {
        [_sl setInitialText:@""];
        [_sl addImage:[self.mainImageController sharingImage]];
        [self presentViewController:_sl animated:YES completion:nil];
        
        [_sl setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output = @"";
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"ACtionCancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successfull";
                    break;
                default:
                    break;
            }
            NSLog(@"%@", output);
        }];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
