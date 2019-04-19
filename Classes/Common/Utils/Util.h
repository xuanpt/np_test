//
//  Util.h
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kTagDescriptionView 1005


typedef NS_ENUM(int, DeviceModel) {
    DeviceModel_Unknown = 0,
    DeviceModel_4_4S = 0,
    DeviceModel_5_5S,
    DeviceModel_6,
    DeviceModel_6Plus,
    DeviceModel_iPad
};


@interface Util : NSObject

///---------------------------
/// @section JSON_helper
///---------------------------

/**
 * Get string data
 */
- (NSString *)getStringWithKey:(NSString *)key fromJSON:(NSDictionary *)kvDict;

/**
  * Get number data
  */
- (NSNumber *)getNumberWithKey:(NSString *)key fromJSON:(NSDictionary *)kvDict;

+ (BOOL)isNullObject:(id)nullableObject;
+ (BOOL)isGoodString:(NSString *)string;
+ (BOOL)isGoodArray:(NSArray *)array;
+ (BOOL)isGoodCoordinate:(CLLocationCoordinate2D)coordinate;

+ (void)showLoading;
+ (void)hideLoading;


+ (BOOL)isNumeric:(NSString*)inputString;
+ (NSString*)formatDecimalNumber:(NSString*)aNumberString;

+ (NSDate*)dateFromString:(NSString*)aDateString format:(NSString*)format;
+ (NSString*)formatDateString:(NSString*)aDateString format:(NSString*)format;
+ (NSString*)dateToString:(NSDate*)date;
+ (NSString*)dateToStringWithFormat:(NSDate*)date format:(NSString*)format;
+ (NSString*)getFullStringCompressed:(NSString*)baseString option:(NSString*)optionString;
+ (NSString*)getFullString:(NSString*)baseString option:(NSString*)optionString;
+(void) promptAlert:(NSString*) alertTitle with: (NSString *) alertMessage;
+(void) promptAlert:(NSString*) alertTitle with: (NSString *) alertMessage cancel: (NSString *) cancelText ok:(NSString*) okText;

+ (void)dismissDescriptionViewFromWindow:(UIWindow*)window;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (DeviceModel)getDeviceModel;


+ (UILabel*)createLabel:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
                  parentView:(UIView*)parentView;

+ (UILabel*)createLabel:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
                    fontSize:(float)fontSize textColor:(UIColor*)textColor parentView:(UIView*)parentView;

+ (UILabel*)createLabel:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
                   font:(UIFont*)font textColor:(UIColor*)textColor parentView:(UIView*)parentView;


+ (UILabel*)createLabelWithDynamicWidth:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
                               fontSize:(float)fontSize textColor:(UIColor*)textColor parentView:(UIView*)parentView;

+ (UILabel*)createLabelWithDynamicWidth:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
                                   font:(UIFont*)font textColor:(UIColor*)textColor parentView:(UIView*)parentView;

+ (UILabel*)createLabelWithDynamicFontSize:(CGRect)cgRect text:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
                                  fontSize:(float)fontSize textColor:(UIColor*)textColor parentView:(UIView*)parentView;
    

+ (UIButton*)createButton:(CGRect)frame title:(NSString*)title parentView:(UIView*)parentView;

+ (UIButton*)createImageButton:(CGRect)frame imageFileName:(NSString*)imageFileName parentView:(UIView*)parentView;

+ (UIImageView*)createImageView:(CGRect)frame imageFileName:(NSString*)imageFileName parentView:(UIView*)parentView;

+ (UIView*)createTimelineNoteItemView:(CGRect)frame title:(NSString*)title parentView:(UIView*)parentView itemIndex:(int)itemIndex;

+ (UILabel*)createPickerInputField:(CGRect)frame textHolder:(NSString*)textHolder parentView:(UIView*)parentView;

+ (UILabel*)createPickerInputFieldWithTitleAndValue:(CGRect)frame title:(NSString*)title value:(NSString*)value parentView:(UIView*)parentView;

+ (UILabel*)createBirthdayInputField:(CGRect)frame textHolder:(NSString*)textHolder parentView:(UIView*)parentView;

+ (CATransition*)settingTransitionAnimation:(NSString*)subtype;


+ (UIView*)createView:(CGRect)frame backgroundColor:(UIColor*)backgroundColor borderColor:(UIColor*)borderColor parentView:(UIView*)parentView;


+ (float)getTextWidth:(NSString*)text fontSize:(float)fontSize constrainedHeight:(float)textHeight;

+ (float)getTextWidth:(NSString*)text font:(UIFont*)font constrainedHeight:(float)textHeight;

+ (float)getTextHeight:(NSString*)text fontSize:(float)fontSize constrainedWidth:(float)textWidth;

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc;

+ (void)showAlert:(NSString*)alertTitle alertMessage:(NSString *)alertMessage;

+ (BOOL)validateEmail:(NSString*)emailAddress;

+ (NSString*)md5Hash:(NSString *)inputStr;

+ (void)processError:(NSError*)error;

+ (void)processError:(NSError*)error alertMsg:(NSString*)alertMsg;

+ (NSData*)compressFile:(UIImage *)largeImg;

+ (void)setViewXPos:(UIView*)view xPos:(float)xPos;

+ (void)setViewYPos:(UIView*)view yPos:(float)yPos;

+ (void)setViewHeight:(UIView*)view height:(float)height;

+ (void)setViewWidth:(UIView*)view width:(float)width;

+ (NSMutableArray*)getSelectionList:(NSString*)selectionStr;

+ (NSString*)processStringData:(NSString*)str;

+ (void)loadImageWithImageURL:(NSString*)imageURL noImageFile:(NSString*)noImageFile completed:(void (^)(UIImage *image))completed;

+ (UIImage *)roundedImage:(UIImage *)image withRadious:(CGFloat)radious;

+ (UIImage*)editUserMarkerImage:(UIImage*)image;

+ (UITextField*)createInputField:(CGRect)frame placeholderText:(NSString*)placeholderText parentView:(UIView*)parentView;

+ (NSDictionary*)dictionaryFromPushNotificaionInfo:(NSString*)pushNotificationInfo;

+ (NSString*)formatCurrency:(float)currencyValue;

+ (NSString*)getCurrencyUnitStr;

+ (NSString*)formatDuration:(NSString*)duration;

@end
