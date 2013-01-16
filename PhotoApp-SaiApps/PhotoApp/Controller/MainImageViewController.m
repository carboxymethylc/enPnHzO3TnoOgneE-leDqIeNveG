//
//  MainImageViewController.m
//  PhotoApp
//
//

#import "MainImageViewController.h"

@interface MainImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *frameImage;
@property (weak, nonatomic) IBOutlet UIImageView *maskImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@property NSUInteger currentEffectIndex;

@property (nonatomic) UIImage *revertImage;
@property (nonatomic) UIImage *originalImage;

@property NSMutableArray *state;
@property NSInteger currentStateIndex;

@property UIImage *currentMask;

- (void) applyState:(NSDictionary *) _state;
- (void) saveState;

@end

@implementation MainImageViewController

- (UIImage *) croppedImage {
    UIImage *image = _originalImage;
    return image;
}

- (UIImage *) originalImage {
    UIImage *image = _originalImage;
    
    if (self.currentMask) {
        image = [image imageWithMask:self.currentMask];
    }
    
    return image;
}

- (void) saveState {
    
    while (self.currentStateIndex < [self.state count]-1) {
        [self.state removeLastObject];
    }
    
    NSMutableDictionary *currentState = [@{} mutableCopy];
    
    if (self.maskImage.image != nil) {
        currentState[@"maskImageData"]  = self.maskImage.image;
        currentState[@"maskImageFrame"] = NSStringFromCGRect(self.maskImage.frame);
    }
    
    if (self.frameImage.image != nil) {
        currentState[@"frameImageData"]     = self.frameImage.image;
        currentState[@"frameImageFrame"]    = NSStringFromCGRect(self.frameImage.frame);
    }
    
    if (self.mainImage.image != nil) {
        currentState[@"mainImageData"]     = self.mainImage.image;
        currentState[@"mainImageFrame"]    = NSStringFromCGRect(self.mainImage.frame);
    }
    
    if (self.currentMask) {
        currentState[@"mask"] = self.currentMask;
    }
    
    currentState[@"currentEffectIndex"] = @(self.currentEffectIndex);

    [self.state addObject:currentState];
    self.currentStateIndex = [self.state indexOfObject:[self.state lastObject]];
}

- (void) applyState:(NSDictionary *) state {
    self.maskImage.image = nil;
    self.frameImage.image = nil;
    self.mainImage.image = nil;
    
    if (state[@"maskImageData"] != nil) {
        self.maskImage.image = state[@"maskImageData"];
        [self.maskImage setFrame:CGRectFromString(state[@"maskImageFrame"])];
    }
    
    if (state[@"frameImageData"] != nil) {
        self.frameImage.image = state[@"frameImageData"];
        [self.frameImage setFrame:CGRectFromString(state[@"frameImageFrame"])];
    }
    
    if (state[@"mainImageData"] != nil) {
        self.mainImage.image = state[@"mainImageData"];
        [self.mainImage setFrame:CGRectFromString(state[@"mainImageFrame"])];
    }
    
    self.currentMask = state[@"mask"];
    
    self.currentEffectIndex = [state[@"currentEffectIndex"] intValue];
}

- (void) setBaseImage:(UIImage *) _image {
    if (self.originalImage != nil) {
        return;
    }
    
    if (self.originalImage == nil) {
        self.revertImage = [_image copy];
        self.originalImage = _image;
        self.currentEffectIndex = 0;
        self.currentStateIndex = -1;
    }
    [self.mainImage setImage:self.originalImage];
    [self saveState];
}

- (void) applyEffect:(NSUInteger) _effect withIntensty:(CGFloat) _intensity {
    UIImage *toApply = self.originalImage;
    
    if (self.currentMask) {
        if (self.maskImage.hidden) {
            self.maskImage.hidden = NO;
        }
    }
    else {
        [self.maskImage setImage:nil];
    }
    
    self.currentEffectIndex = _effect;
    if (_effect == 0) {
        [self.mainImage setImage:toApply];
    }
    else {
        [self.mainImage setImage:[toApply imageWithFilter:_effect andIntensity:_intensity]];
    }
    [self saveState];
}

- (void) applyFrame:(NSUInteger) _frame {
    if (_frame == 0) {
        [self.frameImage setFrame:self.mainImage.frame];
        [self.frameImage setImage:nil];
    }
    else {
        UIImage *frame = [UIImage imageNamed:[NSString stringWithFormat:@"frame%d.png", _frame]];
        [self.frameImage setImage:frame];
        [self.frameImage setFrame:[self.mainImage displayRect]];
    }   
    [self saveState];
}

- (void) undo {
    if (self.currentStateIndex == 0)
        return;
    
    self.currentStateIndex--;
    [self applyState:self.state[self.currentStateIndex]];
}

- (void) redo {
    if (self.currentStateIndex == [self.state count] - 1)
        return;
    
    self.currentStateIndex++;
    [self applyState:self.state[self.currentStateIndex]];
}

