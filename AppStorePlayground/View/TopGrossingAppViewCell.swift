//
//  TopGrossingAppViewCell.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/16/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import UIKit

final class TopGrossingAppViewCell: UICollectionViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var ivImage: UIImageView!

    private var lbNameFrame: CGRect!

    override func awakeFromNib() {
        super.awakeFromNib()
        ivImage.layer.cornerRadius = 16.0
        ivImage.clipsToBounds = true
        lbNameFrame = lbName.frame
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // align label text to top center
        lbName.frame = lbNameFrame
        lbName.sizeToFit()
        let newFrame = lbName.frame
        lbName.frame = CGRect(
            x: lbNameFrame.origin.x,
            y: newFrame.origin.y,
            width: lbNameFrame.width,
            height: newFrame.height)
    }

    func update(entry: Entry) {
        lbName.text = entry.name
        lbCategory.text = entry.categoryLabel
        ivImage.af_setImage(withURL: URL(string: entry.image100!)!)
        setNeedsLayout()
    }

}
