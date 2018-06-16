//
//  GrossingAppView.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/16/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import UIKit

final class GrossingAppView: UICollectionView {
    
    static let reuseIdentifier = "GrossingAppViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        let grossingAppLayout = UICollectionViewFlowLayout()
        grossingAppLayout.scrollDirection = .horizontal
        grossingAppLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        grossingAppLayout.estimatedItemSize = CGSize(width: 150, height: 200)
        
        super.init(frame: CGRect.zero, collectionViewLayout: grossingAppLayout)
        
        backgroundColor = UIColor.clear
        showsHorizontalScrollIndicator = false
        register(UINib(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: GrossingAppView.reuseIdentifier)
    }
    
}
