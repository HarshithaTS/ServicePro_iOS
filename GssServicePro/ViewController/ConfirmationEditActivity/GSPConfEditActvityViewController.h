//
//  GSPConfEditActvityViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 18/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPBaseViewController.h"
#import "ServiceTask.h"
#import "GSPPickerController.h"

#import "GssMobileConsoleiOS.h"

GssMobileConsoleiOS *objServiceMngtCls;

@interface GSPConfEditActvityViewController : GSPBaseViewController
    //selvan 4thMay15
    @property (strong, nonatomic) NSString *serviceItem, *timeZoneFrom, *duration, *serviceNote, *startDate, *endDate;
    @property (strong, nonatomic) NSString * numberExt, *serviceID;

    //




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withObject:(ServiceTask*)serviceTask numberExtensio:(NSString*)numbExt andServiceID:(NSString*)serviceOrderId;



@end
