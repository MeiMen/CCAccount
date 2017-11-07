//
//  ZKNavigationBar.m
//  CCAccount
//
//  Created by papa on 2017/11/7.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKNavigationBar.h"

@implementation ZKNavigationBar
+ (void)initialize{
   
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    navigationBarAppearance.barTintColor = [UIColor whiteColor];
    
    
    UIColor *bgColor = [UIColor colorWithRed:253/255.0 green:120/255.0 blue:185/255.0 alpha:1];
    backgroundImage = [self imageWithColor:bgColor];
    
    textAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                       NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    [navigationBarAppearance setShadowImage:[UIImage imageNamed:@"purpleLine"]];
        // 方式1：使用自己的图片替换原来的返回图片
}

+(UIImage *)imageWithColor:(UIColor *)color{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    if (!color ||size.width<=0 ||size.height<=0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
