//
//  GSPServiceTasksViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPBaseViewController.h"
#import "Colleagues.h"
#import "ServiceTask.h"

@interface GSPServiceTasksViewController : GSPBaseViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forView:(ScreenType)type withTitle:(NSString*)selectedColleagueName anduName:(NSString*)uName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forView:(ScreenType)type withTitle:(NSString*)selectedColleagueName andSelectedColleague:(Colleagues *)selected_colleague transferTask:(ServiceTask *)transferTask;

@end
