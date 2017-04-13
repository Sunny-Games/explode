//
//  UIView+CoreAnimation.h
//  CoreAnimationPlayGround
//
//  Created by Daniel Tavares on 27/03/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

typedef void(^ExplodeCompletion)(void);

@interface UIView (Explode) <CAAnimationDelegate>

@property (nonatomic, copy) ExplodeCompletion completionCallback;
@property (nonatomic, strong) UIImage *explodeImage;

- (void)lp_explodeWithImage:(UIImage *)explodeImage callback:(ExplodeCompletion)callback;

@end
