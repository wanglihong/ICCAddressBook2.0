//
//  NearbyViewCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListViewCtrl.h"

#import "BaseViewCtrl.h"

#import "LLWaterFlowView.h"

#import "XJWaiter.h"

#import "SDWebImageManager.h"
#import "UIButton+WebCache.h"

#import <QuartzCore/QuartzCore.h>

@interface NearbyViewCtrl : BaseViewCtrl <LLWaterFlowViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, SDWebImageManagerDelegate, UISearchBarDelegate>
{
    UIButton *leftBtn, *rightBtn;
}

@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) LLWaterFlowView *flowView;

@end
