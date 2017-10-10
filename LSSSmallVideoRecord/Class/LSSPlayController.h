//
//  LSSPlayController.h
//  LSSSmallVideoRecord
//
//  Created by lss on 2017/9/4.
//  Copyright © 2017年 insight. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LSSPlayDelegate <NSObject>
-(void)dismissPlayVC;
-(void)haveDoneWith:(NSDictionary *)dict;
@end

@interface LSSPlayController : UIViewController
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) CGFloat statusBarHeight;
@property (nonatomic, weak) id <LSSPlayDelegate> delegate;
@end
