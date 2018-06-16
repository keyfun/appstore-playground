//
//  TopFreeAppViewCell.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/16/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import UIKit

final class TopFreeAppViewCell: UITableViewCell {
    
    @IBOutlet weak var lbOrder: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var vRating: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivImage.clipsToBounds = true
    }
    
    func update(index: Int) {
        lbOrder.text = "\(index + 1)"
        
        if index % 2 == 0 {
            ivImage.layer.cornerRadius = 16.0
        } else {
            ivImage.layer.cornerRadius = ivImage.frame.width / 2
        }
    }
    
}
