//
//  Util.m
//  DeepSpin
//
//  Created by Blue Kei on 10/2/18.
//  Copyright © 2018 Blue Kei. All rights reserved.
//

#import "Util.h"

@implementation Util

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (void)showMessage:(NSString *)message title:(NSString *)title controller:(UIViewController *)controller
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (UIImage*)resizeImage:(UIImage*)image withDimension:(CGFloat)maxDimension
{
    if (fmax(image.size.width, image.size.height) <= maxDimension) {
        return image;
    }
    CGFloat aspect;
    CGSize newSize;
    if (image.size.width > image.size.height) {
        aspect = image.size.width / image.size.height;
        newSize = CGSizeMake(maxDimension, maxDimension/aspect);
    } else {
        aspect = image.size.height / image.size.width;
        newSize = CGSizeMake(maxDimension/aspect, maxDimension);
    }
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    CGRect newImageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    [image drawInRect:newImageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
