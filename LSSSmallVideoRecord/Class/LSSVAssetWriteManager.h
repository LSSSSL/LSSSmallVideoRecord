//
//  LSSVAssetWriteManager.h
//  LSSSmallVideoRecord
//
//  Created by lss on 2017/9/4.
//  Copyright © 2017年 insight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#pragma mark -录制状态，（这里把视频录制与写入合并成一个状态）
typedef NS_ENUM(NSInteger, FMRecordState) {
    FMRecordStateInit = 0,
    FMRecordStatePrepareRecording,
    FMRecordStateRecording,
    FMRecordStateFinish,
    FMRecordStateFail,
};

#pragma mark -录制视频的长宽比
typedef NS_ENUM(NSInteger, FMVideoViewType) {
    Type1X1 = 0,
    Type4X3,
    TypeFullScreen
};

#pragma mark -录制视频的压缩 比特值
typedef NS_ENUM(NSInteger, FMVideoViewBite) {
    FMVideoViewBiteHeight = 0,
    FMVideoViewBiteMedium,
    FMVideoViewBiteLow,
};

@protocol AVAssetWriteManagerDelegate <NSObject>
- (void)finishWriting;
- (void)updateWritingProgress:(CGFloat)progress;
@end

@interface LSSVAssetWriteManager : NSObject
@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputVideoFormatDescription;
@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputAudioFormatDescription;
@property (nonatomic, assign) FMRecordState writeState;
@property (nonatomic,assign) FMVideoViewBite bitsPerPixel;
@property (nonatomic,assign) CGFloat recordMaxTime;
@property (nonatomic, weak) id <AVAssetWriteManagerDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)URL viewType:(FMVideoViewType )type WithPerPixel:(FMVideoViewBite)bitsPerPixel WithRecordMaxTime:(CGFloat)recordMaxTime;
- (void)startWrite;
- (void)stopWrite;
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType;
- (void)destroyWrite;

@end
