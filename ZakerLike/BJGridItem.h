//
//  BJGridItem.h
//  :
//
//  Created by bupo Jung on 12-5-15.
//  Copyright (c) 2012年 Wuxi Smart Sencing Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTickerView.h"
#import "InnerViewController.h"
#import "BusStation.h"
typedef enum{
    BJGridItemNormalMode = 0,
    BJGridItemEditingMode = 1,
}BJMode;
@protocol BJGridItemDelegate;
@interface BJGridItem : UIView{
    InnerViewController *innnerViewController;
    SBTickerView *tickerView;
    UIImage *normalImage;
    UIImage *editingImage;
    NSString *titleText;
    BOOL isEditing;
    BOOL isRemovable;
    NSInteger index;
    CGPoint point;//long press point
}
@property (strong,nonatomic) BusStation *station;
@property(nonatomic) BOOL isEditing;
@property(nonatomic) BOOL isRemovable;
@property(nonatomic) NSInteger index;
@property(weak,nonatomic)id<BJGridItemDelegate> delegate;
- (id) initWithTitle:(NSString *)title withImageName:(NSString *)imageName atIndex:(NSInteger)aIndex editable:(BOOL)removable;
- (id) initWithTitle:(NSString *)title withImageName:(NSString *)imageName atIndex:(NSInteger)aIndex editable:(BOOL)removable withStation:(BusStation *)s;
- (void) enableEditing;
- (void) disableEditing;
@end
@protocol BJGridItemDelegate <NSObject>

- (void) gridItemDidClicked:(BJGridItem *) gridItem;
- (void) gridItemDidEnterEditingMode:(BJGridItem *) gridItem;
- (void) gridItemDidDeleted:(BJGridItem *) gridItem atIndex:(NSInteger)index;
- (void) gridItemDidMoved:(BJGridItem *) gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*)recognizer;
- (void) gridItemDidEndMoved:(BJGridItem *) gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*) recognizer;
@end