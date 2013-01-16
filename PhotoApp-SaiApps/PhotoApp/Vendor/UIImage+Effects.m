//
//  UIImage+Effects.m
//  PhotoApp
//
//

#import "UIImage+Effects.h"
#import "GPUImage.h"
#import "GrayscaleContrastFilter.h"

@implementation UIImage (Effects)

- (UIImage *) imageWithMask:(UIImage *)maskImage {
    CGImageRef maskRef = maskImage.CGImage;
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
	CGImageRef masked = CGImageCreateWithMask([self CGImage], mask);
	return [UIImage imageWithCGImage:masked];
}

- (UIImage *) imageWithFilter:(NSUInteger) _index andIntensity:(CGFloat) _intensity {
    GPUImageOutput *filter;
    
    switch (_index) {
        case 1:
            filter = [[GPUImageExposureFilter alloc] init];
            [(GPUImageExposureFilter*)filter setExposure:(3.0-(1.0))*_intensity + (1.0)];
            break;
        case 2:
            filter = [[GPUImageContrastFilter alloc] init];
            [(GPUImageContrastFilter*) filter setContrast:(3.0-(1.0))*_intensity + (1.0)];
            break;
        case 3:
            filter = [[GPUImageSaturationFilter alloc] init];
            [(GPUImageSaturationFilter*)filter setSaturation:(2.0-(1.0))*_intensity + (1.0)];
            break;
        case 4:
            filter = [[GPUImageHueFilter alloc] init];
            [(GPUImageHueFilter *)filter setHue:(330.0-(30.0))*_intensity + (30.0)];
            break;
        case 5:
            filter = [[GPUImageSepiaFilter alloc] init];
            [(GPUImageSepiaFilter*)filter setIntensity:(1.0-(0.5))*_intensity + (0.5)];
            break;
        case 6:
            filter = [[GPUImageSharpenFilter alloc] init];
            [(GPUImageSharpenFilter *)filter setSharpness:(4.0-(1.0))*_intensity + (1.0)];
            break;
        case 7:
            filter = [[GPUImagePixellateFilter alloc] init];
            [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:(0.05-(0.01))*_intensity + (0.01)];
            break;
        case 8:
            filter = [[GPUImagePosterizeFilter alloc] init];
            [(GPUImagePosterizeFilter*)filter setColorLevels:(15 - ((12-6)*_intensity + (6)))];
            break;
        case 9:
            filter = [[GPUImageMonochromeFilter alloc] init];
            [(GPUImageMonochromeFilter*)filter setIntensity:(0.99-(0.3))*_intensity + (0.3)];
            break;
        case 10:
            filter = [[GPUImageTiltShiftFilter alloc] init];
            [(GPUImageTiltShiftFilter*)filter setBlurSize:(8.0-(2.0))*_intensity + (2.0)];
            break;    
        default:
            break;
    }

//    filter = [[GPUImageGammaFilter alloc] init];
//    CGFloat value = 3.0 - ((3.0-(1.0))*_intensity + (1.0));
//    [(GPUImageGammaFilter*)filter setGamma:value];
    
    
    return [filter imageByFilteringImage:self];
}

//- (UIImage *) imageWithFilter:(NSUInteger) _index andIntensity:(CGFloat) _intensity {
//    GPUImageFilter *filter;
//    switch (_index) {
//        case 1:{
//            filter = [[GPUImageContrastFilter alloc] init];
//            [(GPUImageContrastFilter *) filter setContrast:1.75];
//        } break;
//        case 2: {
//            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"crossprocess"];
//        } break;
//        case 3: {
//            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"02"];
//        } break;
//        case 4: {
//            filter = [[GrayscaleContrastFilter alloc] init];
//        } break;
//        case 5: {
//            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"17"];
//        } break;
//        case 6: {
//            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
//        } break;
//        case 7: {
//            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow-red"];
//        } break;
//        case 8: {
//            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"06"];
//        } break;
//        case 9: {
//            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"purple-green"];
//        } break;
//        case 10: {
//            filter = [[GPUImageSepiaFilter alloc] init];
//        } break;
//        default:
//            filter = [[GPUImageFilter alloc] init];
//            break;
//    }
//    return [filter imageByFilteringImage:self];
//}

- (UIImage *) imageWithFilter:(NSUInteger) index {
    return [self imageWithFilter:index andIntensity:0.5];
}

@end
