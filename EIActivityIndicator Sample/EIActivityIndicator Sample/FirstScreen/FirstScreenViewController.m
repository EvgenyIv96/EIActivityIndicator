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

#import "FirstScreenViewController.h"
#import "EIActivityIndicatorView.h"

@interface FirstScreenViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) EIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) UILabel *refreshDateLabel;

@end

@implementation FirstScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EIActivityIndicatorView *activityIndicatorView = [EIActivityIndicatorView activityIndicatorViewWithInteractionView:self.view withStyle:EIActivityIndicatorStyleMaterial];
    [activityIndicatorView addTarget:self action:@selector(simulateObtainingData)];
    [activityIndicatorView setLineColor:[UIColor blackColor]];
    [activityIndicatorView setLineWidth:2.f];
    CGFloat width = 20.f;
    activityIndicatorView.frame = CGRectMake(self.view.bounds.size.width / 2 - width / 2, 25, width, width);
    activityIndicatorView.gestureRecognizerDelegate = self;
    
    [self.view addSubview:activityIndicatorView];
    
    self.activityIndicatorView = activityIndicatorView;
    
    UILabel *refreshDateLabel = [[UILabel alloc] init];
    refreshDateLabel.textAlignment = NSTextAlignmentCenter;
    refreshDateLabel.text = @"Pull to refresh";
    refreshDateLabel.numberOfLines = 1;
    
    [refreshDateLabel sizeToFit];
    refreshDateLabel.frame = CGRectMake(0, self.view.bounds.size.height / 2 - refreshDateLabel.bounds.size.height / 2, self.view.bounds.size.width, refreshDateLabel.bounds.size.height);
    
    [self.view addSubview:refreshDateLabel];
    
    self.refreshDateLabel = refreshDateLabel;
    
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
        
        self.activityIndicatorView.frame = CGRectMake(self.view.bounds.size.width / 2 - self.activityIndicatorView.bounds.size.width / 2, y, self.activityIndicatorView.bounds.size.width, self.activityIndicatorView.bounds.size.height);
        
        self.refreshDateLabel.frame = CGRectMake(0, self.view.bounds.size.height / 2 - self.refreshDateLabel.bounds.size.height / 2, self.view.bounds.size.width, self.refreshDateLabel.bounds.size.height);
        
    } completion:nil];
    
}

#pragma mark - Data Managment

- (void)simulateObtainingData {
    [self performSelector:@selector(didObtainData) withObject:nil afterDelay:3.7f];
}

- (void)didObtainData {
    
    NSDate *currentDate = [[NSDate alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.YYYY hh:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:currentDate];
    
    self.refreshDateLabel.text = dateString;
    
    [self.activityIndicatorView stopAnimating];
}

#pragma mark - UIGestureRecognizerDelegate 

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (self.activityIndicatorView.isInteracting) {
        return NO;
    }
    
    return YES;
}

@end
