//
//  GSPViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "GSPViewController.h"
#import "GSPServiceTasksViewController.h"
#import "GSPInfoScreenViewController.h"
#import "GssMobileConsoleiOS.h"
#import "ServiceOrderClass.h"
#import "ServiceTask.h"

@interface GSPViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *totalServiceTaskButton;
//@property (weak, nonatomic) IBOutlet UIButton *completedTaskButton;
@property (weak, nonatomic) IBOutlet UIButton *vanStockButton;
@property (weak, nonatomic) IBOutlet UIButton *utilisationButton;
//@property (weak, nonatomic) IBOutlet UIButton *absenceReqButton;
@property (weak, nonatomic) IBOutlet UIButton *activitiesButton;
@property (weak, nonatomic) IBOutlet UIButton *contatcsButton;
@property (weak, nonatomic) IBOutlet UIButton *billableButton;

- (IBAction)totalServiceTasksButtonClick:(id)sender;
- (IBAction)taskForTheDayButtonClicked:(id)sender;
- (IBAction)vanStockButtonClicked:(id)sender;
- (IBAction)utilizationButtonClicked:(id)sender;
- (IBAction)contactsButtonClicked:(id)sender;
- (IBAction)billableButtonClicked:(id)sender;
- (IBAction)activitiesButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *nextServiceOrgName;
@property (weak, nonatomic) IBOutlet UILabel *nextServiceLocation1;
@property (weak, nonatomic) IBOutlet UILabel *nextServiceLocation2;
@property (weak, nonatomic) IBOutlet UILabel *nextServiceLocation3;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UIButton *contactNum1Button;
@property (weak, nonatomic) IBOutlet UIButton *contactNum2Button;
@property (weak, nonatomic) IBOutlet UILabel *totalNumOfTasksLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfTasksForTodayLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneIcon1;
@property (weak, nonatomic) IBOutlet UIButton *phoneIcon2;
@property (strong, nonatomic) NSMutableArray * serviceTaskArray,* todayServiceTasksLocationArray;
@property (weak, nonatomic) NSString *contactNumber;
@property (weak, nonatomic) IBOutlet UIButton *emailIDButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIWebView *mapWebView;
@property (nonatomic) CLLocationCoordinate2D coords;
@property (nonatomic) CLLocationCoordinate2D currentLocation;

@end

@implementation GSPViewController

GSPAppDelegate *appDelegateObj;
ServiceTask *serviceTask;
int numOfTasksForToday;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
//    GSPViewController *view = (GSPViewController *)[nibNameOrNil dequeueReusableCellWithIdentifier:@"GSPViewController_iPad"];
    

    /NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:@"GSPViewController_iPad" owner:self options:nil];
    
    if (self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
        self = (GSPViewController *)[nib objectAtIndex:1];
    }
    else {
        self = (GSPViewController *)[nib objectAtIndex:0];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    [self setUpViewForOrientation:interfaceOrientation];
    
    [self createDataBases];

//	[self setUpView];
    
//    [self initialiseVariables];
}

/*
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setUpViewForOrientation:toInterfaceOrientation];
}

-(void)setUpViewForOrientation:(UIInterfaceOrientation)orientation
{
    [self.view removeFromSuperview];
    if (IS_IPAD) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
            self.view = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad" bundle:nil];
        else
            self.view = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad_Portrait" bundle:nil];
    }
    else
    {
        self.view = [[GSPViewController alloc] initWithNibName:@"GSPViewController" bundle:nil];
    }
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
/*    if (self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        self.view = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad_Portrait" bundle:nil];
    } else {
        self.view = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad" bundle:nil];
    }
*/
    appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj.activeApp = @"Main";
    
    [self setNavigationTitleWithBrandImage:nil];
    [self setLeftNavigationBarButtonWithImage:@"ServiceProIcon.png"];
    
    [self initialiseVariables];
    
    [self getUserCurrentLocation];
    
    [self setUpView];
}

//  ***** Added by Harshitha starts here  *****
- (void) getServiceTasksFromStorage
{
    ServiceOrderClass * serviceOrderClass = [ServiceOrderClass new];
    self.serviceTaskArray =  [serviceOrderClass GetAllServiceOrder];
}

