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


#import "SecondScreenViewController.h"
#import "EIActivityIndicatorView.h"

@interface SecondScreenViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) EIActivityIndicatorView *activityIndicatorView;
@property (assign, nonatomic) BOOL interacting;

@end

@implementation SecondScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = 20.f;
    
    EIActivityIndicatorView *activityIndicatorView = [[EIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - width / 2, 25, width, width) andStyle:EIActivityIndicatorStyleSimple];
    [activityIndicatorView setLineColor:[UIColor blackColor]];
    [self.view addSubview:activityIndicatorView];
    self.activityIndicatorView = activityIndicatorView;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    self.view.backgroundColor = [UIColor grayColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        CGFloat y = 25;
        
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            y = 5;
        }
        
        self.activityIndicatorView.frame = CGRectMake(self.view.bounds.size.width / 2 - self.activityIndicatorView.bounds.size.width / 2, y, self.activityIndicatorView.bounds.size.width, self.activityIndicatorView.bounds.size.width);
        
    } completion:nil];
    
}

#pragma mark - Actions

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

#pragma mark - UIGestureRecognizerDelegate 

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (self.interacting) {
        return NO;
    }
    
    return YES;
    
}



@end
