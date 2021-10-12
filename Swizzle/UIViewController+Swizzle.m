//
//  UIViewController+Swizzle.m
//  Swizzle
//
//  Created by Ben Shutt on 26/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

#import <objc/runtime.h>

#import "UIViewController+Swizzle.h"
#import "SwizzledMethod.h"

#define SWIZZLE_LOG 0
#define SWIZZLE(X, Y) [[SwizzledMethod alloc] initWithOriginal:(X) swizzled:(Y)]

NSString *kViewWillAppearNotification = @"kViewWillAppearNotification";
NSString *kViewDidAppearNotification = @"kViewDidAppearNotification";
NSString *kViewWillDisappearNotification = @"kViewWillDisappearNotification";
NSString *kViewDidDisappearNotification = @"kViewDidDisappearNotification";
NSString *kViewControllerNotificationKey = @"kViewControllerNotificationKey";

@implementation UIViewController (Swizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        for (SwizzledMethod *swizzledMethod in [UIViewController swizzledMethods]) {
            SEL originalSelector = swizzledMethod.original;
            SEL swizzledSelector = swizzledMethod.swizzled;
            
            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            
            BOOL didAddMethod = class_addMethod(
                class,
                originalSelector,
                method_getImplementation(swizzledMethod),
                method_getTypeEncoding(swizzledMethod)
            );
            
            if (didAddMethod) {
                class_replaceMethod(
                    class,
                    swizzledSelector,
                    method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod)
                );
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}

+ (NSArray<SwizzledMethod *> *)swizzledMethods {
    return @[
        SWIZZLE(@selector(viewWillAppear:), @selector(swizzled_viewWillAppear:)),
        SWIZZLE(@selector(viewDidAppear:), @selector(swizzled_viewDidAppear:)),
        SWIZZLE(@selector(viewWillDisappear:), @selector(swizzled_viewWillDisappear:)),
        SWIZZLE(@selector(viewDidDisappear:), @selector(swizzled_viewDidDisappear:))
    ];
}

#pragma mark - User Info

/**
 User info dictionary for notifications
 */
-(NSDictionary *)userInfo {
    return @{
        kViewControllerNotificationKey: self
    };
}

/**
 Post of the default notification center a notification with the given name
 */
-(void)postNotificationName:(NSString *)notificationName {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:notificationName
                          object:self
                        userInfo:[self userInfo]];
}

#pragma mark - Method Swizzling

- (void)swizzled_viewWillAppear:(BOOL)animated {
    [self swizzled_viewWillAppear:animated];
    
    if (SWIZZLE_LOG) {
        NSLog(@"%@ %@", NSStringFromSelector(_cmd), self);
    }

    [self postNotificationName:kViewWillAppearNotification];
}

- (void)swizzled_viewDidAppear:(BOOL)animated {
    [self swizzled_viewDidAppear:animated];

    if (SWIZZLE_LOG) {
        NSLog(@"%@ %@", NSStringFromSelector(_cmd), self);
    }

    [self postNotificationName:kViewDidAppearNotification];
}

- (void)swizzled_viewWillDisappear:(BOOL)animated {
    [self swizzled_viewWillDisappear:animated];
    
    if (SWIZZLE_LOG) {
        NSLog(@"%@ %@", NSStringFromSelector(_cmd), self);
    }

    [self postNotificationName:kViewWillDisappearNotification];
}

- (void)swizzled_viewDidDisappear:(BOOL)animated {
    [self swizzled_viewDidDisappear:animated];

    if (SWIZZLE_LOG) {
        NSLog(@"%@ %@", NSStringFromSelector(_cmd), self);
    }

    [self postNotificationName:kViewDidDisappearNotification];
}

@end