- (void) applyMask:(UIImage *) _mask withEffect:(NSUInteger) effect {
    self.currentEffectIndex = effect;
    self.currentMask = _mask;
    [self applyEffect:self.currentEffectIndex withIntensty:0.5];
}

- (void) applyMask:(UIImage *) _mask {
    [self applyMask:_mask withEffect:self.currentEffectIndex];
}

- (void) removeMask {
    self.currentMask = nil;
    [self applyEffect:self.currentEffectIndex withIntensty:0.5];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.state = [@[] mutableCopy];
}

- (UIImage *) imageToCrop {
    return self.revertImage;
}

- (UIImage *) visibleImage {
    UIImageView *viewToUse = self.mainImage;

    if (self.currentMask) {
        viewToUse = self.maskImage;
    }

    CGRect displayRect = [viewToUse displayRect];
    CGRect newFrame = CGRectMake(0, 0, displayRect.size.width, displayRect.size.height);
    
    UIView *_visibleView = [[UIView alloc] initWithFrame:newFrame];
    [self.view addSubview:_visibleView];
    
    
    UIImageView *_maskViewImage = [[UIImageView alloc] initWithFrame:newFrame];
    [_maskViewImage setContentMode:UIViewContentModeScaleAspectFit];
    [_maskViewImage setImage:self.maskImage.image];
    [_visibleView addSubview:_maskViewImage];
    
    
    UIImageView *_mainViewImage = [[UIImageView alloc] initWithFrame:newFrame];
    [_mainViewImage setContentMode:UIViewContentModeScaleAspectFit];
    [_mainViewImage setImage:self.mainImage.image];
    [_visibleView addSubview:_mainViewImage];
    
    UIImage *img = [_visibleView captureImage];
    [_visibleView removeFromSuperview];
    
    return img;
}

- (UIImage *) sharingImage {
    UIImageView *viewToUse = self.mainImage;
    
    if (self.currentMask) {
        viewToUse = self.maskImage;
    }
    
    //change to actual size
    
    CGRect displayRect = [viewToUse displayRect];
    CGRect newFrame = CGRectMake(0, 0, displayRect.size.width, displayRect.size.height);
    
    UIView *_visibleView = [[UIView alloc] initWithFrame:newFrame];
    [self.view addSubview:_visibleView];
    
    
    UIImageView *_maskViewImage = [[UIImageView alloc] initWithFrame:newFrame];
    [_maskViewImage setContentMode:UIViewContentModeScaleAspectFit];
    [_maskViewImage setImage:self.maskImage.image];
    [_visibleView addSubview:_maskViewImage];
    
    
    UIImageView *_mainViewImage = [[UIImageView alloc] initWithFrame:newFrame];
    [_mainViewImage setContentMode:UIViewContentModeScaleAspectFit];
    [_mainViewImage setImage:self.mainImage.image];
    [_visibleView addSubview:_mainViewImage];
    
    UIImageView *_frameViewImage = [[UIImageView alloc] initWithFrame:newFrame];
    [_frameViewImage setContentMode:UIViewContentModeScaleToFill];
    [_frameViewImage setImage:self.frameImage.image];
    [_visibleView addSubview:_frameViewImage];
    
    UIImage *img = [_visibleView captureImage];
    [_visibleView removeFromSuperview];
    return img;
}

- (void) flattenMask {
    
    UIImageView *viewToUse = self.mainImage;
    
    if (self.currentMask) {
        viewToUse = self.maskImage;
    }
    
    //change to actual size
    
    CGRect displayRect = [viewToUse displayRect];
    CGRect newFrame = CGRectMake(0, 0, displayRect.size.width, displayRect.size.height);
    
    UIView *_visibleView = [[UIView alloc] initWithFrame:newFrame];
    [self.view addSubview:_visibleView];
    
    
    UIImageView *_maskViewImage = [[UIImageView alloc] initWithFrame:newFrame];
    [_maskViewImage setContentMode:UIViewContentModeScaleAspectFit];
    [_maskViewImage setImage:self.maskImage.image];
    [_visibleView addSubview:_maskViewImage];
    
    
    UIImageView *_mainViewImage = [[UIImageView alloc] initWithFrame:newFrame];
    [_mainViewImage setContentMode:UIViewContentModeScaleAspectFit];
    [_mainViewImage setImage:self.mainImage.image];
    [_visibleView addSubview:_mainViewImage];
    
    UIImage *img = [_visibleView captureImage];
    [_visibleView removeFromSuperview];

    [self updateImage:img];
    
    [self.maskImage setImage:img];
    [self.maskImage setHidden:YES];
    [self.mainImage setImage:img];
}

- (void) updateImage:(UIImage*) _image {
    [self setOriginalImage:_image];
    [self.mainImage setImage:_image];
    [self saveState];
}

- (void) revert {
    [self.mainImage setImage:self.revertImage];
    [self.maskImage setImage:nil];
    [self.frameImage setImage:nil];
    [self saveState];
}

@end
