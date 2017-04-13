//
//  UIView+CoreAnimation.m
//  CoreAnimationPlayGround
//
//  Created by Daniel Tavares on 27/03/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//


#import "UIView+Explode.h"

@interface LPParticleLayer : CALayer

@property (nonatomic, strong) UIBezierPath *particlePath;

@end

@implementation UIView (Explode)

@dynamic completionCallback;
@dynamic explodeImage;

- (void)setCompletionCallback:(ExplodeCompletion)completionCallback
{
  [self willChangeValueForKey:@"completionCallback"];
  objc_setAssociatedObject(self, @selector(completionCallback), completionCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
  [self didChangeValueForKey:@"completionCallback"];
}

- (ExplodeCompletion)completionCallback
{
  // obj assoc
  id object = objc_getAssociatedObject(self,@selector(completionCallback));
  return object;
}


float randomFloat()
{
  return (float)rand()/(float)RAND_MAX;
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
  UIGraphicsBeginImageContext([layer frame].size);
  
  [layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return outputImage;
}

- (void)lp_explodeWithImage:(UIImage *)explodeImage callback:(ExplodeCompletion)callback;
{
  self.userInteractionEnabled = NO;
  
  if (callback)
  {
    self.completionCallback = callback;
  }
  
  // self.explodeImage = explodeImage;
  
  float size = self.frame.size.width / 2;
  CGSize imageSize = CGSizeMake(size, size);
  
  CGFloat cols = self.frame.size.width / imageSize.width ;
  CGFloat rows = self.frame.size.height /imageSize.height;
  
  int fullColumns = floorf(cols);
  int fullRows = floorf(rows);
  
  CGFloat remainderWidth = self.frame.size.width  - (fullColumns * imageSize.width);
  CGFloat remainderHeight = self.frame.size.height - (fullRows * imageSize.height );
  
  if (cols > fullColumns) fullColumns++;
  if (rows > fullRows) fullRows++;
  
  CGRect originalFrame = self.layer.frame;
  CGRect originalBounds = self.layer.bounds;
  
  CGImageRef fullImage = [self imageFromLayer:self.layer].CGImage;
  
  //if its an image, set it to nil
  if ([self isKindOfClass:[UIImageView class]])
  {
    [(UIImageView*)self setImage:nil];
  }
  
  [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  NSArray *sublayers = [NSArray arrayWithArray:[self.layer sublayers]];
  for (CALayer * one in sublayers) {
    [one removeFromSuperlayer];
  }
  
  for (int y = 0; y < fullRows; ++y) {
    for (int x = 0; x < fullColumns; ++x) {
      CGSize tileSize = imageSize;
      
      if (x + 1 == fullColumns && remainderWidth > 0) {
        // Last column
        tileSize.width = remainderWidth;
      }
      
      if (y + 1 == fullRows && remainderHeight > 0) {
        // Last row
        tileSize.height = remainderHeight;
      }
      
      CGRect layerRect = (CGRect){{x * imageSize.width, y * imageSize.height}, tileSize};
      
      CGImageRef tileImage;
      if (explodeImage != nil) {
        tileImage = explodeImage.CGImage;
      }else{
        tileImage = CGImageCreateWithImageInRect(fullImage, layerRect);
      }
      
      LPParticleLayer *layer = [LPParticleLayer layer];
      layer.frame = layerRect;
      layer.contents = (__bridge id)(tileImage);
      layer.borderWidth = 0.0f;
      layer.borderColor = [UIColor blackColor].CGColor;
      layer.particlePath = [self pathForLayer: layer parentRect: originalFrame];
      [self.layer addSublayer:layer];
      
      if (explodeImage == nil) {
        CGImageRelease(tileImage);
      }
    }
  }
  
  [self.layer setFrame:originalFrame];
  [self.layer setBounds:originalBounds];
  
  self.layer.backgroundColor = [UIColor clearColor].CGColor;
  
  NSArray *sublayersArray = [self.layer sublayers];
  [sublayersArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    LPParticleLayer *layer = (LPParticleLayer *)obj;
    
    //Path
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = layer.particlePath.CGPath;
    moveAnim.removedOnCompletion = YES;
    moveAnim.fillMode = kCAFillModeForwards;
    NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],nil];
    [moveAnim setTimingFunctions:timingFunctions];
    
    float r = randomFloat();
    
    NSTimeInterval speed = 1.8 * r;
    
    //alpha
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0f];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.f];
    opacityAnim.removedOnCompletion = YES;
    opacityAnim.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, opacityAnim, nil];
    animGroup.duration = speed;
    animGroup.fillMode =kCAFillModeForwards;
    animGroup.delegate = self;
    [animGroup setValue:layer forKey:@"animationLayer"];
    [layer addAnimation:animGroup forKey:nil];
    
    //take it off screen
    [layer setPosition:CGPointMake(-1000, 0)];
  }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  //  return;
  
  LPParticleLayer *layer = [anim valueForKey:@"animationLayer"];
  
  if (layer)
  {
    //make sure we dont have any more
    if ([[layer sublayers] count]==1)
    {
      if (self.completionCallback)
      {
        self.completionCallback();
      }
      [self removeFromSuperview];
    }
    else
    {
      [layer removeFromSuperlayer];
    }
  }
}

-(UIBezierPath *)pathForLayer:(CALayer *)layer parentRect:(CGRect)rect
{
  UIBezierPath *particlePath = [UIBezierPath bezierPath];
  [particlePath moveToPoint:layer.position];
  
  float r = ((float)rand() / (float)RAND_MAX) + 0.3f;
  float r2 = ((float)rand() / (float)RAND_MAX)+ 0.4f;
  float r3 = r * r2;
  
  int upOrDown = 1;//(r <= 0.5) ? 1 : -1;
  
  CGPoint curvePoint = CGPointZero;
  CGPoint endPoint = CGPointZero;
  
  float maxLeftRightShift = 1.f * randomFloat();
  
  CGFloat layerYPosAndHeight = 0;//- self.superview.frame.size.height * randomFloat() / 2;
  
  float endY = self.superview.frame.size.height * 2 - self.frame.origin.y;
  
  if (layer.position.x <= rect.size.width * 0.5)
  {
    CGFloat oX = self.frame.origin.x * randomFloat() * randomFloat() - self.superview.frame.size.width / 1.5;
    
    endPoint = CGPointMake(oX, endY);
    curvePoint= CGPointMake(oX * upOrDown * randomFloat(), layerYPosAndHeight);
  }
  else
  {
    float rightToSuper = (self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width) * maxLeftRightShift * r3;
    
    endPoint = CGPointMake(self.frame.origin.x + self.frame.size.width + rightToSuper, endY);
    curvePoint= CGPointMake(self.frame.origin.x + self.frame.size.width + rightToSuper * randomFloat(), layerYPosAndHeight);
  }
  
  NSLog(@"layerYPosAndHeight is %f", layerYPosAndHeight);
  [particlePath addQuadCurveToPoint:endPoint
                       controlPoint:curvePoint];
  
  return particlePath;
  
}

@end

@implementation LPParticleLayer

@end
