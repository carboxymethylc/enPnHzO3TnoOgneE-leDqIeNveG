//
//  CropViewController.m
//  PhotoApp
//
//  Created on 10/12/12.
//  Copyright (c) 2012 OrganizationName. All rights reserved.
//

#import "CropViewController.h"

@interface CropViewController ()

@property CGFloat lastScale;
@property CGFloat lastRotation;
@property CGFloat firstX;
@property CGFloat firstY;

@property (strong) UIPinchGestureRecognizer *pinchRecognizer;
@property (strong) UIRotationGestureRecognizer *rotationRecognizer;
@property (strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation CropViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)scale:(id)sender {
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.lastScale = 1.0;
    }
    
    CGFloat _scale = 1.0 - (self.lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform _currentTransform = self.mainImage.transform;
    CGAffineTransform _newTransform = CGAffineTransformScale(_currentTransform, _scale, _scale);
    
    [self.mainImage setTransform:_newTransform];
    self.lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

-(void)rotate:(id)sender {
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        self.lastRotation = 0.0;
        return;
    }
    
    CGFloat _rotation = 0.0 - (self.lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform _newTransform = CGAffineTransformRotate(self.mainImage.transform,_rotation);
    
    [self.mainImage setTransform:_newTransform];
    
    self.lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}


-(void)move:(id)sender {

    CGPoint _translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.mainImage.superview];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.firstX = [self.mainImage center].x;
        self.firstY = [self.mainImage center].y;
    }
    
    _translatedPoint = CGPointMake(self.firstX+_translatedPoint.x, self.firstY+_translatedPoint.y);
    
    [self.mainImage setCenter:_translatedPoint];
}

-(void) setupGestures {
    
    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [self.pinchRecognizer setDelegate:self];
    [self.mainImage addGestureRecognizer:self.pinchRecognizer];
    
    self.rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [self.rotationRecognizer setDelegate:self];
  //  [self.mainImage addGestureRecognizer:self.rotationRecognizer];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self.panRecognizer setMinimumNumberOfTouches:1];
    [self.panRecognizer setMaximumNumberOfTouches:1];
    [self.panRecognizer setDelegate:self];
    [self.mainImage addGestureRecognizer:self.panRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupGestures];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_CROP" object:[self.mainView captureImage]];
    [super dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)cancel:(id)sender {
    [super dismissViewControllerAnimated:NO completion:nil];
}
@end
