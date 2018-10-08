//
//  Util.h
//  DeepSpin
//
//  Created by Blue Kei on 10/2/18.
//  Copyright © 2018 Blue Kei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Util : NSObject

+ (void)showMessage:(NSString *)message title:(NSString *)title controller:(UIViewController *)controller;
+ (UIImage*)resizeImage:(UIImage*)image withDimension:(CGFloat)maxDimension;

@end

NS_ASSUME_NONNULL_END
