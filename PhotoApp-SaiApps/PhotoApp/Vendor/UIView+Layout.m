//
//  UIView+Layout.m
//  PhotoApp
//
//

#import "UIView+Layout.h"

#define kUIVBoxViewVerticalMargin   10.0f
#define kScaleAnimationDuration     0.5f
#define kScreenWidth                1024.0f
#define kScreenHeight               748.0f
#define kNavigationAnimationTransitionDuration 0.5f

#define kLayoutAnimationDuration        0.15f
#define kLayoutAnimationDelayDuration   0.03f


@implementation UIView (Layout)


- (void)relayoutChildrenHorizontally{
	[self relayoutChildrenHorizontallyWithMargin:kUIVBoxViewVerticalMargin];
}

- (void)relayoutChildrenVertically{
	[self relayoutChildrenVerticallyWithMargin:kUIVBoxViewVerticalMargin];
}

- (void)relayoutChildrenHorizontallyWithMargin:(float)margin{
	float _controlPosition	= margin;
	CGRect _frame;
    
	for (UIView *_child in [self subviews]) {
		if (!_child.hidden && _child.alpha != 0.0f) {
			_frame				= _child.frame;
			_frame.origin.x		= _controlPosition;
			_child.frame		= _frame;
			_controlPosition    += margin + _frame.size.width;
		}
	}
    
	if ([self isKindOfClass:[UIScrollView class]])
		[(UIScrollView *)self setContentSize:CGSizeMake(_controlPosition, self.frame.size.height)];
}

- (void)relayoutChildrenVerticallyWithMargin:(float)margin{
	float _controlPosition	= margin;
	CGRect _frame;
    
	for (UIView *_child in [self subviews]) {
		if (!_child.hidden && _child.alpha != 0.0f) {
			_frame				= _child.frame;
			_frame.origin.y		= _controlPosition;
			_child.frame		= _frame;
			_controlPosition    += margin + _frame.size.height;
		}
	}
    
	if ([self isKindOfClass:[UIScrollView class]])
		[(UIScrollView *)self setContentSize:CGSizeMake(self.frame.size.height, _controlPosition)];
}

#pragma mark capture single frame

- (UIImage *)captureImage {
	UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (void)bounceToIdentityTransfromWithBlock:(void (^)(void))block{
    CGAffineTransform _originalTransform = self.transform;
    [UIView animateWithDuration:kScaleAnimationDuration/2
                          delay:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.transform = CGAffineTransformScale(_originalTransform, 1.1f, 1.1f);
                     } completion:^(BOOL finished){
                         [UIView animateWithDuration:kScaleAnimationDuration
                                               delay:0.0f
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              self.transform = _originalTransform;
                                          } completion:^(BOOL finished){
                                              if (block) {
                                                  block();
                                              }
                                          }];
                     }];
}
- (BOOL)dropChildrenInGridWithRows:(int)rows andColumns:(int)columns animated:(BOOL)animated{
    if ([self.subviews count] > rows*columns) {
        return NO;
    }
	
    //    int width           = self.frame.size.width;
    //    int height          = self.frame.size.height;
    //    int tileWidth       = width/columns;
    //    int tileHeight      = height/rows;
	
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }
	
    int _childIndex = 0;
	
    for (int row=0; row < rows; row++) {
        for (int col=0; col < columns; col++) {
            if (animated) {
                [UIView setAnimationDelay:_childIndex*kLayoutAnimationDelayDuration];
            }
            if (_childIndex < [self.subviews count]) {
                UIView *_view   = [self.subviews objectAtIndex:_childIndex];
                int _centerX    = (row*columns+col)*100+100;
                int _centerY    = 500;
                _view.center    = CGPointMake(_centerX, _centerY);
            }
            _childIndex ++;
        }
    }
	
    if (animated) {
        [UIView commitAnimations];
    }
	
    return YES;
}

