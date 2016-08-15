//
//  QRCodeGenerator.m
//  CIFilter
//
//  Created by 刘波 on 16/3/11.
//  Copyright © 2016年 Liu Bo. All rights reserved.
//

#import "QRCodeGenerator.h"
#import "UIImage+RoundedImage.h"

@interface QRCodeGenerator ()
@property (nonatomic,strong) CIFilter *filter;


@end


@implementation QRCodeGenerator


+ (UIImage *)QRCodeWithContent:(NSString *)content imageSize:(CGFloat)size{
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    QRCodeGenerator *generator = [[QRCodeGenerator alloc] init];
    [generator.filter setValue:data forKey:@"inputMessage"];
    CIImage *ciimage = [generator.filter outputImage];
    
    UIImage *codeImage = [generator createNonInterpolatedUIImageFormCIImage:ciimage withSize:size ];
    return codeImage;
}

+ (UIImage *)QRCodeImage:(UIImage *)codeImage withAvatarImage:(UIImage *)avatarImage{
    
    //two-dimension code 二维码
    CGSize size = codeImage.size;
    CGSize size2 =CGSizeMake(1.0 / 5.5 * size.width, 1.0 / 5.5 * size.height);
    
    //圆角
    UIImage *roundedImg = [UIImage createRoundedRectImage:avatarImage size:size2 radius:5 ];
    
    UIGraphicsBeginImageContext(size);
    
    [codeImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [roundedImg drawInRect:CGRectMake((size.width - size2.width) / 2.0, (size.height - size2.height) / 2.0, size2.width, size2.height)];
    
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
    
}

+ (UIImage *)QRCodeWithContent:(NSString *)content imageSize:(CGFloat)size withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    QRCodeGenerator *generator = [[QRCodeGenerator alloc] init];
    [generator.filter setValue:data forKey:@"inputMessage"];
    CIImage *ciimage = [generator.filter outputImage];
    
    UIImage *image = [generator createNonInterpolatedUIImageFormCIImage:ciimage withSize:size ];
    
    UIImage *codeImage = [generator imageBlackToTransparent:image withRed:red andGreen:green andBlue:blue];
    
    return codeImage;
    
}


- (instancetype)init{
    self = [super init];
    if (self) {
        
        _filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [_filter setDefaults];
        
    }
    
    return self;
}


- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}



@end
