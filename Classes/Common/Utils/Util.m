//
//  Util.m
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import "Util.h"
#import "Util+UIView.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import "SVProgressHUD.h"
#import "UIImageView+NewsPicks.h"
#import "FileHelper.h"
#import "defined.h"
#import "APIHelper.h"


#define kFullDateTimeFormat             @"yyyy/MM/dd HH:mm"
#define kShortDateTimeFormat            @"MM/dd HH:mm"
#define kDateFormat                     @"yyyy/MM/dd"
#define kShortDateFormat                @"MM/dd"
#define kTimeFormat                     @"HH:mm"

static NSArray *g_PropertyStructures = nil;
static NSArray *g_PropertyZoning = nil;
static NSArray *g_PropertyBalconeDirections = nil;
static NSArray *g_Genders = nil;

@implementation Util


+ (void)showLoading {
    [SVProgressHUD setBackgroundColor:UIColorFromRGB(0xEDEDED)];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}


+ (void)hideLoading {
    [SVProgressHUD dismiss];
}


+ (BOOL)isNullObject:(id)nullableObject {
    return (!nullableObject || [nullableObject isKindOfClass:[NSNull class]]);
}


+ (BOOL)isGoodString:(NSString *)string {
    return (string != nil && ![string isEqualToString:@""]);
}

+ (BOOL)isGoodArray:(NSArray *)array {
    return (array != nil && array.count > 0);
}


+ (BOOL)isGoodCoordinate:(CLLocationCoordinate2D)coordinate {
    return (coordinate.latitude != 0 && coordinate.longitude != 0);
}

///---------------------------
/// @section JSON_helper
///---------------------------

/**
  * Get string data
  */
- (NSString *)getStringWithKey:(NSString *)key fromJSON:(NSDictionary *)kvDict
{
    return kvDict[key];
}

/**
  * Get number data
  */
- (NSNumber *)getNumberWithKey:(NSString *)key fromJSON:(NSDictionary *)kvDict
{
    NSString *tmp = kvDict[key];
    if (tmp) {
        return @([tmp intValue]);
    }
    
    return nil;
}


+ (BOOL)isNumeric:(NSString*)inputString {
    if (inputString == nil || inputString.length == 0) return FALSE;
    
    BOOL isValid = NO;
    
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    
    return isValid;
}


+ (NSDate*)dateFromString:(NSString*)aDateString format:(NSString*)format {
    if (!aDateString) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:aDateString];
}


+ (NSString*)formatDateString:(NSString*)aDateString format:(NSString*)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    
    NSDate *date = [dateFormatter dateFromString:aDateString];
    if (date) {
        dateFormatter.dateFormat = format;
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        return formattedDateString;
    }
    
    return aDateString;
}


+ (NSString*)dateToString:(NSDate*)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    
    /*
    if ([SystemInfo sharedInstance].currentLanguage == 1 || [SystemInfo sharedInstance].currentLanguage == 3) {
        return [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)[components year], (long)[components month], (long)[components day]];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //dateFormatter.dateFormat = @"EEE MMM dd, yyyy HH:mm:ss";
        dateFormatter.dateFormat = @"MMM dd, yyyy";
        NSLocale *en_US = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:en_US];
        return [dateFormatter stringFromDate:date];
    }
    */
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"EEE MMM dd, yyyy HH:mm:ss";
    //dateFormatter.dateFormat = @"EEE dd/MM HH:mm";
     dateFormatter.dateFormat = @"yyyy/MM/dd";
    NSLocale *en_US = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:en_US];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)dateToStringWithFormat:(NSDate*)date format:(NSString*)format {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSLocale *en_US = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:en_US];
    return [dateFormatter stringFromDate:date];
}


+ (NSString*)getFullString:(NSString*)baseString option:(NSString*)optionString {
    return [Util getFullStringCompressed:baseString option:[NSString stringWithFormat:@" %@", optionString]];
}

