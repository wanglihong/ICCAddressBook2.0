//
//  ListWithSearchCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListViewCtrl.h"

@interface ListWithSearchViewCtrl : ListViewCtrl
{
    UISearchBar *searchBar;
}

@property (nonatomic, retain) UISearchBar *searchBar;

@end
