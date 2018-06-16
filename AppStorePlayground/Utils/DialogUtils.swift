//
//  DialogUtils.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/16/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import MBProgressHUD

struct DialogUtils {
    
    static func show(_ text: String = "") {
        if let view = getTopView() {
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = .text
            loadingNotification.label.text = text
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.hide()
            }
        }
    }
    
    static func hide() {
        if let view = getTopView() {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    private static func getTopView() -> UIView? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController.view
        }
        return nil
    }
}