- (void) initialiseVariables
{
    appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    self.serviceTaskArray    = [[NSMutableArray alloc]init];
    self.todayServiceTasksLocationArray = [[NSMutableArray alloc]init];
    
    [self getServiceTasksFromStorage];
    
    if (self.serviceTaskArray.count > 0)
    {
//    ServiceTask *serviceTask;
    serviceTask = [self.serviceTaskArray objectAtIndex:0];
    
    self.totalNumOfTasksLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.serviceTaskArray.count];
    self.nextServiceOrgName.text = serviceTask.serviceLocation;
    self.nextServiceLocation1.text = serviceTask.locationAddress1;
    self.nextServiceLocation2.text = serviceTask.locationAddress2;
    self.nextServiceLocation3.text = serviceTask.locationAddress3;
    self.contactName.text = serviceTask.contactName;
    if (serviceTask.telNum.length > 0) {
        self.phoneIcon1.hidden = NO;
        self.contactNum1Button.hidden = NO;
        [self.contactNum1Button setTitle:serviceTask.telNum forState:UIControlStateNormal];
        self.contactNum1Button.tag = 1;
        [self.contactNum1Button addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.phoneIcon1.tag = 1;
        [self.phoneIcon1 addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (serviceTask.altTelNum.length > 0) {
        self.phoneIcon2.hidden = NO;
        self.contactNum2Button.hidden = NO;
        [self.contactNum2Button setTitle:serviceTask.altTelNum forState:UIControlStateNormal];
        self.contactNum2Button.tag = 2;
        [self.contactNum2Button addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }

    self.coords = [self addressLocationWithAdress:serviceTask.locationAddress];
        
    numOfTasksForToday = 0;
    GSPDateUtility *objCurrentDateTime = [GSPDateUtility sharedInstance];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDate = [formatter stringFromDate:[NSDate date]];
    todayDate = [objCurrentDateTime convertShortDateToStringFormat:todayDate];
    for (int i=0 ; i<self.serviceTaskArray.count ; i++)
    {
        ServiceTask *task = [self.serviceTaskArray objectAtIndex:i];
        if ([todayDate isEqualToString:task.startDate]) {
            numOfTasksForToday++;
            [self.todayServiceTasksLocationArray addObject:task.locationAddress];
        }
    }
    self.numOfTasksForTodayLabel.text = [NSString stringWithFormat:@"%d", numOfTasksForToday];
    }
}

- (void)setUpView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setCustomRightBarButtonItem:@selector(infoBarButtonClicked) withImageNamed:@"info_btn.png"];

    self.mapWebView.layer.cornerRadius = 7.0;
    self.mapWebView.layer.borderWidth  = 2.0;
    self.mapWebView.layer.borderColor  = [[UIColor darkGrayColor]CGColor];
    
    [self.segmentedControl addTarget:self
                              action:@selector(segmentControllerSelectionChanged:)
                    forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self segmentControllerSelectionChanged:nil];
}


-(void) segmentControllerSelectionChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:
            [self showGoogleMap];
            break;
            
        case 1:
            [self showItinerary];
            break;
            
        default:
            break;
    }
    
}


- (void) showGoogleMap
{
    [[NSUserDefaults standardUserDefaults] setInteger:GoogleMapSelected forKey:DEFAULT_SELECTED_MAP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.mapWebView setHidden:NO];
    if (self.serviceTaskArray.count > 0)
        [self showMapOnWebview];
}

