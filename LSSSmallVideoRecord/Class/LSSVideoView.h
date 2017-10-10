//
//  LSSVideoView.h
//  LSSSmallVideoRecord
//
//  Created by lss on 2017/9/4.
//  Copyright © 2017年 insight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSVideoModel.h"

#pragma mark-LSSVideoViewDelegate
@protocol LSSVideoViewDelegate <NSObject>
-(void)dismissVC;
-(void)recordFinishWithvideoUrl:(NSURL *)videoUrl;
@end

#pragma mark-LSSVideoView
@interface LSSVideoView : UIView
@property (nonatomic, assign) FMVideoViewType viewType;
@property (nonatomic, strong, readonly) LSSVideoModel *fmodel;
@property (nonatomic,assign) FMVideoViewBite bitsPerPixel;
@property (nonatomic,assign) CGFloat recordMaxTime;
@property (nonatomic, weak) id <LSSVideoViewDelegate> delegate;
- (instancetype)initWithFMVideoViewType:(FMVideoViewType)type WithPerPixel:(FMVideoViewBite)bitsPerPixel WithRecordMaxTime:(CGFloat)recordMaxTime StatusBarHeight:(CGFloat)statusBarHeight;
- (void)reset;
@end

#pragma mark-FMRecordProgressView
@interface FMRecordProgressView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
-(void)updateProgressWithValue:(CGFloat)progress;
-(void)resetProgress;
@end
