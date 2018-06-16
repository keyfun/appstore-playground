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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: CGRect.zero, style: .plain)

        register(UINib(nibName: "TopFreeAppViewCell", bundle: nil),
            forCellReuseIdentifier: TopFreeAppView.reuseIdentifier)
    }
}
