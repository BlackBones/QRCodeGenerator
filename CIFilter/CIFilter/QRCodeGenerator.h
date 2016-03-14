//
//  QRCodeGenerator.h
//  CIFilter
//
//  Created by 刘波 on 16/3/11.
//  Copyright © 2016年 Liu Bo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeGenerator : NSObject

+ (UIImage *)QRCodeWithContent:(NSString *)content imageSize:(CGFloat)size;

+ (UIImage *)QRCodeImage:(UIImage *)codeImage withAvatarImage:(UIImage *)avatarImage;

+ (UIImage *)QRCodeWithContent:(NSString *)content imageSize:(CGFloat)size withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

@end
