//
//  ResultViewController.m
//  DeepSpin
//
//  Created by Blue Kei on 9/28/18.
//  Copyright © 2018 Blue Kei. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.imagePhoto setContentMode:UIViewContentModeScaleAspectFit];
    [self.imagePhoto setImage:self.imageResult];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
