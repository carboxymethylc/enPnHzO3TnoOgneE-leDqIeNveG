//
//  UIView+Layout.h
//  PhotoApp
//
//

#import <UIKit/UIKit.h>

@interface UIView (Layout)

- (void)relayoutChildrenHorizontally;
- (void)relayoutChildrenVertically;
- (void)relayoutChildrenHorizontallyWithMargin:(float)margin;
- (void)relayoutChildrenVerticallyWithMargin:(float)margin;
- (UIImage *)captureImage;

- (void)bounceToIdentityTransfromWithBlock:(void (^)(void))block;
- (BOOL)arrangeChildrenInGridWithRows:(int)rows andColumns:(int)columns animated:(BOOL)animated;
- (void)animateWithTransition:(NSString *)transition;

- (void)addSubviewAnimated:(UIView *)subview;
- (void)removeFromSuperviewAnimated;
- (void)removeAllSubviews;
- (void)removeAllGestureRecognizers;

- (void)showAnimated;
- (void)hideAnimated;
- (void)setVisibleAnimated:(BOOL)visible;

- (void)centerHorizontallyInParent;
- (void)centerVerticallyInParent;
- (void)centerInParent;
- (void)fitInParent;

- (void)fitParentWithPadding:(float)padding;
- (void)fitParent;

@end
