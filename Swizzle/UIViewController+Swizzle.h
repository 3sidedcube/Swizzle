//
//  UIViewController+Swizzle.h
//  Swizzle
//
//  Created by Ben Shutt on 26/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Name of `viewWillAppear(_:)` notification
 */
extern NSString *kViewWillAppearNotification;

/**
 Name of `viewDidAppear(_:)` notification
 */
extern NSString *kViewDidAppearNotification;

/**
 Name of `viewWillDisappear(_:)` notification
 */
extern NSString *kViewWillDisappearNotification;

/**
 Name of `viewDidDisappear(_:)` notification
 */
extern NSString *kViewDidDisappearNotification;

/**
 User info key for `UIViewController` instance
 */
extern NSString *kViewControllerNotificationKey;

@interface UIViewController (Swizzle)

@end

NS_ASSUME_NONNULL_END
