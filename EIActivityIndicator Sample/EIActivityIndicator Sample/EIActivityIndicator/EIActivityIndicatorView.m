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


#import "EIActivityIndicatorView.h"
#import "EIActivityIndicatorAnimator.h"
#import <CoreGraphics/CoreGraphics.h>

@interface EIActivityIndicatorView ()

@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@property (strong, nonatomic) EIActivityIndicatorAnimator *animator;
@property (assign, nonatomic) BOOL isAnimating;
@property (assign, nonatomic) BOOL isInteracting;

@property (assign, nonatomic) EIActivityIndicatorStyle style;
@property (weak, nonatomic) UIPanGestureRecognizer *panGesture;

@property (weak, nonatomic) UIView *interactionView;

@property (assign, nonatomic) BOOL shouldBeAnimating;

@property (weak, nonatomic) id target;
@property (nonatomic) SEL action;

@end

@implementation EIActivityIndicatorView

#pragma mark - Initialization and life cycle

+ (EIActivityIndicatorView *)activityIndicatorViewWithInteractionView:(UIView *)interactionView withStyle:(EIActivityIndicatorStyle)style {
    
    EIActivityIndicatorView *activityIndicatorView = [[EIActivityIndicatorView alloc] initWithFrame:CGRectZero andStyle:style];
    
    if ([interactionView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)interactionView;
        [scrollView.panGestureRecognizer addTarget:activityIndicatorView action:@selector(handlePanGesture:)];
        activityIndicatorView.panGesture = scrollView.panGestureRecognizer;
    } else {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:activityIndicatorView action:@selector(handlePanGesture:)];
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 1;
        activityIndicatorView.panGesture = panGesture;
        [interactionView addGestureRecognizer:panGesture];
    }
        
    activityIndicatorView.interactionView = interactionView;
    
    return activityIndicatorView;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //Shape layer
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.borderWidth = 0;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeStart = 0.f;
        shapeLayer.strokeEnd = 0.f;
        [self.layer addSublayer:shapeLayer];
        self.shapeLayer = shapeLayer;
        
        //Animator
        self.animator = [[EIActivityIndicatorAnimator alloc] init];
        self.animator.activityIndicatorLayer = self.shapeLayer;
        self.animator.activityIndicatorView = self;
       
        //Properties
        self.hidesWhenStopped = YES;
        self.lineWidth = 2.f;
        self.lineColor = [UIColor whiteColor];
        self.startAngle = 0.f * M_PI / 180;
        self.endAngle = 317 * M_PI / 180;
       
        //Observing
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame andStyle:(EIActivityIndicatorStyle)style {
    
    self = [self initWithFrame:frame];
    
    if (self) {
        self.style = style;
    }
    
    return self;
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.panGesture) {
    
        if (self.interactionView) {
            if ([[self.interactionView gestureRecognizers] containsObject:self.panGesture]) {
                [self.interactionView removeGestureRecognizer:self.panGesture];
            }
        }
        
    }
    
}

#pragma mark - 

- (void)addTarget:(id)target action:(SEL)action {
    self.target = target;
    self.action = action;
}

- (void)startAnimating {
 
    if (self.isAnimating) {
        [self removeAnimation];
    }
    
    self.shouldBeAnimating = YES;
  
    [self addAnimation];
    
    self.hidden = NO;
    self.isAnimating = YES;
  
    if ([self.delegate respondsToSelector:@selector(activityIndicatorViewDidStartAnimation:)]) {
        [self.delegate activityIndicatorViewDidStartAnimation:self];
    }
    
}

- (void)stopAnimating {
    
    if (!self.isAnimating) {
        return;
    }
    
    self.shouldBeAnimating = NO;
    
    [self removeAnimation];
    self.isAnimating = NO;

    if ([self.delegate respondsToSelector:@selector(activityIndicatorViewDidFinishAnimation:)]) {
        [self.delegate activityIndicatorViewDidFinishAnimation:self];
    }
    
    if (self.hidesWhenStopped) {
        [self hide];
    }
    
}

- (void)showActivityIndicatorForProgress:(CGFloat)progress {
    
    self.shapeLayer.path = [self circularPath].CGPath;
    self.hidden = NO;
    self.isAnimating = YES;
    
    [self.animator animateWithProgress:progress andEndAngle:self.endAngle];
    
}

- (void)resetStrokes {
    [self.animator resetStrokes];
}

#pragma mark - Properties

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.shapeLayer.lineWidth = self.lineWidth;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.shapeLayer.strokeColor = self.lineColor.CGColor;
}

- (void)setGestureRecognizerDelegate:(id<UIGestureRecognizerDelegate>)gestureRecognizerDelegate {
    _gestureRecognizerDelegate = gestureRecognizerDelegate;
    self.panGesture.delegate = gestureRecognizerDelegate;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    width = fminf(width, height);
    
    frame.size.width = width;
    frame.size.height = width;
    
    self.shapeLayer.frame = frame;
    
}

#pragma mark - Actions 

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    
    if (self.isAnimating && !self.isInteracting) {
        return;
    }
    
    CGFloat percent = self.interactionView.bounds.size.height * 0.2f / 100.f;
    
    CGPoint translation = [panGesture translationInView:self.interactionView];
    
    if (translation.y < 0) {
        return;
    }
    
    CGFloat verticalMovementPercent = translation.y / percent;
    verticalMovementPercent = fminf(verticalMovementPercent, 100.f);
    
    [self showActivityIndicatorForProgress:verticalMovementPercent / 100.f];
    self.isInteracting = YES;
    
    if ([self.delegate respondsToSelector:@selector(activityIndicatorView:didInteractWithInteractionView:withProgress:)]) {
        [self.delegate activityIndicatorView:self didInteractWithInteractionView:self.inputView withProgress:verticalMovementPercent / 100.f];
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        if (verticalMovementPercent >= 100) {
        
            [self startAnimating];
            self.isInteracting = NO;
            
            if ([self.target respondsToSelector:self.action]) {
               [self.target performSelector:self.action withObject:nil];
            }
            
        } else {

            [self stopAnimating];
            self.isInteracting = NO;
            
        }
        
    } else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state ==UIGestureRecognizerStateFailed) {
        
        [self stopAnimating];
        self.isInteracting = NO;
        
    }
    
}

#pragma mark - Private Methods

- (UIBezierPath *)circularPath {
    
    CGFloat width = self.bounds.size.width;
    
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2.f, width / 2.f) radius:width / 2.2f startAngle:0 endAngle:360 * M_PI / 180 clockwise: YES];
    
}

- (void)addAnimation {
    [self.animator animateWithStyle:self.style];
}

- (void)removeAnimation {
    [self.animator removeAnimations];
}

- (void)hide {
    self.isAnimating = YES;
    [self.animator hideActivityIndicatorWithCompletionHandler:^{
        self.isAnimating = NO;
    }];
}

#pragma mark - Observing

- (void)applicationDidEnterBackground {
    
    if (self.isAnimating) {
        [self stopAnimating];
        self.shouldBeAnimating = YES;
    }
    
}

- (void)applicationWillEnterForeground {
    
    if (self.shouldBeAnimating) {
        [self startAnimating];
    }
    
}

@end
