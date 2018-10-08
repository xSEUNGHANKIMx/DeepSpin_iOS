//
//  ViewController.h
//  DeepSpin
//
//  Created by Blue Kei on 9/28/18.
//  Copyright © 2018 Blue Kei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (strong, nonatomic) UIImage *imageResult;
@property (weak, nonatomic) IBOutlet UIButton *buttonCamera;
@property (weak, nonatomic) IBOutlet UIButton *buttonUpload;

- (IBAction)selectPhoto:(id)sender;
- (IBAction)uploadPhoto:(id)sender;

@end

