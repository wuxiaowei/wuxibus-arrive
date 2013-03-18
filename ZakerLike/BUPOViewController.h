//
//  BUPOViewController.h
//  ZakerLike
//
//  Created by bupo Jung on 12-5-15.
//  Copyright (c) 2012年 Wuxi Smart Sencing Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BJGridItem.h"
#import "StationStore.h"
@interface BUPOViewController : UIViewController<UIScrollViewDelegate,BJGridItemDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *gridItems;
    BJGridItem *addbutton;
    int page;
    float preX;
    BOOL isMoving;
    CGRect preFrame;
    BOOL isEditing;
    UITapGestureRecognizer *singletap;
    StationStore *stationStore;
//    CGRect MovingToFrame;
//    CGRect MovingFromFrame;
//    NSInteger MovingToIndex;
//    NSInteger MovingFromIndex; 
}
@property (weak, nonatomic) IBOutlet UIImageView *backgoundImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
- (void)Addbutton;
- (IBAction)addItem:(id)sender;
- (IBAction)searchLine:(id)sender;
@property (strong,nonatomic) UINavigationController *navController;
-(void)addGirdItemWithStation:(BusStation *)s;
@end
