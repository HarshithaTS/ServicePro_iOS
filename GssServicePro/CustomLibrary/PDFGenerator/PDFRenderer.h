//
//  PDFRenderer.h


#import <Foundation/Foundation.h>

@interface PDFRenderer : NSObject
{
    CGFloat pdfTableHeight;
}

+ (id)sharedInstance;

- (void)drawPDFFromTableForServicOrder:(NSString*)serviceOrder  WithTableViewView:(UITableView*)tableView withAttacments:(NSMutableArray*)attachments andSignature:(UIImage*)signatureImage;

//Method for generating PDF of any view
- (void)drawPDFOfViewForServicOrder:(NSString *)serviceOrder WithView:(UIView *)sView withAttacments:(NSMutableArray *)attachments andSignature:(UIImage *)signatureImage;

- (NSString*) getPdfFileName:(NSString*)serviceOrder;

- (void) drawImage:(UIImage*)image inRect:(CGRect)rect;


@end