+ (NSString*)getFullStringCompressed:(NSString*)baseString option:(NSString*)optionString {
    if (!baseString
        || [baseString isEqualToString:@"-"]
        || [baseString isEqualToString:@""]
        || [baseString isEqualToString:@"0"]
        || [baseString containsString:@"null"] ) {
        return @"-";
    } else {
        return [NSString stringWithFormat:@"%@%@", baseString, optionString];
    }
    
    return @"-";
}


+(void) promptAlert:(NSString*) alertTitle with: (NSString *) alertMessage{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    [alert show];
    
}


+(void) promptAlert:(NSString*) alertTitle with: (NSString *) alertMessage cancel: (NSString *) cancelText ok:(NSString*) okText{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:cancelText
                                          otherButtonTitles:okText, nil];
    [alert show];
}



+ (void)dismissDescriptionViewFromWindow:(UIWindow*)window {
    
    __weak UIView *descriptionView = [window viewWithTag:kTagDescriptionView];
    if (descriptionView != nil) {
        [UIView animateWithDuration:0.5f animations:^{
            descriptionView.frame = CGRectMake(0, window.sizeHeight, window.sizeWidth, 0);
        } completion:^(BOOL finished) {
            [descriptionView removeFromSuperview];
        }];
    }
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (DeviceModel)getDeviceModel {
    DeviceModel deviceModel = DeviceModel_Unknown;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if      (screenRect.size.width == 320 && screenRect.size.height == 480) deviceModel = DeviceModel_4_4S;
    else if (screenRect.size.width == 320 && screenRect.size.height == 568) deviceModel = DeviceModel_5_5S;
    else if (screenRect.size.width == 375 && screenRect.size.height == 667) deviceModel = DeviceModel_6;
    else if (screenRect.size.width == 414 && screenRect.size.height == 736) deviceModel = DeviceModel_6Plus;
    else                                                                    deviceModel = DeviceModel_iPad;
    
    /*
     char *typeSpecifier = "hw.machine";
     
     size_t size;
     sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
     
     char *answer = malloc(size);
     sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
     
     NSString *deviceModelName = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
     free(answer);
     
     if      ([deviceModelName hasPrefix:@"iPhone3"] || [deviceModelName hasPrefix:@"iPhone4"]) deviceModel = DeviceModel_4_4S;
     else if ([deviceModelName hasPrefix:@"iPhone6"] || [deviceModelName hasPrefix:@"iPhone5"])              deviceModel = DeviceModel_5_5S;
     else if ([deviceModelName isEqualToString:@"iPhone7,2"] || [deviceModelName hasPrefix:@"iPhone8,1"])    deviceModel = DeviceModel_6;
     else if ([deviceModelName isEqualToString:@"iPhone7,1"] || [deviceModelName hasPrefix:@"iPhone8,2"])    deviceModel = DeviceModel_6Plus;
     else if ([deviceModelName hasPrefix:@"iPad"])               deviceModel = DeviceModel_iPad;
     */
    
    return deviceModel;
}



+ (UILabel*)createLabel:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment parentView:(UIView*)parentView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:cgRect];
    titleLabel.text = text;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = textAlignment;
    [parentView addSubview:titleLabel];
    titleLabel.adjustsFontSizeToFitWidth = TRUE;
    return titleLabel;
}


+ (UILabel*)createLabel:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
                    fontSize:(float)fontSize textColor:(UIColor*)textColor parentView:(UIView*)parentView {
    UILabel *label = [Util createLabel:cgRect text:text textAlignment:textAlignment parentView:parentView];
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}



+ (UILabel*)createLabel:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
                   font:(UIFont*)font textColor:(UIColor*)textColor parentView:(UIView*)parentView {
    UILabel *label = [Util createLabel:cgRect text:text textAlignment:textAlignment parentView:parentView];
    label.textColor = textColor;
    label.font = font;
    return label;
}


