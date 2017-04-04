# EIActivityIndicator
![](/resources/EIActivityIndicatorView.gif)

# Installation
Drag and drop EIActivityIndicator folder into your project. Make sure that "Copy items if needed" and "Create groups" selected.
Click Finish.
# Usage
```objective-c
#import "EIActivityIndicatorView.h"
```
There are 2 ways of setup. For now EIActivityIndicatorView supports automatically setup only on simple UIView. UITableView and UICollectionView automatically setup isn't supported for now!

**Automatically setup**

For automatically setup call special class method, then set frame, add target for any action, some customizations and add activity indicator as subview to your view.
```objective-c
+ (EIActivityIndicatorView *)activityIndicatorViewWithInteractionView:(UIView *)interactionView withStyle:(EIActivityIndicatorStyle)style;
```
There are 2 styles for activity indicator view animation: EIActivityIndicatorStyleSimple - simple arc rotation and EIActivityIndicatorStyleMaterial - android activity indicator animation.
```objective-c
EIActivityIndicatorView *activityIndicatorView = [EIActivityIndicatorView activityIndicatorViewWithInteractionView:self.view withStyle:EIActivityIndicatorStyleMaterial];
[activityIndicatorView addTarget:self action:@selector(simulateObtainingData)];
[activityIndicatorView setLineColor:[UIColor blackColor]];
[activityIndicatorView setLineWidth:2.f];
CGFloat width = 20.f;
activityIndicatorView.frame = CGRectMake(self.view.bounds.size.width / 2 - width / 2, 10, width, width);

[self.view addSubview:activityIndicatorView];
```
Don't forget to create a link to your activity indicator view to have an access to it. 
```objective-c
self.activityIndicatorView = activityIndicatorView;
```
**Manual setup.**

Create activity indicator.
```objective-c
CGFloat width = 20.f;
    
EIActivityIndicatorView *activityIndicatorView = [[EIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - width / 2, 25, width, width) andStyle:EIActivityIndicatorStyleSimple];
```
If you want users to have an interaction with your activity indicator you should create and setup UIPanGestureRecognizer and implement handler for it.
```objective-c
UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
panGesture.minimumNumberOfTouches = 1;
panGesture.maximumNumberOfTouches = 1;
[self.view addGestureRecognizer:panGesture];
```
```objective-c
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    
    if (!self.interacting && self.activityIndicatorView.isAnimating) {
        return;
    }
    
    CGFloat movementToStart = self.view.bounds.size.height * 0.2f;
    CGFloat percent = movementToStart / 100.f;
    
    CGPoint translation = [panGesture translationInView:self.view];
    
    if (translation.y < 0) {
        return;
    }
    
    CGFloat verticalMovementPercent = translation.y / percent;
    verticalMovementPercent = fminf(verticalMovementPercent, 100.f);
    
    [self.activityIndicatorView showActivityIndicatorForProgress:verticalMovementPercent / 100.f];
    self.interacting = YES;
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        if (verticalMovementPercent >= 100) {
            
            [self.activityIndicatorView startAnimating];
            self.interacting = NO;
            
            //Comment line below and call your update method here
            [self.activityIndicatorView performSelector:@selector(stopAnimating) withObject:nil afterDelay:3.f];
            
        } else {
            
            [self.activityIndicatorView stopAnimating];
            self.interacting = NO;
            
        }
        
    } else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state ==UIGestureRecognizerStateFailed) {
        
        [self.activityIndicatorView stopAnimating];
        self.interacting = NO;
        
    }

}
```

Control activity indicator view by calling following methods:
```objective-c
- (void)startAnimating;
- (void)stopAnimating;
- (void)showActivityIndicatorForProgress:(CGFloat)progress;
- (void)resetStrokes;
```
You can start/stop animating, draw arc for each value of progress and reset strokes manually (use it if you really need it).

# Customization
Use these properties and methods to customize activity indicator view:
```objective-c
CGFloat lineWidth;
UIColor *lineColor;
CGFloat startAngle;
CGFloat endAngle;
```
You can customize line width, line color and start/end angles of arc.
Angles shoud be in range from 0 to 360 degrees. End angle should be greater then start angle.

# Resolving gesture conflicts
To use EIActivityIndicatorView with another gesture set activity indicator view gestureRecognizerDelegate(UIGestureRecognizerDelegate) and implement appropriate delegate method.

```objective-c
activityIndicatorView.gestureRecognizerDelegate = self;
```
```objective-c
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (self.activityIndicatorView.isInteracting) {
        return NO;
    }
    
    return YES;
}
```
# Delegates
There are 2 delegate properties: delegate and gestureRecognizerDelegate.

**EIActivityIndicatorView delegate**

The method is used to inform delegate that activity indicator started **loading** animation.
```objective-c
- (void)activityIndicatorViewDidStartAnimation:(EIActivityIndicatorView *)activityIndicatorView;
```
The method is used to inform delegate that activity indicator showed path for progress. It will work only with automatically setuped activitiy indicator view.
```objective-c
- (void)activityIndicatorView:(EIActivityIndicatorView *)activityIndicatorView didInteractWithInteractionView:(UIView *)interactionView withProgress:(CGFloat)progress;
```
The method is used to inform delegate that activity indicator finished animation. (Showing interaction progress is animation too and method below will be called then showing interaction progress animation is canceled.)
```objective-c
- (void)activityIndicatorViewDidFinishAnimation:(EIActivityIndicatorView *)activityIndicatorView;
```

**gestureRecognizerDelegate**

Use gestureRecognizerDelegate when you have setuped EIActivityIndicatorView automatically. It is simple UIGestureRecognizerDelegate of UIPanGestureRecognizer.
