//
//  NYTMediaDetailView.m
//  Recommendations
//
//  Created by Brian Capps on 12/22/14.
//  Copyright (c) 2014 NYTimes. All rights reserved.
//

#import "NYTMediaDetailView.h"
#import "NYTMediaDetailTableViewController.h"

@implementation NYTMediaDetailView

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.songDetailViewController = nil;
    self.parentViewController = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutChildViewControllerView];
}

- (void)layoutChildViewControllerView {
    self.songDetailViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (void)setSongDetailViewController:(NYTMediaDetailTableViewController *)childViewController {
    if (_songDetailViewController != childViewController) {
        [self.songDetailViewController willMoveToParentViewController:nil];
        [self.songDetailViewController.view removeFromSuperview];
        [self.songDetailViewController removeFromParentViewController];
        
        _songDetailViewController = childViewController;
        
        if (childViewController) {
            [self.parentViewController addChildViewController:childViewController];
            [self addSubview:childViewController.view];
            [childViewController didMoveToParentViewController:self.parentViewController];
            
            [self layoutChildViewControllerView];
        }
    }
}

@end
