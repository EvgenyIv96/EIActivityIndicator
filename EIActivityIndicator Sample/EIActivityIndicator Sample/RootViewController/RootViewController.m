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


#import "RootViewController.h"
#import "FirstScreenViewController.h"
#import "SecondScreenViewController.h"

@interface RootViewController () <UIPageViewControllerDataSource>

@property (weak, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSArray *vcArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:0];
    pageVC.view.frame = self.view.bounds;
    
    FirstScreenViewController *firstScreenVC = [[FirstScreenViewController alloc] init];
    firstScreenVC.pageIndex = 0;
    
    SecondScreenViewController *secondScreenVC = [[SecondScreenViewController alloc] init];
    secondScreenVC.pageIndex = 1;
    
    self.vcArray = @[firstScreenVC, secondScreenVC];
    
    pageVC.dataSource = self;
    
    [pageVC setViewControllers:@[firstScreenVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageVC];
    [self.view addSubview:pageVC.view];
    [pageVC didMoveToParentViewController:self];
    
    self.pageVC = pageVC;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        self.pageVC.view.frame = self.view.bounds;
        
    } completion:nil];
    
}

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(UIViewController <PageViewController> *)viewController pageIndex];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index-1];
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(UIViewController <PageViewController> *)viewController pageIndex];
    
    if (index == [self.vcArray count] - 1 || index == NSNotFound) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index+1];
}

#pragma mark - Private Methods

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (index >= [self.vcArray count]) {
        return nil;
    }
    
    return self.vcArray[index];
    
}

@end
