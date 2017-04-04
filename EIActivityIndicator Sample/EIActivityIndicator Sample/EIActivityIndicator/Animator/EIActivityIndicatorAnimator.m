//Copyright (c) 2017 Evgeny Ivanov
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.


#import "EIActivityIndicatorAnimator.h"
#import <CoreGraphics/CoreGraphics.h>
#import "EIActivityIndicatorView.h"

static NSString *const kActivityIndicatorRotationAnimationKey = @"kActivityIndicatorRotationAnimationKey";
static NSString *const kActivityIndicatorStrokeAnimationKey =
@"kActivityIndicatorStrokeAnimationKey";

static CGFloat kAnimationDuration = 1.3f;
static CGFloat kHideAnimationDuration = 0.3f;

@interface EIActivityIndicatorAnimator ()
@property (assign, nonatomic) BOOL shouldCancelAnimation;
@end

@implementation EIActivityIndicatorAnimator

- (void)animateWithProgress:(CGFloat)progress andEndAngle:(CGFloat)endAngle {
    self.shouldCancelAnimation = NO;
    CGFloat maxStrokeEnd = endAngle / (360 * M_PI / 180);
    CGFloat strokeEnd = fminf(progress, maxStrokeEnd);
    self.activityIndicatorLayer.strokeEnd = strokeEnd;
}

- (void)animateWithStyle:(EIActivityIndicatorStyle)style {
    
    switch (style) {
            
        case EIActivityIndicatorStyleSimple:
            self.shouldCancelAnimation = NO;
            [self.activityIndicatorLayer addAnimation:[self rotationAnimation] forKey:kActivityIndicatorRotationAnimationKey];
            
            break;
        
        case EIActivityIndicatorStyleMaterial:
            self.shouldCancelAnimation = NO;
             if (!((self.activityIndicatorLayer.strokeEnd == 0.f) && (self.activityIndicatorLayer.strokeStart == 0.f))) {
             
                 [self strokeCorrectedAnimationWithInitialStrokeEndValue:self.activityIndicatorLayer.strokeEnd andInitialStrokeStartValue:self.activityIndicatorLayer.strokeStart];
                 
             }   else {
             [self.activityIndicatorLayer addAnimation:[self strokeAnimation] forKey:kActivityIndicatorStrokeAnimationKey];
             }

            break;
            
        default:
            break;
            
    }
    
}

- (void)hideActivityIndicatorWithCompletionHandler:(void(^)())completion {
    self.shouldCancelAnimation = YES;
    [UIView animateWithDuration:kHideAnimationDuration animations:^{
        
        self.activityIndicatorView.alpha = 0.f;
        [self resetStrokes];
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            self.activityIndicatorView.hidden = YES;
            self.activityIndicatorView.alpha = 1.f;
            
            if (completion) {
                completion();
            }
            
        }
        
    }];
    
}

- (void)resetStrokes {
    self.activityIndicatorLayer.strokeStart = 0.f;
    self.activityIndicatorLayer.strokeEnd = 0.f;
}

- (void)removeAnimations {
    self.shouldCancelAnimation = YES;
    [self.activityIndicatorLayer removeAllAnimations];
}

#pragma mark - Private Methods

- (CAMediaTimingFunction *)timingFunction {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
}

- (void)strokeCorrectedAnimationWithInitialStrokeEndValue:(CGFloat)strokeEndFromValue andInitialStrokeStartValue:(CGFloat)strokeStartFromValue {
    
    [CATransaction begin];
    self.activityIndicatorLayer.strokeStart = 1.f;
    self.activityIndicatorLayer.strokeEnd = 1.f;
    CAKeyframeAnimation *strokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.values = @[@(strokeEndFromValue), @(1)];
    strokeEndAnimation.duration = kAnimationDuration;
    
    CAKeyframeAnimation *strokeStartAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.values = @[@(strokeStartFromValue), @(1)];
    strokeStartAnimation.duration = kAnimationDuration;
    
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    [animationGroup setAnimations:@[strokeEndAnimation, strokeStartAnimation]];
    animationGroup.repeatCount = 1;
    animationGroup.duration = kAnimationDuration;
    
    [CATransaction setCompletionBlock:^{
        
        if (self.shouldCancelAnimation) {
            return;
        }
        
        self.activityIndicatorLayer.strokeStart = 0.f;
        self.activityIndicatorLayer.strokeEnd = 1.f;
        [self.activityIndicatorLayer removeAnimationForKey:kActivityIndicatorStrokeAnimationKey];
        [self.activityIndicatorLayer addAnimation:[self strokeAnimation] forKey:kActivityIndicatorStrokeAnimationKey];
        [self.activityIndicatorLayer addAnimation:[self rotationAnimation] forKey:kActivityIndicatorRotationAnimationKey];
    }];
    
    [self.activityIndicatorLayer addAnimation:animationGroup forKey:kActivityIndicatorStrokeAnimationKey];
    
    [CATransaction commit];
    
}

- (CAAnimationGroup *)strokeAnimation {
    
    //original: http://blog.matthewcheok.com/design-teardown-spinning-indicator/
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = kAnimationDuration;
    strokeEndAnimation.timingFunction = [self timingFunction];
    strokeEndAnimation.fromValue = @(0);
    strokeEndAnimation.toValue = @(1);
    
    CAAnimationGroup *strokeEndAnimationGroup = [[CAAnimationGroup alloc] init];
    [strokeEndAnimationGroup setAnimations:@[strokeEndAnimation]];
    strokeEndAnimationGroup.duration = kAnimationDuration + kAnimationDuration/4.f;
    strokeEndAnimationGroup.repeatCount = INFINITY;
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.beginTime = 0.5f;
    strokeStartAnimation.duration = kAnimationDuration;
    strokeStartAnimation.timingFunction = [self timingFunction];
    strokeStartAnimation.fromValue = @(0);
    strokeStartAnimation.toValue = @(1);
    
    CAAnimationGroup *strokeStartAnimationGroup = [[CAAnimationGroup alloc] init];
    [strokeStartAnimationGroup setAnimations:@[strokeStartAnimation]];
    strokeStartAnimationGroup.duration = kAnimationDuration + kAnimationDuration/4.f;
    strokeStartAnimationGroup.repeatCount = INFINITY;
    
    CAAnimationGroup *strokeAnimation = [[CAAnimationGroup alloc] init];
    [strokeAnimation setAnimations:@[strokeEndAnimationGroup, strokeStartAnimationGroup]];
    strokeAnimation.repeatCount = INFINITY;
    strokeAnimation.duration = kAnimationDuration + kAnimationDuration/4.f;
    
    return strokeAnimation;
}


- (CABasicAnimation *)rotationAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2*M_PI);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = kAnimationDuration * 2;
    animation.repeatCount = INFINITY;
    
    return animation;
}

@end
