//
//  NCBCampaignView.m
//  BestieBox
//
//  Created by NTT コミュニケーションズ on 12/9/15.
//  Copyright © 2015 NTTCom. All rights reserved.
//

#import "NCBCampaignView.h"
#import "UIButton+EventBlocks.h"
#import "TTTAttributedLabel.h"
#import "NCBWebViewController.h"
#import "NCBGroupViewController.h"

@interface NCBCampaignView () <TTTAttributedLabelDelegate>

@end


@implementation NCBCampaignView {
    BaseViewController  *parentViewController;
    CampaignViewMode    viewMode;
}


- (instancetype)initWithCampaignInfo:(NSString*)title content:(NSString*)content campaignViewMode:(CampaignViewMode)campaignViewMode
                            parentVC:(BaseViewController*)parentVC parentView:(UIView*)parentView {
    self = [super initWithFrame:parentView.bounds];
    if (self) {
        parentViewController = parentVC;
        viewMode = campaignViewMode;
        self.backgroundColor = UIColorFromRGBAValues(0, 0, 0, 0.35);
        [self settingView:title content:content];
    }
    return self;
}



- (void)settingView:(NSString*)title content:(NSString*)content {
    //content = @"Follow @krelborn or visit http://compiledcreations.com #shamelessplug Follow @krelborn or visit http://compiledcreations.com #shamelessplug";
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, ViewWidth(self) - 60, 230)];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.cornerRadius = 5;
    mainView.layer.masksToBounds = YES;
    mainView.center = self.center;
    [self addSubview:mainView];
    
    float yPos = 15;
    
    [NCBUtil createLabel:CGRectMake(0, yPos, ViewWidth(mainView), 20) text:title textAlignment:NSTextAlignmentCenter
                fontSize:18 textColor:[UIColor blackColor] parentView:mainView];
    
    yPos += 30;
        
    TTTAttributedLabel *msgLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, yPos, ViewWidth(mainView) - 20, 120)];
    msgLabel.numberOfLines = 0;
    msgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    msgLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    msgLabel.text = content;
    msgLabel.delegate = self;
    [mainView addSubview:msgLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, ViewHeight(mainView) - 61, ViewWidth(mainView), 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [mainView addSubview:lineView];
    
    if (viewMode == CampaignViewMode_OnlyDisplayContent) {
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeSystem];
        okButton.frame = CGRectMake(0, ViewHeight(mainView) - 60, ViewWidth(mainView), 60);
        [okButton setTitle:@"OK" forState:UIControlStateNormal];
        okButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        okButton.onTouchUpInside = ^(UIButton *button, UIEvent *event) {
            self.hidden = TRUE;
            [self removeFromSuperview];
        };
        
        [mainView addSubview:okButton];
    } else if (viewMode == CampaignViewMode_ApplyCampaign) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        closeButton.frame = CGRectMake(0, ViewHeight(mainView) - 60, ViewWidth(mainView) / 2, 60);
        [closeButton setTitle:LocStr(@"Close") forState:UIControlStateNormal];
        closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        closeButton.onTouchUpInside = ^(UIButton *button, UIEvent *event) {
            self.hidden = TRUE;
            [self removeFromSuperview];
        };
        [mainView addSubview:closeButton];
        
        
        UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        applyButton.frame = CGRectMake(ViewWidth(mainView) / 2, ViewHeight(mainView) - 60, ViewWidth(mainView) / 2, 60);
        [applyButton setTitle:LocStr(@"Apply") forState:UIControlStateNormal];
        applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        applyButton.onTouchUpInside = ^(UIButton *button, UIEvent *event) {
            [(NCBGroupViewController*)parentViewController applyCampaign:self.tag];
            self.hidden = TRUE;
            [self removeFromSuperview];
        };
        [mainView addSubview:applyButton];
        
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(ViewWidth(mainView) / 2, ViewHeight(mainView) - 61, 1, 60)];
        lineView.backgroundColor = [UIColor grayColor];
        [mainView addSubview:lineView];
    }
}


#pragma mark - TTTAttributedLabel delegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [self resignFirstResponder];
    
    self.hidden = TRUE;
    
    NCBWebViewController *webViewController = [[NCBWebViewController alloc] initWithURL:[url absoluteString] title:LocStr(@"Opening Campaign")];
    webViewController.parentCampaignView = self;
    [parentViewController presentViewController:webViewController animated:TRUE completion:nil];
}

@end