-(void)showMapOnWebview
{
    NSString *fullUrl = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&view=map&output=embed",self.currentLocation.latitude,self.currentLocation.longitude,self.coords.latitude,self.coords.longitude];
    
    NSURL *url = [NSURL URLWithString:[fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *embedHTML = [NSString stringWithFormat:@"<html><head><title>.</title><style>body,html,iframe{margin:0;padding:0;}</style></head><body><iframe width=\"%f\" height=\"%f\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe></body></html>" ,self.mapWebView.frame.size.width, self.mapWebView.frame.size.height, url];
    
    [self.mapWebView loadHTMLString:embedHTML baseURL:url];
    
}

- (void) showItinerary
{
    [[NSUserDefaults standardUserDefaults] setInteger:GoogleMapSelected forKey:DEFAULT_SELECTED_MAP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.mapWebView setHidden:NO];
//    if (self.todayServiceTasksLocationArray.count > 0)
        [self showItineraryOnWebview];
}

-(void)showItineraryOnWebview
{
    NSString *fullUrl = [NSString stringWithFormat:@"https://www.google.co.in/maps/dir/505 Thornall St, Edison, NJ 08837, USA"];

    for (int i = 0;  i < self.todayServiceTasksLocationArray.count; i++ )
    {
        fullUrl = [NSString stringWithFormat:@"%@/%@",fullUrl,self.todayServiceTasksLocationArray[i]];
    }
    fullUrl = [NSString stringWithFormat:@"%@/US&view=map&output=embed",fullUrl];
    
//    NSString *fullUrl = [NSString stringWithFormat:@"https://maps.google.com/maps/dir/Mysore/Chennai/Bengaluru/Coimbatore/Mangalore/Hassan&view=map&output=embed"];
    
    NSURL *url = [NSURL URLWithString:[fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *embedHTML = [NSString stringWithFormat:@"<html><head><title>.</title><style>body,html,iframe{margin:0;padding:0;}</style></head><body><iframe width=\"%f\" height=\"%f\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe></body></html>" ,self.mapWebView.frame.size.width, self.mapWebView.frame.size.height, url];
    
    [self.mapWebView loadHTMLString:embedHTML baseURL:url];
    
}

-(void)getUserCurrentLocation
{
//DISABLED  FOR TESTING PURPOSE
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager.delegate        = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter  = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    
    CLLocation *location    = [locationManager location];
    self.currentLocation        = [location coordinate];
    
    NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",_currentLocation.latitude,_currentLocation.longitude];
    NSLog(@"%@",str);
    
//END
    
//    Hardcoded by Harshitha for demo purpose
//    _currentLocation.latitude = 40.56509;
//    _currentLocation.longitude = -74.33130;
    
}

-(CLLocationCoordinate2D) addressLocationWithAdress: (NSString*) addressString {
    
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    if (result) {
        
        NSScanner *scanner = [NSScanner scannerWithString:result];
        
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            
            [scanner scanDouble:&latitude];
            
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                
                [scanner scanDouble:&longitude];
            }
        }
    }
    
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"Latitude : %f",center.latitude);
    NSLog(@"Longitude : %f",center.longitude);
    return center;
    
}

- (void) callButtonClicked:(id)sender
{
    UIButton * callbutton = (UIButton*) sender;
    
    //    NSString * contactNumber;
    
    switch (callbutton.tag) {
        case 1:
            self.contactNumber = serviceTask.telNum;
            break;
            // Original code
            //        case AltrTeleNumRow:
            // Modified by Harshitha
        case 2:
            self.contactNumber = serviceTask.altTelNum;
            break;
            
        default:
            break;
    }
    
    UIActionSheet* callActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Facetime",@"Phone call",nil];
    callActionSheet.tag = 1;
    [callActionSheet showInView:self.view];
}

- (void) callActionSheetActionWithIndex:(NSInteger) buttonIndex
{
    NSString *cleanedString = [[self.contactNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL    *facetimeURL = [NSURL URLWithString:[NSString stringWithFormat:@"facetime://%@", escapedPhoneNumber]];
    NSURL    *phoneNumbURL = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:escapedPhoneNumber]];
    
    switch (buttonIndex)
    {
        case 0:
            // Facetime is available or not
            if ([[UIApplication sharedApplication] canOpenURL:facetimeURL])
            {
                [[UIApplication sharedApplication] openURL:facetimeURL];
            }
            else
            {
                [[GSPUtility sharedInstance] showAlertWithTitle:@"Ooops!" message:@"Facetime not available." otherButton:nil tag:0 andDelegate:self];
            }
            break;
        case 1:
            if ([[UIApplication sharedApplication] canOpenURL:phoneNumbURL])
            {
                [[UIApplication sharedApplication] openURL:phoneNumbURL];
            }
            else
            {
                [[GSPUtility sharedInstance] showAlertWithTitle:@"Ooops!" message:@"Cannot make a phone call." otherButton:nil tag:0 andDelegate:self];
            }
            break;
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        [self callActionSheetActionWithIndex:buttonIndex];
    }
    
}
//  ***** Added by Harshitha ends here  *****

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createDataBases
{
    GssMobileConsoleiOS *objCRMMobileAppManager = [[GssMobileConsoleiOS alloc] init];
    [objCRMMobileAppManager createEmptyDatabase];
    
    //Set delegate flag
    // objCRMMobileAppManager.CRMdelegate = self;
    
}

- (void) infoBarButtonClicked
{
    GSPInfoScreenViewController * infoScreenVC;
    
    if (IS_IPAD) {
        infoScreenVC = [[GSPInfoScreenViewController alloc]initWithNibName:@"GSPInfoScreenViewController_iPad" bundle:nil];
    }
//  Added by Harshitha
    else {
        infoScreenVC = [[GSPInfoScreenViewController alloc]initWithNibName:@"GSPInfoScreenViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:infoScreenVC animated:YES];
}

- (IBAction)totalServiceTasksButtonClick:(id)sender
{
    appDelegateObj.activeApp = @"ServiceOrders";
    appDelegateObj.isTaskForTodayScreen = FALSE;
    [self loadServiceTaskOverviewScreen];
}

- (void) loadServiceTaskOverviewScreen
{
// Added by Harshitha.....On opening ServicePro app,to prioritize the execution of queued items from ServicePro app on QueueProcessor
    BOOL rtnResult;
    GssMobileConsoleiOS *objServiceMngtCls = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase = @"db_queueprocessor";
    objServiceMngtCls.qryString = [NSString stringWithFormat:@"UPDATE QP0610114_2456 SET periority = 1 WHERE subapplication = %@",@"Service Orders"];
    
    NSLog(@"Update query %@", objServiceMngtCls.qryString);
    
    rtnResult = [objServiceMngtCls excuteSqliteQryString];

    
    GSPServiceTasksViewController *serviceTasksVC ;
    NSString *selectedColleagueName;
//    NSString *colleague_uName;
    Colleagues *selectedColleague;
    ServiceTask *transferTask;
    
    if (IS_IPAD)
    {
//        serviceTasksVC  = [[GSPServiceTasksViewController alloc]initWithNibName:@"GSPServiceTasksViewController_iPad" bundle:nil forView:serviceTaskOverView withTitle:selectedColleagueName anduName:colleague_uName];
        serviceTasksVC  = [[GSPServiceTasksViewController alloc]initWithNibName:@"GSPServiceTasksViewController_iPad" bundle:nil forView:serviceTaskOverView withTitle:selectedColleagueName andSelectedColleague:selectedColleague transferTask:transferTask];
    }
/*    else
    {
        serviceTasksVC  = [[GSPServiceTasksViewController alloc]initWithNibName:@"GSPServiceTasksViewController" bundle:nil forView:serviceTaskOverView withTitle:selectedColleagueName anduName:colleague_uName];
    }
*/
    [self.navigationController pushViewController:serviceTasksVC animated:YES];
    
}

- (IBAction)taskForTheDayButtonClicked:(id)sender
{
    appDelegateObj.activeApp = @"ServiceOrders";
    appDelegateObj.isTaskForTodayScreen = TRUE;
    [self loadServiceTaskOverviewScreen];
}

- (IBAction)vanStockButtonClicked:(id)sender {
    [self notAvailableForDemoAlert];
}

- (IBAction)utilizationButtonClicked:(id)sender {
    [self notAvailableForDemoAlert];
}

- (IBAction)contactsButtonClicked:(id)sender {
    [self notAvailableForDemoAlert];
}

- (IBAction)billableButtonClicked:(id)sender {
    [self notAvailableForDemoAlert];
}

- (IBAction)activitiesButtonClicked:(id)sender {
    [self notAvailableForDemoAlert];
}

- (void)notAvailableForDemoAlert
{
    [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Functionality not available for demo version" otherButton:nil tag:0 andDelegate:self];
}

@end
