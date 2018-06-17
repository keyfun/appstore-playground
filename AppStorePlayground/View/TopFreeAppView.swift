//
//  TopFreeAppView.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/16/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import UIKit

final class TopFreeAppView: UITableView {

    static let reuseIdentifier = "TopFreeAppViewCell"
    static let reuseIdHeader = "AppHeaderView"

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: CGRect.zero, style: .grouped)

        register(UINib(nibName: TopFreeAppView.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: TopFreeAppView.reuseIdentifier)
        
        register(UINib(nibName: TopFreeAppView.reuseIdHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: TopFreeAppView.reuseIdHeader)
    }
}