+ (UILabel*)createLabelWithDynamicWidth:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
               fontSize:(float)fontSize textColor:(UIColor*)textColor parentView:(UIView*)parentView {
    UILabel *label = [Util createLabel:cgRect text:text textAlignment:textAlignment fontSize:fontSize textColor:textColor parentView:parentView];
    label.adjustsFontSizeToFitWidth = FALSE;
    
    float textWidth = [Util getTextWidth:text fontSize:fontSize constrainedHeight:cgRect.size.height];
    [Util setViewWidth:label width:textWidth];
    return label;
}


+ (UILabel*)createLabelWithDynamicWidth:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
                               font:(UIFont*)font textColor:(UIColor*)textColor parentView:(UIView*)parentView {
    UILabel *label = [Util createLabel:cgRect text:text textAlignment:textAlignment fontSize:font.pointSize textColor:textColor parentView:parentView];
    label.font = font;
    label.adjustsFontSizeToFitWidth = FALSE;
    
    float textWidth = [Util getTextWidth:text font:font constrainedHeight:cgRect.size.height];
    [Util setViewWidth:label width:textWidth];
    return label;
}


+ (UILabel*)createLabelWithDynamicFontSize:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
                               fontSize:(float)fontSize textColor:(UIColor*)textColor parentView:(UIView*)parentView {
    UILabel *label = [Util createLabel:cgRect text:text textAlignment:textAlignment fontSize:fontSize textColor:textColor parentView:parentView];
    label.adjustsFontSizeToFitWidth = TRUE;
    return label;
}



+ (UIButton*)createButton:(CGRect)frame title:(NSString*)title parentView:(UIView*)parentView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:frame];
    button.layer.cornerRadius = 5;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    button.backgroundColor = DefaultButtonColor;
    [parentView addSubview:button];
    return button;
}


+ (UIView*)createTimelineNoteItemView:(CGRect)frame title:(NSString*)title parentView:(UIView*)parentView
                            itemIndex:(int)itemIndex {
    UIView *itemView = [[UIView alloc] initWithFrame:frame];
    itemView.tag = itemIndex;
    itemView.layer.cornerRadius = 5;
    itemView.layer.masksToBounds = YES;
    itemView.backgroundColor = UIColorFromRGBValues(88, 185, 88);
    itemView.userInteractionEnabled = TRUE;
    [parentView addSubview:itemView];
    
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ViewWidth(itemView) - 20, ViewHeight(itemView))];
    itemLabel.text = title;
    itemLabel.textColor = [UIColor whiteColor];
    itemLabel.textAlignment = NSTextAlignmentLeft;
    itemLabel.font = [UIFont systemFontOfSize:14.5];
    [itemView addSubview:itemLabel];
    
    return itemView;
}


+ (UIButton*)createImageButton:(CGRect)frame imageFileName:(NSString*)imageFileName parentView:(UIView*)parentView {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
    if (parentView != nil) [parentView addSubview:button];
    return button;
}



+ (UIImageView*)createImageView:(CGRect)frame imageFileName:(NSString*)imageFileName parentView:(UIView*)parentView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageFileName];
    if (parentView != nil) [parentView addSubview:imageView];
    return imageView;
}


+ (UILabel*)createPickerInputField:(CGRect)frame textHolder:(NSString*)textHolder parentView:(UIView*)parentView {
    CGRect labelFrame = frame;
    labelFrame.origin.x += 3;
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = textHolder;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.userInteractionEnabled = YES;
    [parentView addSubview:label];
    
    //UIView *line = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height - 2, frame.size.width, 1)];
    //line.backgroundColor = [UIColor whiteColor];
    //[parentView addSubview:line];
    return label;
}

+ (UILabel*)createBirthdayInputField:(CGRect)frame textHolder:(NSString*)textHolder parentView:(UIView*)parentView {
    CGRect labelFrame = frame;
    labelFrame.origin.x += 3;
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = textHolder;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.userInteractionEnabled = YES;
    [parentView addSubview:label];
    
    /*
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height - 2, frame.size.width, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [parentView addSubview:line];
    */
    return label;
}


