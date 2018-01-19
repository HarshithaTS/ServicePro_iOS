//
//  GSPSignatureCaptureView.h
//  GssServicePro
//
//  Created by Riyas Hassan on 07/08/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPSignatureCaptureView : UIView
{
    CGPoint         lastPoint,currentPoint,lastContactPoint1,lastContactPoint2;
    BOOL            mouseSwiped;
    int             fingerMoved;
}

@property (nonatomic, assign) CGRect imageFrame;

@property (weak, nonatomic) IBOutlet UIImageView *drawImage;

- (IBAction)cancelSignature:(id)sender;

- (IBAction)saveSignature:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *signUpImage;
@property (weak, nonatomic) IBOutlet UILabel *signHereLabel;

@end