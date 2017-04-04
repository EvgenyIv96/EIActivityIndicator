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


#import <Foundation/Foundation.h>
#import "EIActivityIndicatorStyle.h"
#import <UIKit/UIKit.h>

@class EIActivityIndicatorView;

@interface EIActivityIndicatorAnimator : NSObject

@property (weak, nonatomic) CAShapeLayer *activityIndicatorLayer;
@property (weak, nonatomic) EIActivityIndicatorView *activityIndicatorView;

/**
 @author Evgeny Ivanov
 
 Method is used to update activity indicator layer animation for current interaction progress.
 
 @param progress CGFloat Float value from 0.f to 1.f
 @param endAngle CGFloat Float value for max angle in radians.
 */
- (void)animateWithProgress:(CGFloat)progress andEndAngle:(CGFloat)endAngle;

/**
 @author Evgeny Ivanov
 
 Method is used to animate activity indicator.
 
 @param style EIActivityIndicatorStyle Activity indicator style.
 */
- (void)animateWithStyle:(EIActivityIndicatorStyle)style;

/**
 @author Evgeny Ivanov
 
 Method is used to hide activity indicator with fade animation.
 
 @param completion Block Completion handler.
 */
- (void)hideActivityIndicatorWithCompletionHandler:(void(^)())completion;

/**
 @author Evgeny Ivanov
 
 Method is used to remove all animations from activity indicator view layer.
 */
- (void)removeAnimations;

/**
 @author Evgeny Ivanov
 
 Method is used to reset stroke start and stroke end positions.
 */
- (void)resetStrokes;

@end
