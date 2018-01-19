//
//  PDFRenderer.m

#import "PDFRenderer.h"
#import "CoreText/CoreText.h"
#import "ServiceTask.h"
#import "GSPUtility.h"

@implementation PDFRenderer


+ (id)sharedInstance
{
    static PDFRenderer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)drawPDFFromTableForServicOrder:(NSString*)serviceOrder  WithTableViewView:(UITableView*)tableView withAttacments:(NSMutableArray*)attachments andSignature:(UIImage*)signatureImage
{
    // Create the PDF context
    
   NSString * fileName =  [self getPdfFileName:serviceOrder];
    
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);

    pdfTableHeight = 1000;

    pdfTableHeight              = tableView.frame.size.height + 200;
    
    CGFloat pdfHeight = pdfTableHeight;
    
    if (signatureImage)
    {
        pdfHeight       = pdfHeight + signatureImage.size.height + 5;
    }
    
    if (attachments.count > 0) {
        for (NSString *imagesFilePath in attachments)
        {
            //NSString    * folderPath       = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:serviceOrder forPathComponent:@"AttchedImages"];
            //UIImage     * image            = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",folderPath,imagesFilePath]];
           
            pdfHeight   = pdfHeight + 700 + 10 ;
            
        }

    }
    
    
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 20, 700, pdfHeight), nil);
    
    [self drawLabelsOfTable:tableView];
    [self drawAttacmentImagesInPdf:attachments andSignatureImage:signatureImage forServiceOrder:serviceOrder];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}


//Another Method Generating pdf of a view

- (void)drawPDFOfViewForServicOrder:(NSString *)serviceOrder WithView:(UIView *)sView withAttacments:(NSMutableArray *)attachments andSignature:(UIImage *)signatureImage
{
    
    NSString * fileName =  [self getPdfFileName:serviceOrder];
    if (! UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil)) {
        NSLog(@"error creating PDF context");
        return;
    }
    
    UIGraphicsBeginPDFPage();
    
    [sView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIGraphicsEndPDFContext();
}

- (NSString*)getPdfFileName:(NSString*)serviceOrder
{
    NSString* fileName = [NSString stringWithFormat:@"%@.PDF", serviceOrder];
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;
    
}

- (void)drawImage:(UIImage*)image inRect:(CGRect)rect
{

    [image drawInRect:rect];

}

- (void)drawLabelsOfTable:(UITableView*)tableView
{

    for (int section = 0; section < [tableView numberOfSections]; section++)
    {
        for (int row = 0; row < [tableView numberOfRowsInSection:section]; row++)
        {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];
            
            
            if (cell.frame.size.height != 0)
            {
                for (UIView * cellSubviews in [cell subviews])
                {
                    for (UIView *contentViewSubviews in [cellSubviews subviews])
                    {
                       
                        
                        if ([SYSTEM_VERSION floatValue] >= 8.0)
                        {
                            [self plotLabelsInPDFWithLabel:contentViewSubviews andCell:cell];
                        }
                        else
                        {
                            
                            for (id labelView  in [contentViewSubviews subviews])
                            {
                                [self plotLabelsInPDFWithLabel:labelView andCell:cell];
                            }
                        }
                        
                        

                    }
                    
                }
            }
        }
    }
    
    
}

