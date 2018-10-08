//
//  ViewController.m
//  DeepSpin
//
//  Created by Blue Kei on 9/28/18.
//  Copyright © 2018 Blue Kei. All rights reserved.
//

#import "ViewController.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking/AFNetworking.h>
#import "ResultViewController.h"

#define SERVER_IP   @"http://75.80.129.141:7912"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueResult"]) {
        
        NSLog(@"%@", segue.identifier);
        if ([segue.identifier isEqualToString:@"segueResult"]) {
            ResultViewController *controller = segue.destinationViewController;
            controller.imageResult = self.imageResult;
        }
    }
}

- (IBAction)selectPhoto:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select Photo Type" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:(id)self];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:(id)self];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imagePhoto setImage:image];
    [self.imagePhoto setContentMode:UIViewContentModeScaleAspectFit];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadPhoto:(id)sender {
    if(self.imagePhoto.image == nil) {
        [Util showMessage:@"Please select photo" title:@"Infomation" controller:self];
        return;
    }
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    
    [spinner startAnimating];
    self.buttonCamera.enabled = NO;
    self.buttonUpload.enabled = NO;
    
    UIImage *imageForUpload = [Util resizeImage:self.imagePhoto.image withDimension:800.0f];
    NSData *imageViewData = UIImagePNGRepresentation(imageForUpload);
    
    NSString *timestamp = [NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
    NSString *imageFileName = [NSString stringWithFormat:@"ios_%@.png", timestamp];
    
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=---------------------------14737809831466499882746641449",
                               @"cache-control": @"no-cache" };
    NSMutableArray *parameters = [[NSMutableArray alloc]initWithObjects:@"ostype", nil];
    NSMutableArray *values = [[NSMutableArray alloc]initWithObjects:@"iOS", nil];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    //NSData *dataImage = UIImageJPEGRepresentation(imageView.image, 1.0f); uncomment for image
    
    NSMutableData *body = [NSMutableData data];
    
    for (int i=0;i<parameters.count;i++) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",[parameters objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[values objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSLog(@"Parameters : %@",parameters);
    NSLog(@"Values : %@",values);
    
    //image
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", imageFileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageViewData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fileupload.php", SERVER_IP]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:body];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error);
            
            [spinner stopAnimating];
            self.buttonCamera.enabled = YES;
            self.buttonUpload.enabled = YES;
            
            [Util showMessage:@"The request timed out." title:@"Error" controller:self];
        } else {
            
            NSMutableArray *array=[[NSMutableArray alloc]init];
            NSLog(@"PostMethod Result : %@, PostMethod Error : %@",array,error);

            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/output/%@", SERVER_IP, imageFileName]];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];

            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                NSLog(@"%@", filePath);
                
                [spinner stopAnimating];
                self.buttonCamera.enabled = YES;
                self.buttonUpload.enabled = YES;
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@", [filePath path]]]) {
                    NSLog(@"File downloaded to: %@", filePath);
                    self.imageResult = [UIImage imageWithContentsOfFile:[filePath path]];
                    [self performSegueWithIdentifier:@"segueResult" sender:self];
                } else {
                    [Util showMessage:@"File download failed." title:@"Error" controller:self];
                }

            }];
            [downloadTask resume];
        }
    }];
    [dataTask resume];
}

@end