+ (UILabel*)createPickerInputFieldWithTitleAndValue:(CGRect)frame title:(NSString*)title value:(NSString*)value parentView:(UIView*)parentView {
    CGRect titleFrame = frame;
    titleFrame.size.width = titleFrame.size.width / 2;
    [Util createLabel:titleFrame text:title textAlignment:NSTextAlignmentLeft fontSize:16 textColor:[UIColor whiteColor] parentView:parentView];
    
    
    CGRect valueLabelFrame = frame;
    valueLabelFrame.origin.x += frame.size.width / 2;
    valueLabelFrame.size.width = frame.size.width / 2;
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:valueLabelFrame];
    valueLabel.text = value;
    valueLabel.font = [UIFont systemFontOfSize:16];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.userInteractionEnabled = YES;
    [parentView addSubview:valueLabel];
    return valueLabel;
}


+ (CATransition*)settingTransitionAnimation:(NSString*)subtype {
    CATransition *transition = [CATransition animation];
    transition.duration = kFadeInTransitionTime;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = subtype;
    return transition;
}


+ (UIView*)createView:(CGRect)frame backgroundColor:(UIColor*)backgroundColor parentView:(UIView*)parentView {
    UIView *uiVIew = [[UIView alloc] initWithFrame:frame];
    uiVIew.backgroundColor = backgroundColor;
    [parentView addSubview:uiVIew];
    return uiVIew;
}

+ (UIView*)createView:(CGRect)frame backgroundColor:(UIColor*)backgroundColor borderColor:(UIColor*)borderColor parentView:(UIView*)parentView {
    UIView *uiVIew = [[UIView alloc] initWithFrame:frame];
    if (backgroundColor != nil) uiVIew.backgroundColor = backgroundColor;
    if (borderColor != nil) {
        uiVIew.layer.borderWidth = 1;
        uiVIew.layer.borderColor = [borderColor CGColor];
    }

    if (parentView != nil) [parentView addSubview:uiVIew];
    return uiVIew;
}

+ (float)getTextWidth:(NSString*)text fontSize:(float)fontSize constrainedHeight:(float)textHeight {
    if (text == nil) return 0;
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    return [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, textHeight} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
    //return [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(0, textHeight)].width;
}


+ (float)getTextWidth:(NSString*)text font:(UIFont*)font constrainedHeight:(float)textHeight {
    if (text == nil) return 0;
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    return [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, textHeight} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
    //return [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(0, textHeight)].width;
}


+ (float)getTextHeight:(NSString*)text fontSize:(float)fontSize constrainedWidth:(float)textWidth {
    if (text == nil) return 0;
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    return [attributedText boundingRectWithSize:(CGSize){textWidth, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    //return [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(textWidth, 0)].height;
}


+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}


+ (void)showAlert:(NSString*)alertTitle alertMessage:(NSString *)alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


+ (BOOL)validateEmail:(NSString*)emailAddress {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAddress];
}


