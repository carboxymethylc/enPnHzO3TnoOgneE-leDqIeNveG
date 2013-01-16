//
//  SmoothedBIView.m
//  PhotoApp
//
//

#import "SmoothedBIView.h"

@implementation SmoothedBIView
{
    UIBezierPath *path;
    UIImage *incrementalImage;
    UIImage *maskImage;
    CGPoint pts[5]; // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    uint ctr;
    BOOL erasor;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        path = [UIBezierPath bezierPath];
        [path setLineWidth:30.0];
        erasor = NO;
    }
    return self;
}

- (void) setLineWidth:(CGFloat) _width {
    [path setLineWidth:_width];
}

- (void) enableErasor {
    erasor = YES;
    [self setLineWidth:30.0];
}

- (void) disableErasor {
    erasor = NO;
}

- (void)drawRect:(CGRect)rect
{
    if (erasor) {
        [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] setStroke];
    }
    else {
        [[UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5] setStroke];
    }
    
    [incrementalImage drawInRect:rect];
    
    
    [path stroke];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ctr = 0;
    UITouch *touch = [touches anyObject];
    pts[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    ctr++;
    pts[ctr] = p;
    if (ctr == 4)
    {
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
        [path moveToPoint:pts[0]];
        [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
        [self setNeedsDisplay];
        // replace points and get ready to handle the next segment
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self drawBitmap];
    [self setNeedsDisplay];
    [path removeAllPoints];
    ctr = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawIncrementalImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    if (!incrementalImage)
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor clearColor] setFill];
        [rectpath fill];
    }
    
    [incrementalImage drawAtPoint:CGPointZero];
    [[UIColor colorWithRed:0 green:1.0 blue:0 alpha:1.0] setStroke];
    
    [path stroke];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)drawBitmap
{
    if (erasor) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor blackColor] setFill];
        [rectpath fill];

        
        [maskImage drawAtPoint:CGPointZero];
        [[UIColor whiteColor] setStroke];
        [path stroke];
        maskImage = UIGraphicsGetImageFromCurrentImageContext();
        CGSize _originalSize = incrementalImage.size;
        incrementalImage = [[incrementalImage imageWithMask:maskImage] resizedImage:_originalSize interpolationQuality:kCGInterpolationDefault];
        maskImage = nil;
        UIGraphicsEndImageContext();
        [self performSelector:@selector(drawIncrementalImage) withObject:nil afterDelay:0.5];
    }
    else {
        [self drawIncrementalImage];
    }
}

- (UIImage *) currentImage {
   UIImage *_currentImage;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    if (!_currentImage)
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    
    [incrementalImage drawAtPoint:CGPointZero];
    [[UIColor blackColor] setStroke];
    [path stroke];
    _currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return _currentImage;
}

@end