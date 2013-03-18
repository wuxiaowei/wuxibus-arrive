//
//  BJGridItem.m
//  ZakerLike
//
//  Created by bupo Jung on 12-5-15.
//  Copyright (c) 2012年 Wuxi Smart Sencing Star. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BJGridItem.h"

@implementation BJGridItem
@synthesize isEditing,isRemovable,index;
@synthesize delegate;
@synthesize station;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id) initWithTitle:(NSString *)title withImageName:(NSString *)imageName atIndex:(NSInteger)aIndex editable:(BOOL)removable withStation:(BusStation *)s{
    self = [super initWithFrame:CGRectMake(0, 0, 200, 100)];
    if (self) {
        //  self.backgroundColor = [UIColor clearColor];
        normalImage = [UIImage imageNamed:imageName];
        titleText = title;
        self.isEditing = NO;
        index = aIndex;
        self.isRemovable = removable;
        innnerViewController=[[InnerViewController alloc]initWithGirdItem:self];
        innnerViewController.busStation=s;
        NSLog(@"%@",innnerViewController.busStation.stationName);
        innnerViewController.movable=self.isRemovable;
        innnerViewController.view.frame=self.bounds;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
        [self addGestureRecognizer:longPress];
        longPress = nil;
        [self addSubview:innnerViewController.view];
    }
    return self;
}

- (id) initWithTitle:(NSString *)title withImageName:(NSString *)imageName atIndex:(NSInteger)aIndex editable:(BOOL)removable {
    self = [super initWithFrame:CGRectMake(0, 0, 200, 100)];
    if (self) {
      //  self.backgroundColor = [UIColor clearColor];
        normalImage = [UIImage imageNamed:imageName];
        titleText = title;
        self.isEditing = NO;
        index = aIndex;
        self.isRemovable = removable;
        innnerViewController=[[InnerViewController alloc]initWithGirdItem:self];
        innnerViewController.busStation=station;
        NSLog(@"%@",innnerViewController.busStation.stationName);
        innnerViewController.movable=self.isRemovable;
       innnerViewController.view.frame=self.bounds;

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
        [self addGestureRecognizer:longPress];
        longPress = nil;
        [self addSubview:innnerViewController.view];
    }
    return self;
}
#pragma mark - UI actions

- (void) clickItem:(id)sender {
 //   [innnerViewController.fullTickerView tick:0 animated:YES completion:^{
   //     NSLog(@"Done Down");
  //  }];
    [innnerViewController doQuery:nil];
    if (!innnerViewController.timer) {
        innnerViewController.timer=[NSTimer scheduledTimerWithTimeInterval:10 target:innnerViewController selector:@selector(doQuery:) userInfo:nil repeats:YES];
    }else{
        [innnerViewController.timer invalidate];
        innnerViewController.timer=nil;
    }
    [delegate gridItemDidClicked:self];
}
- (void) pressedLong:(UILongPressGestureRecognizer *) gestureRecognizer{
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            point = [gestureRecognizer locationInView:self];
            [delegate gridItemDidEnterEditingMode:self];
            //放大这个item
            [self setAlpha:1.0];
            NSLog(@"press long began");
            break;
        case UIGestureRecognizerStateEnded:
            point = [gestureRecognizer locationInView:self];
            [delegate gridItemDidEndMoved:self withLocation:point moveGestureRecognizer:gestureRecognizer];
            //变回原来大小
            [self setAlpha:1];
            NSLog(@"press long ended");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"press long failed");
            break;
        case UIGestureRecognizerStateChanged:
            //移动
            
            [delegate gridItemDidMoved:self withLocation:point moveGestureRecognizer:gestureRecognizer];
            NSLog(@"press long changed");
            break;
        default:
            NSLog(@"press long else");
            break;
    }
    
    //CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    
}

- (void) removeButtonClicked:(id) sender  {
    [delegate gridItemDidDeleted:self atIndex:index];
}

#pragma mark - Custom Methods

- (void) enableEditing {
    
    if (self.isEditing == YES)
        return;
    
    // put item in editing mode
    self.isEditing = YES;
    
    // make the remove button visible
    [innnerViewController.deleteButton setHidden:NO];
    [innnerViewController.deleteButton2 setHidden:NO];
    [innnerViewController.button setEnabled:NO];
    [innnerViewController.button2 setEnabled:NO];
    // start the wiggling animation
    CGFloat rotation = 0.03;
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.13;
    shake.autoreverses = YES;
    shake.repeatCount  = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
    
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
    
    // inform the springboard that the menu items are now editable so that the springboard
    // will place a done button on the navigationbar 
    //[(SESpringBoard *)self.delegate enableEditingMode];
    
}

- (void) disableEditing {
    [self.layer removeAnimationForKey:@"shakeAnimation"];
    [innnerViewController.deleteButton setHidden:YES];
    [innnerViewController.deleteButton2 setHidden:YES];
    [innnerViewController.button setEnabled:YES];
    [innnerViewController.button2 setEnabled:YES];
    self.isEditing = NO;
}

# pragma mark - Overriding UiView Methods

- (void) removeFromSuperview {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        [self setFrame:CGRectMake(self.frame.origin.x+50, self.frame.origin.y+50, 0, 0)];
        [innnerViewController.deleteButton setFrame:CGRectMake(0, 0, 0, 0)];
    }completion:^(BOOL finished) {
        [super removeFromSuperview];
    }]; 
}

@end
