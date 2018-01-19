//
//  GSPDocViewerViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 22/07/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPDocViewerViewController.h"

@interface GSPDocViewerViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *pdfWebView;
@property (strong,nonatomic) NSData * pdfData;
@end

@implementation GSPDocViewerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSData*)data andFileName:(NSString*)fileName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = fileName;
        self.pdfData = data;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    [self.pdfWebView loadData:self.pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    
    UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    
    NSString *imageName = [NSString stringWithFormat:@"%@.png",self.title];
    myImage.image = [UIImage imageNamed:imageName];
    
    [self.pdfWebView addSubview:myImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
