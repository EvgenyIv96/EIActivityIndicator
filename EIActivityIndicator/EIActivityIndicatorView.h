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

#import <UIKit/UIKit.h>
#import "EIActivityIndicatorStyle.h"

@protocol EIActivityIndicatorViewDelegate;
@protocol UIGestureRecognizerDelegate;

@interface EIActivityIndicatorView : UIView

/**
 @author Evgeny Ivanov
 
 Constructor is used for automatically usage. This method returns activity indicator with selected style.
 NOTE: There is pan gesture recognizer will be added on view.
 
 @param interactionView UIView View which activity indicator interaction will be setuped at.
 @param style EIActivityIndicatorStyle Activity indicator style.
 
 @return EIActivityIndicatorView Activity indicator view.
 */
+ (EIActivityIndicatorView *)activityIndicatorViewWithInteractionView:(UIView *)interactionView withStyle:(EIActivityIndicatorStyle)style;

/**
 @author Evgeny Ivanov
 
 Method is used to initialize activity indicator.
 
 @param frame CGRect Activity indicator frame
 @param style EIActivityIndicatorStyle Style of activity indicator. There are some different animation for each style.
 
 @return EIAcitivityIndicatorView
 */
- (instancetype)initWithFrame:(CGRect)frame andStyle:(EIActivityIndicatorStyle)style;

/**
 @author Evgeny Ivanov
 
 Delegate property.
 */
@property (weak, nonatomic) id<EIActivityIndicatorViewDelegate> delegate;

/**
 @author Evgeny Ivanov
 
 Gesture recognizer delegate. Activity indicator view is gesture recognizer delegate by default.
 
 NOTE: It works only when activity indicator was setuped with interaction view.
 */
@property (weak, nonatomic) id<UIGestureRecognizerDelegate> gestureRecognizerDelegate;

/**
 @author Evgeny Ivanov
 
 Method is used to add refresh action for pull to refresh.
 
 NOTE: It works only when activity indicator was setuped with interaction view.
 
 @param target id
 @param action selector Action selector.
 */
- (void)addTarget:(id)target action:(SEL)action;

/**
 @author Evgeny Ivanov
 
 Property indicates when animation is performing.
 */
@property (assign, nonatomic, readonly) BOOL isAnimating;
/**
 @author Evgeny Ivanov
 
 Property indicates when activity indicator is interacting with user input.
 */
@property (assign, nonatomic, readonly) BOOL isInteracting;
/**
 @author Evgeny Ivanov
 
 Activity indicator will be hidden when animation does not perform if this property equals "YES". 
 By default is "YES".
 */
@property (assign, nonatomic) BOOL hidesWhenStopped;

/**
 @author Evgeny Ivanov
 
 Activity indicator line width.
 By default it equals 2.f.
 */
@property (assign, nonatomic) CGFloat lineWidth;

/**
 @author Evgeny Ivanov
 
 Color of activity indicator.
 By default it is white color.
 */
@property (strong, nonatomic) UIColor *lineColor;

/**
 @author Evgeny Ivanov
 
 Float value (in radians) of angle which activity indicator starts drawing from.
 By default it equals 0 (in degrees!).
 */
@property (assign, nonatomic) CGFloat startAngle;

/**
 @author Evgeny Ivanov
 
 Float value (in radians) of angle which activity indicator ends drawing to .
 By default it equals 317 degrees(!!!).
 */
@property (assign, nonatomic) CGFloat endAngle;

/**
 @author Evgeny Ivanov
 
 Method is used to start activity indicator animation. Activity indicator will be unhidden before  animation starts.
 */
- (void)startAnimating;

/**
 @author Evgeny Ivanov
 
 Method is used to stop activity indicator animation. If hidesWhenStopped property equals "YES", activity indicator will be hidden.
 */
- (void)stopAnimating;

/**
 @author Evgeny Ivanov
 
 Method is used to set line width. By default line width is 2.f
 
 @param lineWidth CGFloat Float value for line width.
 */
- (void)setLineWidth:(CGFloat)lineWidth;

/**
 @author Evgeny Ivanov
 
 Method is used to set line color. By default line color is white.
 
 @param lineColor UIColor Line color.
 */
- (void)setLineColor:(UIColor *)lineColor;

/**
 @author Evgeny Ivanov
 
 Method is used to show static activity indicator view for a given progress. 
 Use this method to interact with activity indicator.
 
 @param progress CGFloat Float value from 0.0 to 1.0.
 */
- (void)showActivityIndicatorForProgress:(CGFloat)progress;

/**
 @author Evgeny Ivanov
 
 Method is used to reset stroke start and stroke end values.
 NOTE: Call it only when you really need it!
 */
- (void)resetStrokes;

@end

@protocol EIActivityIndicatorViewDelegate <NSObject>

@optional

/**
 @author Evgeny Ivanov
 
 Method is used to inform delegate that activity indicator started animation.
 */
- (void)activityIndicatorViewDidStartAnimation:(EIActivityIndicatorView *)activityIndicatorView;

/**
 @author Evgeny Ivanov
 
 Method is used to inform delegate that activity indicator showed path for progress.
 
 @param interactionView UIView
 @param progress CGFloat Float value for progress from 0.f to 1.f.
 */
- (void)activityIndicatorView:(EIActivityIndicatorView *)activityIndicatorView didInteractWithInteractionView:(UIView *)interactionView withProgress:(CGFloat)progress;

/**
 @author Evgeny Ivanov
 
 Method is used to inform delegate that activity indicator finished animation.
 */
- (void)activityIndicatorViewDidFinishAnimation:(EIActivityIndicatorView *)activityIndicatorView;

@end
