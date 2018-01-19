//
//  GSPAppDelegate.m
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "GSPAppDelegate.h"
#import "GSPLocationManager.h"
#import "GSPLocationPingService.h"

@implementation GSPAppDelegate

// Added by Harshitha
@synthesize callContextDataApiFlag;
@synthesize didBecomeActive;
@synthesize activeApp;
@synthesize updateFailureFlag;
@synthesize QPinstalledFlag;
//@synthesize databaseEmptyFlag;
//Added on 10th Aug 2015 by Selvan
@synthesize saveChangesFlag;
@synthesize isTaskForTodayScreen;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
// Added by Harshitha    
    callContextDataApiFlag = TRUE;
    didBecomeActive = FALSE;
    activeApp = @"";
    updateFailureFlag = TRUE;
    QPinstalledFlag = FALSE;
//    databaseEmptyFlag = FALSE;
    isTaskForTodayScreen = FALSE;
    
//Added on 10th Aug 2015 by Selvan
    saveChangesFlag = TRUE;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self setUpViewForOrientation:interfaceOrientation];
    
/*    if (IS_IPAD) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
            self.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad" bundle:nil];
        else
            self.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad_Portrait" bundle:nil];
    }
    else
    {
        self.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController" bundle:nil];
    }
*/
    self.mainController = [[UINavigationController alloc] initWithRootViewController:self.mainView];
	self.mainController.navigationBarHidden = NO;
    self.window.backgroundColor = [UIColor whiteColor];//BACKGROUND_COLOR;
    [self.window setRootViewController:self.mainController];
	[self.window addSubview:self.mainController.view];
	[self.window makeKeyAndVisible];

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255.0/255 green:143.0/255 blue:30.0/255 alpha:1.0]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self openReceiverApp:nil];
    
    //[[GSPLocationManager sharedInstance]initLocationMnager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDetailScreen:) name:@"notificationDetailScreen" object:nil];
    
    return YES;

}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setUpViewForOrientation:toInterfaceOrientation];
}

-(void)setUpViewForOrientation:(UIInterfaceOrientation)orientation
{
    [self.mainView.view removeFromSuperview];
    if (IS_IPAD) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
            self.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad" bundle:nil];
        else
            self.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad_Portrait" bundle:nil];
    }
    else
    {
        self.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController" bundle:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

// Added by Harshitha
    BOOL rtnResult;
    GssMobileConsoleiOS *objServiceMngtCls = [[GssMobileConsoleiOS alloc] init];
    //    objServiceMngtCls.CRMdelegate = self;
    objServiceMngtCls.TargetDatabase = @"db_queueprocessor";
    objServiceMngtCls.qryString = [NSString stringWithFormat:@"UPDATE QP0610114_2456 SET periority = 2 WHERE subapplication = %@",@"Service Orders"];
    
    NSLog(@"Update query %@", objServiceMngtCls.qryString);
    
    rtnResult = [objServiceMngtCls excuteSqliteQryString];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
//  Original code.....Commented by Harshitha to call ServiceOrder api  
//    GSPLocationPingService *locationPingService = [GSPLocationPingService new];
//    [locationPingService initializePingServiceCall];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//  *****  Added by Harshitha to call ServiceOrder api everytime app comes to foreground  *****
    if ([activeApp isEqualToString:@"ServiceOrders"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"callServiceOrderApi" object:nil];
    }
    
    else if ([activeApp isEqualToString:@"ServiceOrderEdit"] || [activeApp isEqualToString:@"Main"] || [activeApp isEqualToString:@"ColleagueList"]) {
        self.didBecomeActive= TRUE;
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(IBAction) openReceiverApp:(id)sender {
    // Opens the Receiver app if installed, otherwise displays an error
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *URLEncodedText = [@"This is a test string" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *ourPath = [@"openQueueProcessor://" stringByAppendingString:URLEncodedText];//com.gss.genericIOsQueueProcessor/
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    if ([ourApplication canOpenURL:ourURL]) {
        [ourApplication openURL:ourURL];
        QPinstalledFlag = TRUE;
    }
//  Comment while distributing app to client to avoid the popup
/*    else {
        //Display error
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"QueueProcessor app Not found" message:@"Please install Queue Processor app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
*/
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // Display text
//    UIAlertView *alertView;
//    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    alertView = [[UIAlertView alloc] initWithTitle:@"Text" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];

    return YES;
}

/*
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    UIApplicationState state = [application applicationState];
//    if (state != UIApplicationStateActive) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationDetailScreen" object:nil];
//        [self openParentApp:nil];
//    }
//    
//    application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber - 1;
    
    [[GSPUtility sharedInstance]showAlertWithTitle:@"notification received" message:@"hi" otherButton:nil tag:0 andDelegate:self];
}
*/

- (void)openDetailScreen:(NSNotification*)notification
{
    [[GSPUtility sharedInstance]showAlertWithTitle:@"notification received" message:@"hi" otherButton:nil tag:0 andDelegate:self];
}

@end
