//
//  UIViewControllerExtension.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/14/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import UIKit

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        navigationItem.titleView?.endEditing(true)
    }

}