+ (NSString*)md5Hash:(NSString*)inputStr {
    const char *cStr = [inputStr UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}


+ (void)processError:(NSError*)error {
    [Util hideLoading];
    [Util showAlert:LocStr(@"An error occurred while loading info. Please try again.") alertMessage:nil];
    DLog(@"Error: %@ %@", error, [error userInfo]);
}


+ (void)processError:(NSError*)error alertMsg:(NSString*)alertMsg {
    [Util hideLoading];
    [Util showAlert:alertMsg alertMessage:nil];
    DLog(@"Error: %@ %@", error, [error userInfo]);
}


+ (NSData*)compressFile:(UIImage *)largeImg {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 100000;
    
    NSData *largeImgData = UIImageJPEGRepresentation(largeImg, 1.0);
    
    while ([largeImgData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        largeImgData = UIImageJPEGRepresentation(largeImg, compression);
    }
    
    return largeImgData;
}


+ (void)setViewXPos:(UIView*)view xPos:(float)xPos {
    CGRect viewFrame = view.frame;
    viewFrame.origin.x = xPos;
    view.frame = viewFrame;
}


+ (void)setViewYPos:(UIView*)view yPos:(float)yPos {
    CGRect viewFrame = view.frame;
    viewFrame.origin.y = yPos;
    view.frame = viewFrame;
}


+ (void)setViewHeight:(UIView*)view height:(float)height {
    CGRect viewFrame = view.frame;
    viewFrame.size.height = height;
    view.frame = viewFrame;
}


+ (void)setViewWidth:(UIView*)view width:(float)width {
    CGRect viewFrame = view.frame;
    viewFrame.size.width = width;
    view.frame = viewFrame;
}



+ (void)loadImageWithImageURL:(NSString*)imageURL noImageFile:(NSString*)noImageFile completed:(void (^)(UIImage *image))completed {
    if ([Util isGoodString:imageURL]) {
        /*
        if ([[FileHelper sharedInstance] hasImageFileWithURL:imageURL]) {
            [[FileHelper sharedInstance] loadLocalImageFromImageURL:imageURL completed:^(UIImage *image) {
                if (image != nil) {
                    if (completed) completed(image);
                }
            }];
        } else {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
            NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
            
            if(cachedResponse) {
                if (completed) completed([UIImage imageWithData:cachedResponse.data]);
            } else {
                [[APIHelper sharedAPIHelper] downloadImage:imageURL completed:^(UIImage *image, ServiceError *error) {
                    if (!error) {
                        [[FileHelper sharedInstance] saveImageFile:image withImageURL:imageURL];
                        if (completed) completed(image);
                    } else {
                        DLog(@"loadImageWithURL error = %@", error);
                    }
                }];
            }
        }
         */
        
        [[APIHelper sharedAPIHelper] downloadImage:imageURL completed:^(UIImage *image, ServiceError *error) {
            if (!error) {
                [[FileHelper sharedInstance] saveImageFile:image withImageURL:imageURL];
                if (completed) completed(image);
            } else {
                DLog(@"loadImageWithURL error = %@", error);
            }
        }];
    } else {
        if (completed) completed([UIImage imageNamed:noImageFile]);
    }
}


+ (NSMutableArray*)getSelectionList:(NSString*)selectionStr {
    NSMutableArray *selectionList = [[selectionStr componentsSeparatedByString:@","] mutableCopy];
    
    for(int i = 0; i < selectionList.count; i++) {
        selectionList[i] = LocStr(selectionList[i]);
    }
    
    return selectionList;
}


+ (NSString*)processStringData:(NSString*)str {
    if (![Util isNullObject:str]) {
        str = Object2StringWithFormat(str);
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    return str;
}


+ (UIImage *)roundedImage:(UIImage *)image withRadious:(CGFloat)radious {
    if (image == nil) return nil;

    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGRect rect = CGRectMake(0, 0, imageWidth, imageHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, radious, radious);
    
    CGFloat rectWidth = CGRectGetWidth (rect)/radious;
    CGFloat rectHeight = CGRectGetHeight (rect)/radious;
    
    CGContextMoveToPoint(context, rectWidth, rectHeight/2.0f);
    CGContextAddArcToPoint(context, rectWidth, rectHeight, rectWidth/2, rectHeight, radious);
    CGContextAddArcToPoint(context, 0, rectHeight, 0, rectHeight/2, radious);
    CGContextAddArcToPoint(context, 0, 0, rectWidth/2, 0, radious);
    CGContextAddArcToPoint(context, rectWidth, 0, rectWidth, rectHeight/2, radious);
    CGContextRestoreGState(context);
    CGContextClosePath(context);
    CGContextClip(context);
    
    [image drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (UIImage*)editUserMarkerImage:(UIImage*)image {
    image = ResizeImage(image, 40, 40, 2);
    image = [Util roundedImage:image withRadious:4.4];
    return image;
}


+ (UITextField*)createInputField:(CGRect)frame placeholderText:(NSString*)placeholderText parentView:(UIView*)parentView {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = DefaultTitleTextColor;
    textField.placeholder = placeholderText;
    textField.textAlignment = NSTextAlignmentLeft;
    /*
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder
                                        attributes:@{   NSFontAttributeName             :   [UIFont systemFontOfSize:14],
                                                        NSForegroundColorAttributeName  :   [UIColor whiteColor]
                                                    }];
     */
    textField.font = [UIFont systemFontOfSize:14];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.returnKeyType = UIReturnKeyDone;
    [parentView addSubview:textField];
    return textField;
}



+ (double)DegreeBearing:(CLLocation*)A locationB:(CLLocation*)B {
    double dlon = [Util toRad:(B.coordinate.longitude - A.coordinate.longitude)];
    double dPhi = log(tan([Util toRad:B.coordinate.latitude] / 2 + M_PI / 4) / tan([Util toRad:A.coordinate.latitude] / 2 + M_PI / 4));
    if  (abs(dlon) > M_PI){
        dlon = (dlon > 0) ? (dlon - 2*M_PI) : (2*M_PI + dlon);
    }
    
    return [Util toBearing:atan2(dlon, dPhi)];
}


+ (double)toRad:(double)degrees {
    return degrees * (M_PI/180);
}


+ (double)toBearing:(double)radians {
    return 0;//([Util toDegrees:radians] + 360) % 360;
}


+ (double)toDegrees:(double)radians {
    return radians * 180 / M_PI;
}


+ (NSDictionary*)dictionaryFromPushNotificaionInfo:(NSString*)pushNotificationInfo {
    //Ex: push_info = "push_type:0;booking_id:123asada;from_user_id:unfIUtXrA4;sent_time:1452066269.283636";
    
    NSMutableDictionary *pushNotificationDic = [NSMutableDictionary dictionary];
    
    NSArray *array = [pushNotificationInfo componentsSeparatedByString:@";"];
    NSArray *item;
    
    for (int i = 0; i < array.count; i++) {
        item = [array[i] componentsSeparatedByString:@":"];
        [pushNotificationDic setObject:item[1] forKey:item[0]];
    }
    
    return [NSDictionary dictionaryWithDictionary:pushNotificationDic];
}


+ (NSString*)formatDecimalNumber:(NSString*)aNumberString {
    if (![Util isGoodString:aNumberString]) return aNumberString;
    
    aNumberString = [aNumberString stringByReplacingOccurrencesOfString:@"," withString:@""];
    aNumberString = [aNumberString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *formatedDecimalNumberStr = [formatter stringFromNumber:[NSNumber numberWithInt:[aNumberString intValue]]];
    
    //TODO: Change decimal format by country
    if (TRUE) {
        
        formatedDecimalNumberStr = [formatedDecimalNumberStr stringByReplacingOccurrencesOfString:@"," withString:@"."];
    }
    return formatedDecimalNumberStr;
}


+ (NSString*)formatCurrency:(float)currencyValue {
    NSString *currencyStr;
    
    //TODO: Change currency format by country
    if (TRUE) {
        currencyStr = Float2StringWithFormat(currencyValue, @"%.00f");
        currencyStr = [NSString stringWithFormat:@"%@%@", [Util formatDecimalNumber:currencyStr], [Util getCurrencyUnitStr]];
    } else {
        currencyStr = Float2String(currencyValue);
    }
    
    return currencyStr;
}


+ (NSString*)getCurrencyUnitStr {
    NSString *currencyUnitStr;
    
    //TODO: Check currency by country
    if (TRUE) {
        currencyUnitStr = @"đ";
    }
    
    return currencyUnitStr;
}


+ (NSString*)formatDuration:(NSString*)duration {
    duration = [duration stringByReplacingOccurrencesOfString:@"mins" withString:LocStr(@"mins")];
    duration = [duration stringByReplacingOccurrencesOfString:@"min" withString:LocStr(@"min")];
    return duration;
}

@end
