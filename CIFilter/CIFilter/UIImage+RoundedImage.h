//
//  UIImage+RoundedImage.h
//  CIFilter
//
//  Created by 刘波 on 16/8/15.
//  Copyright © 2016年 Liu Bo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end
