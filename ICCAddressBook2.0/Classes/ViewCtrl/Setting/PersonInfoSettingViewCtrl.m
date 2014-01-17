//
//  PersonInforViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonInfoSettingViewCtrl.h"

#import "Constants.h"

#import "Tooles.h"

#import "User.h"

#import "XJUploader.h"

@interface PersonInfoSettingViewCtrl ()

@end

@implementation PersonInfoSettingViewCtrl

@synthesize person = _person;
@synthesize groups = _groups;
@synthesize values = _values;
@synthesize photos = _photos;
@synthesize pickedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [_person release], _person = nil;
    [_groups release], _groups = nil;
    [_values release], _values = nil;
    [_photos release], _photos = nil;
    [pickedImage release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"个人信息";
    
    self.groups= [NSArray arrayWithObjects:
                  [Constants _person_information_titles],
                  [Constants _contact_information_titles], 
                  [Constants _company_information_titles], 
                  nil];
    
    self.values= [NSArray arrayWithObjects:
                  _person.chineseName ? _person.chineseName : @"", 
                  _person.englishName ? _person.englishName : @"", 
                  _person.phone ? _person.phone : @"", 
                  _person.telephone ? _person.telephone : @"",
                  _person.email ? _person.email : @"", 
                  _person.msn ? _person.msn : @"", 
                  _person.position ? _person.position : @"", 
                  _person.team ? _person.team : @"", 
                  _person.ext ? _person.ext : @"", 
                  nil];

#define img_width 75
    
    NSString *imageAddress = [NSString stringWithFormat:@"%@%@", ICON_ADDRESS, self.person.pic160];
    
    UIButton *b = [UIButton  buttonWithType:UIButtonTypeCustom];
    [b setTag:100];
    if (self.person.pic160.length > 0) 
    {
        [b setImage:[Tooles createRoundedRectImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageAddress]]]
                                              size:CGSizeMake(img_width, img_width)] 
           forState:UIControlStateNormal];
    }
    else 
    {
        [b setImage:[Tooles createRoundedRectImage:[UIImage imageNamed:@"icon_default.png"] 
                                              size:CGSizeMake(img_width, img_width)] 
           forState:UIControlStateNormal];
    }
    self.photos= [NSMutableArray arrayWithObjects:b, nil];
    
    
    
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [leftBtn setBackgroundImage:[[UIImage imageNamed:@"nav_back_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                       forState:UIControlStateNormal];
    [leftBtn setTitle:@" 系统设置" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [leftBtn release];
    [leftBarButtonItem release];
    
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                        forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBtn release];
    [rightBarButtonItem release];
    
    
    
#define top_field_height 480
    
    _topImageField = [[[UIView alloc] initWithFrame:CGRectMake(0, -top_field_height, 320, top_field_height)] autorelease];
    _topImageField.backgroundColor = [UIColor grayColor];
    [_tableView addSubview:_topImageField];
    [_tableView setContentInset:UIEdgeInsetsMake(top_field_height, 0, 0, 0)];
    [_tableView setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg3"]] autorelease]];
    
    
    
#define horizontal_padding 4
#define vertical_padding 8
    
    
    // 加载图片
    [self reloadPhoto];
}

- (void)reloadPhoto
{
    
    float lineHeight = vertical_padding + img_width;
    float startHeight = top_field_height - lineHeight * ceil(([_photos count] > 8 ? 8 : [_photos count])/4.0) - ([_photos count] > 0 ? vertical_padding : 0);
    
    [_tableView setContentInset:UIEdgeInsetsMake(top_field_height - startHeight, 0, 0, 0)];
    [_tableView setContentOffset:CGPointMake(0, -lineHeight * ceil(([_photos count] > 8 ? 8 : [_photos count])/4.0) - ([_photos count] > 0 ? vertical_padding : 0))];
    
    for (UIView *photo in _topImageField.subviews) 
    {
        [photo removeFromSuperview];
    }
    
    for (int i = 0; i < [_photos count]; i++) 
    {
        if (i >= 8) break;
        
        UIView *v = [_photos objectAtIndex:i];
        if ([v isKindOfClass:[UIButton class]]) 
        {
            [v setFrame:CGRectMake(horizontal_padding + (horizontal_padding + img_width) * (i%4), 
                                   startHeight + lineHeight * floor(i/4.0) + vertical_padding, img_width, img_width)];
            
            [_topImageField addSubview:v];
        }
        
    } 
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)edit
{
    editting = !editting;
    
    if(editting)
    {
        [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        
        // (增加)添加图片按钮
        UIImage *img = [Tooles createRoundedRectImage:[UIImage imageNamed:@"button_addphoto.png"] 
                                                 size:CGSizeMake(img_width, img_width)];
        
        UIButton *addPhotoBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [addPhotoBtn setTag:101];
        [addPhotoBtn setImage:img forState:UIControlStateNormal];
        [addPhotoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
        
        [_photos addObject:addPhotoBtn];
        [self reloadPhoto];
    }
    
    else 
    {
        [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        // (删除)添加图片按钮
        [_photos removeObject:[_topImageField viewWithTag:101]];
        [self reloadPhoto];
        
        // 上传图片到服务器
        //NSString *path=[NSString stringWithFormat:@"%@/Documents/header.jpg", NSHomeDirectory()];
        //NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSData *data = UIImageJPEGRepresentation([Tooles rotateImage:pickedImage], 0.5);
        if (data && data.length > 0) 
        {
            waiter.callback = @selector(uploadImageWithResult:);
            [waiter upload:data fileName:@"header"];
            
            [SVProgressHUD showWithStatus:@"提交个人信息..."];
        }
    } 
}

- (void)uploadImageWithResult:(id)result
{
    NSLog(@"%@", result);
    
    int success = [[(NSDictionary *)result objectForKey:@"success"] intValue];
    
    if (success == 1) 
    {
        [SVProgressHUD showSuccessWithStatus:@"资料更新成功！"];
    }
    
    else 
    {
        [SVProgressHUD showErrorWithStatus:[result objectForKey:@"msg"]];
    }
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addPhoto
{
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"添加照片" 
                                                        delegate:self 
                                               cancelButtonTitle:@"取消" 
                                          destructiveButtonTitle:nil 
                                               otherButtonTitles:@"拍照", @"相册", nil] 
                            autorelease];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.groups objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSArray *group = [self.groups objectAtIndex:indexPath.section];
    
    cell.textLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    cell.textLabel.text  = [group objectAtIndex:indexPath.row];
    
    UILabel *label       = (UILabel *)[cell viewWithTag:99];
    if (!label) 
    {
        label                = [[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 44)] autorelease];
        label.backgroundColor= [UIColor clearColor];
        label.textColor      = MidnightBlue;
        label.textAlignment  = UITextAlignmentRight;
        label.font           = [UIFont fontWithName:@"Helvetica" size:16.0];
        label.tag            = 99;
        [cell addSubview:label];
    }
    
    switch (indexPath.section) {
        case 0:
            label.text = [self.values objectAtIndex:indexPath.row];
            break;
            
        case 1:
            label.text = [self.values objectAtIndex:indexPath.row + 2];    //2:第一个section的row的数量
            break;
            
        case 2:
            label.text = [self.values objectAtIndex:indexPath.row + 2 + 4];//4:第二个section的row的数量
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor darkGrayColor];
	label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
	label.text = [[Constants _detail_group_titles] objectAtIndex:section];
    
    return label;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
	return 30.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == 2) 
    {
        return; // Cancel get image
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; // Create the imagePicker
    imagePicker.delegate = self; 
    imagePicker.allowsEditing = YES; // Allow editing of the images
    
	if (buttonIndex == 0) 
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
    
    else if (buttonIndex == 1)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}

#pragma mark - UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    /*
    // save image to local
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@.jpg", NSHomeDirectory(), @"header"];
    NSData *imgData = UIImageJPEGRepresentation(image,0);    
    [imgData writeToFile:path atomically:YES];*/
    self.pickedImage = image;
    
    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)useImage:(UIImage *)image 
{  
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
    
    // Create a graphics image context  
    CGSize newSize = CGSizeMake(78, 78);  
    UIGraphicsBeginImageContext(newSize);  
    // Tell the old image to draw in this new context, with the desired  
    // new size  
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];  
    // Get the new image from the context  
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();  
    // End the context  
    UIGraphicsEndImageContext();  
    
    // New image
    UIImage *img = [Tooles createRoundedRectImage:newImage 
                                             size:CGSizeMake(img_width, img_width)];
    UIButton *b = [UIButton  buttonWithType:UIButtonTypeCustom];
    [b setTag:100];
    [b setImage:img forState:UIControlStateNormal];
    [_photos replaceObjectAtIndex:0 withObject:b];
    [self reloadPhoto]; 
    
    [pool release];  
} 

@end