- (void)plotLabelsInPDFWithLabel:(UIView*)labelView andCell:(UITableViewCell*)cell
{
    
    
    
    //UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    
    
    
    if([labelView isKindOfClass:[UILabel class]])
    {
        UILabel* label = (UILabel*)labelView;
        
        NSDictionary *attrsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:label.font, NSFontAttributeName,[NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
        
        CGRect newRect ;
        
        if (label.numberOfLines > 3)
        {
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+30 , label.frame.size.width, 60);
        }
        else if (label.tag == 501)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+30 , label.frame.size.width, 60);
        
        else if (label.tag == 502)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+60 , label.frame.size.width, 60);
        
        else if (label.tag == 503)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+90 , label.frame.size.width, 60);
        
        else if (label.tag == 504)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+120 , label.frame.size.width, 60);
        
        else if (label.tag == 505)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+150 , label.frame.size.width, 60);
        
        else if (label.tag == 506)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+180 , label.frame.size.width, 60);
        
        else if (label.tag == 507)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+210 , label.frame.size.width - 30, 60);
        
        else
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y , label.frame.size.width, 20);
        
        if (!label.hidden)
        {
            [label.text drawInRect:newRect withAttributes:attrsDictionary];
            
        }
        
    }
    else if ([labelView isKindOfClass:[UITextView class]])
    {
        UITextView* textView = (UITextView*)labelView;
        
        NSDictionary *attrsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:textView.font, NSFontAttributeName,[NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
        
        CGRect newRect = CGRectMake(textView.frame.origin.x, cell.frame.origin.y , textView.frame.size.width, 60);
        
        [textView.text drawInRect:newRect withAttributes:attrsDictionary];
    }
    
    else if ([labelView isKindOfClass:[UIButton class]])
    {
        UIButton* dropDownBtn = (UIButton*)labelView;
        CGRect newRect = CGRectMake(dropDownBtn.frame.origin.x, cell.frame.origin.y , dropDownBtn.frame.size.width, 40);
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        
        NSDictionary *attrsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,[NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
        
        NSString *statusString  = dropDownBtn.currentTitle;
        
        if (!dropDownBtn.hidden && statusString != nil)
        {
            [statusString drawInRect:newRect withAttributes:attrsDictionary];
        }
        
        
        
    }
    
}

- (void)drawAttacmentImagesInPdf:(NSMutableArray*)attachmentImages andSignatureImage:(UIImage*)signatureImage forServiceOrder:(NSString*)serviceOrder
{
    int i = 5;
    
    CGFloat yAxis = pdfTableHeight;
    
    if (signatureImage)
    {
        [self drawUnderlinedText:@"Attached Signature" withFont:[UIFont boldSystemFontOfSize:16.0] andColor:[UIColor blackColor] andLocationX:20 andLocationY:yAxis - 20 andTextAreaWidth:150 andTextAreaHeight:20];
        
        [self drawImage:signatureImage inRect:CGRectMake(0, yAxis + i, 720, signatureImage.size.height)];
        yAxis = yAxis + 60 + signatureImage.size.height;
    }
    
    if (attachmentImages.count > 0)
    {
        [self drawUnderlinedText:@"Other Attachements" withFont:[UIFont boldSystemFontOfSize:16.0] andColor:[UIColor blackColor] andLocationX:20 andLocationY:yAxis - 25 andTextAreaWidth:150 andTextAreaHeight:20];
    }
    
    for (NSString *imagesFilePath in attachmentImages)
    {

        NSString    * folderPath       = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:serviceOrder forPathComponent:@"AttchedImages"];
        UIImage     * image            = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",folderPath,imagesFilePath]];
        
        [self drawImage:image inRect:CGRectMake(0, yAxis + i, 720, 700)];
        i = 740;
    }

}

- (void)drawUnderlinedText:(NSString *)text withFont:(UIFont *)font andColor:(UIColor *)color andLocationX:(int)locationX andLocationY:(int)locationY andTextAreaWidth:(int)textWidth andTextAreaHeight:(int)textHeight{
    
    NSDictionary *attributesDict;
    NSMutableAttributedString *attString;
    
    // Commented out until iOS bug is resolved:
    //attributesDict = @{NSUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleSingle], NSForegroundColorAttributeName : color, NSFontAttributeName : font};
    attributesDict = @{NSForegroundColorAttributeName : color, NSFontAttributeName : font};
    attString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDict];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGRect rect = CGRectMake(locationX, locationY, textWidth, textHeight);
    
    // Temporary Solution to NSUnderlineStyleAttributeName - Bug:
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    CGSize tmpSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(200, 9999)];
    
    CGContextMoveToPoint(context, locationX, locationY + tmpSize.height - 1);
    CGContextAddLineToPoint(context, locationX + tmpSize.width, locationY + tmpSize.height - 1);
    
    CGContextStrokePath(context);
    // End Temporary Solution
    
    [attString drawInRect:rect];
}

@end