- (BOOL)arrangeChildrenInGridWithRows:(int)rows andColumns:(int)columns animated:(BOOL)animated{
    if ([self.subviews count] > rows*columns) {
        return NO;
    }
    
    int width           = self.frame.size.width;
    int height          = self.frame.size.height;
    int tileWidth       = width/columns;
    int tileHeight      = height/rows;
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kLayoutAnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }
    
    int _childIndex = 0;
    
    for (int row=0; row < rows; row++) {
        for (int col=0; col < columns; col++) {
            if (animated) {
                [UIView setAnimationDelay:_childIndex*kLayoutAnimationDelayDuration];
            }
            if (_childIndex < [self.subviews count]) {
                UIView *_view   = [self.subviews objectAtIndex:_childIndex];
                int _centerX    = tileWidth*col + tileWidth/2;
                int _centerY    = tileHeight*row + tileHeight/2;
                _view.center    = CGPointMake(_centerX, _centerY);
            }
            _childIndex ++;
        }
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    return YES;
}

- (void)enableInteraction{
    self.userInteractionEnabled = YES;
}

- (void)animateWithTransition:(NSString *)transition{
    self.userInteractionEnabled = NO;
    CATransition *_transition	= [CATransition animation];
    _transition.duration		= kNavigationAnimationTransitionDuration;
    _transition.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type			= transition;
    [[self layer] addAnimation:_transition forKey:nil];
    [self performSelector:@selector(enableInteraction) withObject:nil afterDelay:kNavigationAnimationTransitionDuration];
}

- (void)removeAllGestureRecognizers {
    for (UIGestureRecognizer *_gesture in [self gestureRecognizers]) {
        [self removeGestureRecognizer:_gesture];
    }
}

- (void)removeAllSubviews{
    for (UIView *_child in self.subviews) {
        [_child removeFromSuperview];
		
    }
}

- (void)addSubviewAnimated:(UIView *)subview{
    [self addSubview:subview];
    
    CGAffineTransform _originalTransform = subview.transform;
    
    subview.alpha                   = 0.0f;
    CGAffineTransform _transform    = CGAffineTransformMakeScale(1.2f, 1.2f);
    _transform                      = CGAffineTransformRotate(_transform, -M_PI_4/2);
    subview.transform               = _transform;
    
    [UIView animateWithDuration:kScaleAnimationDuration animations:^{
        subview.alpha       = 1.0f;
        subview.transform   = _originalTransform;
    } completion:nil];
}

- (void)removeFromSuperviewAnimated{
    CGAffineTransform _transform    = CGAffineTransformScale(self.transform, 0.5f, 0.5f);
    _transform                      = CGAffineTransformRotate(_transform, M_PI_4/2);
    
    [UIView animateWithDuration:kScaleAnimationDuration/2 animations:^{
        self.alpha          = 0.0f;
        self.transform      = _transform;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (void)showAnimated {
    self.transform = CGAffineTransformMakeScale(0.4f, 0.4f);
    self.alpha     = 0.0f;
    self.hidden    = NO;
    
    [UIView animateWithDuration:kScaleAnimationDuration/2 animations:^{
        self.alpha      = 1.0f;
        self.transform  = CGAffineTransformMakeScale(1.2f, 1.2f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kScaleAnimationDuration/4 animations:^{
            self.transform  = CGAffineTransformIdentity;
        }];
    }];
}

- (void)hideAnimated {
    self.transform = CGAffineTransformIdentity;
    self.alpha     = 1.0f;
    self.hidden    = NO;
    
    [UIView animateWithDuration:kScaleAnimationDuration/4 animations:^{
        self.transform  = CGAffineTransformMakeScale(1.2f, 1.2f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kScaleAnimationDuration/2 animations:^{
            self.transform  = CGAffineTransformMakeScale(0.1f, 0.1f);
            self.alpha      = 0.0f;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }];
}

- (void)setVisibleAnimated:(BOOL)visible{
    if (visible) {
        [self showAnimated];
    } else {
        [self hideAnimated];
    }
}

- (void)centerHorizontallyInParent{
    self.center = CGPointMake(self.superview.frame.size.width/2, self.center.y);
}
- (void)centerVerticallyInParent{
    self.center = CGPointMake(self.center.x, self.superview.frame.size.height/2);
}
- (void)centerInParent{
    self.center = CGPointMake(self.superview.frame.size.width/2, self.superview.frame.size.height/2);
}
- (void)fitInParent{
    self.frame = self.superview.bounds;
}
- (void)fitParentWithPadding:(float)padding{
    self.superview.bounds = CGRectInset(self.bounds, -padding, -padding);
}
- (void)fitParent{
    [self fitParentWithPadding:0.0f];
}


@end
