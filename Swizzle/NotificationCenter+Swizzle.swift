//
//  NotificationCenter+Swizzle.swift
//  Swizzle
//
//  Created by Ben Shutt on 12/10/2021.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit

public extension NotificationCenter {

    /// Add Swizzled observer
    ///
    /// - Parameters:
    ///   - name: `NSNotification.Name`
    ///   - object: `Any`
    ///   - queue: `OperationQueue`
    ///   - block: Closure
    ///
    /// - Returns: `NSObjectProtocol`
    @discardableResult
    func addSwizzledObserver(
        forName name: NSNotification.Name,
        object: Any? = nil,
        queue: OperationQueue = .main,
        using block: @escaping (UIViewController) -> Void
    ) -> NSObjectProtocol {
        return addObserver(
            forName: name,
            object: object,
            queue: queue
        ) { sender in
            let key = kViewControllerNotificationKey
            guard let viewController = sender.userInfo?[key] as? UIViewController else { return }
            block(viewController)
        }
    }
}
