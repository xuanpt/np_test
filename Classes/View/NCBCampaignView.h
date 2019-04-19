//
//  NCBCampaignView.h
//  BestieBox
//
//  Created by NTT コミュニケーションズ on 12/9/15.
//  Copyright © 2015 NTTCom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, CampaignViewMode) {
    CampaignViewMode_OnlyDisplayContent = 0,
    CampaignViewMode_ApplyCampaign
};


@interface NCBCampaignView : UIView

- (instancetype)initWithCampaignInfo:(NSString*)title content:(NSString*)content campaignViewMode:(CampaignViewMode)campaignViewMode
                            parentVC:(BaseViewController*)parentVC parentView:(UIView*)parentView;

@end
