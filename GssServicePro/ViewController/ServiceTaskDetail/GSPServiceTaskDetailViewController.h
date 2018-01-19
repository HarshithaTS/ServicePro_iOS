//
//  GSPServiceTaskDetailViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 05/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceTask.h"
#import "GSPBaseViewController.h"

#import "GssMobileConsoleiOS.h"

GssMobileConsoleiOS *objServiceMngtCls;

@interface GSPServiceTaskDetailViewController : GSPBaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withObject:(ServiceTask*)serviceTaskObj atIndex:(int)index andOrdersArray:(NSMutableArray*)objectsArray;

- (void) showServiceConfirmation;

@property (strong, nonatomic) NSString *tableName;

- (IBAction)attachImageButtonClicked:(id)sender;

@end
