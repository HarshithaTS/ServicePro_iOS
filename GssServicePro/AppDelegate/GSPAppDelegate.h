//
//  GSPAppDelegate.h
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPViewController.h"

@interface GSPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController * mainView;

@property (nonatomic, retain) UINavigationController *mainController;

// Added by Harshitha
@property (nonatomic, assign) BOOL callContextDataApiFlag;
@property (nonatomic, assign) BOOL didBecomeActive;
@property (nonatomic, retain) NSString * activeApp;
@property (nonatomic, assign) BOOL updateFailureFlag;
@property (nonatomic, assign) BOOL QPinstalledFlag;
//@property (nonatomic, assign) BOOL databaseEmptyFlag;
@property (nonatomic, assign) BOOL isTaskForTodayScreen;

//Added on 10th Aug 2015 by Selvan
@property (nonatomic, assign) BOOL saveChangesFlag;

@end
