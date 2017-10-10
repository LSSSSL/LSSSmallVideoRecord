//
//  LSSVideoModel.h
//  LSSSmallVideoRecord
//
//  Created by lss on 2017/9/4.
//  Copyright © 2017年 insight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSVAssetWriteManager.h"
#import <UIKit/UIKit.h>

#pragma mark -闪光灯状态
typedef NS_ENUM(NSInteger, FMFlashState) {
    FMFlashClose = 0,
    FMFlashOpen,
    FMFlashAuto,
};

@protocol LSSVideoModelDelegate <NSObject>
- (void)updateFlashState:(FMFlashState)state;
- (void)updateRecordingProgress:(CGFloat)progress;
- (void)updateRecordState:(FMRecordState)recordState;
@end

@interface LSSVideoModel : NSObject
@property (nonatomic, weak  ) id<LSSVideoModelDelegate>delegate;
@property (nonatomic, assign) FMRecordState recordState;
@property (nonatomic, strong, readonly) NSURL *videoUrl;
@property (nonatomic,assign) FMVideoViewBite bitsPerPixel;
@property (nonatomic,assign) CGFloat recordMaxTime;

- (instancetype)initWithFMVideoViewType:(FMVideoViewType )type superView:(UIView *)superView WithPerPixel:(FMVideoViewBite)bitsPerPixel WithRecordMaxTime:(CGFloat)recordMaxTime;
- (void)turnCameraAction;
- (void)switchflash;
- (void)startRecord;
- (void)stopRecord;
- (void)reset;

@end
