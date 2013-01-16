//
//  MaskEditorViewController.m
//  PhotoApp
//
//

#import "MaskEditorViewController.h"

@interface MaskEditorViewController ()

@property CGFloat lastScale;
@property CGFloat lastRotation;
@property CGFloat firstX;
@property CGFloat firstY;

@property (strong) UIPinchGestureRecognizer *pinchRecognizer;
@property (strong) UIRotationGestureRecognizer *rotationRecognizer;
@property (strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation MaskEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) updateConstraints {
    [self.maskView setFrame:[self.backgroundImage displayRect]];
    [self.maskView setCenter:self.backgroundImage.center];
}

-(void)scale:(id)sender {
    
    if (self.maskView.userInteractionEnabled) {
        return;
    }
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.lastScale = 1.0;
    }
    
    CGFloat _scale = 1.0 - (self.lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform _currentTransform = self.transformView.transform;
    CGAffineTransform _newTransform = CGAffineTransformScale(_currentTransform, _scale, _scale);

    [self.transformView setTransform:_newTransform];
    self.lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

-(void)rotate:(id)sender {
    
    if (self.maskView.userInteractionEnabled) {
        return;
    }
    
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        self.lastRotation = 0.0;
        return;
    }
    
    CGFloat _rotation = 0.0 - (self.lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform _newTransform = CGAffineTransformRotate(self.transformView.transform,_rotation);
    
    [self.transformView setTransform:_newTransform];
    
    self.lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}


-(void)move:(id)sender {
    
    if (self.maskView.userInteractionEnabled) {
        return;
    }
    
    CGPoint _translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.transformView.superview];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.firstX = [self.transformView center].x;
        self.firstY = [self.transformView center].y;
    }
    
    _translatedPoint = CGPointMake(self.firstX+_translatedPoint.x, self.firstY+_translatedPoint.y);
    
    [self.transformView setCenter:_translatedPoint];
}

-(void) setupGestures {
    
    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [self.pinchRecognizer setDelegate:self];
    [self.transformView addGestureRecognizer:self.pinchRecognizer];
    self.pinchRecognizer.enabled = NO;
    
    self.rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [self.rotationRecognizer setDelegate:self];
    [self.transformView addGestureRecognizer:self.rotationRecognizer];
    self.rotationRecognizer.enabled = NO;
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self.panRecognizer setMinimumNumberOfTouches:1];
    [self.panRecognizer setMaximumNumberOfTouches:1];
    [self.panRecognizer setDelegate:self];
    [self.transformView addGestureRecognizer:self.panRecognizer];
    self.panRecognizer.enabled = NO;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupGestures];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(updateConstraints) withObject:nil afterDelay:0.1];
    CGRect _f = self.brushSelectorView.frame;
   // [self.brushSelectorView setFrame:CGRectMake(_f.origin.x, self.view.bounds.size.height, _f.size.width, _f.size.height)];
     self.brushSelectorView.frame = CGRectMake(89, -144, 50, 144);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleMove:(UIBarButtonItem *)sender {
    if (self.maskView.userInteractionEnabled)
        sender.title = @"Stop";
    else
        sender.title = @"Move";

    self.maskView.userInteractionEnabled = !self.maskView.userInteractionEnabled;
    self.pinchRecognizer.enabled = !self.pinchRecognizer.enabled;
    self.rotationRecognizer.enabled = !self.rotationRecognizer.enabled;
    self.panRecognizer.enabled = !self.panRecognizer.enabled;
}

- (IBAction)back:(id)sender {
    [super dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)save:(id)sender {
    
    NSDictionary *obj = @{@"mask" : [[self maskView] currentImage],
                          @"effect": @(self.effect)};

    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_MASK" object:[obj copy]];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_MASK" object:[[[self maskView] currentImage] copy]];
    [super dismissViewControllerAnimated:NO completion:nil];
}

- (void) toggleBrushSelector {
    [UIView animateWithDuration:0.3 animations:^{
        /*
        if (CGAffineTransformIsIdentity(self.brushSelectorView.transform))
        {
            NSLog(@"open");
            //self.brushSelectorView.transform = CGAffineTransformMakeTranslation(0, (-1)*self.brushSelectorView.frame.size.height);
            self.brushSelectorView.frame = CGRectMake(89, -50, 50, 144);
        }
        else {
            NSLog(@"close");
            //self.brushSelectorView.transform = CGAffineTransformIdentity;
            self.brushSelectorView.frame = CGRectMake(89, -144, 50, 144);
        }
         */
        
        if (isOpened == NO)
        {
            NSLog(@"open");
            isOpened = YES;
            //self.brushSelectorView.transform = CGAffineTransformMakeTranslation(0, (-1)*self.brushSelectorView.frame.size.height);
            self.brushSelectorView.frame = CGRectMake(89, 10, 50, 144);
        }
        else {
            NSLog(@"close");
            isOpened = NO;
            //self.brushSelectorView.transform = CGAffineTransformIdentity;
            self.brushSelectorView.frame = CGRectMake(89, -144, 50, 144);
        }

    }];
}

- (IBAction)setBrushSize:(id)sender {
    [self toggleBrushSelector];
    [self.maskView setLineWidth:(CGFloat)[sender tag]];
}

- (IBAction)enableBrush:(id)sender {
    [self toggleBrushSelector];
    [self.maskView disableErasor];
}

- (IBAction)enableErasor:(id)sender {
    [self toggleBrushSelector];
    [self.maskView enableErasor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
