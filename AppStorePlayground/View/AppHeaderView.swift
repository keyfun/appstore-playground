//
//  AppHeaderView.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/17/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import UIKit

final class AppHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var lbTitle: UILabel!

    var topGrossingAppView: TopGrossingAppView!
    let kGrossingAppHeight = CGFloat(200)

    var vm = MainViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        print("AppHeaderView::awakeFromNib")
        lbTitle.text = locale("recommend")
        addTopGrossingAppView()
    }

    func addTopGrossingAppView() {
        topGrossingAppView = TopGrossingAppView()
        topGrossingAppView.delegate = self
        topGrossingAppView.dataSource = self
        self.addSubview(topGrossingAppView)

        topGrossingAppView.snp.makeConstraints {
            $0.top.equalTo(lbTitle.snp.bottom).offset(8)
            $0.left.right.width.equalToSuperview()
            $0.height.equalTo(kGrossingAppHeight)
        }
    }

    func setData(_ vm: MainViewModel) {
        self.vm = vm
        reloadData()
    }

    func reloadData() {
        topGrossingAppView.reloadData()
    }

}

extension AppHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.getGrossingAppCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TopGrossingAppView.reuseIdentifier,
            for: indexPath) as! TopGrossingAppViewCell

        if let entry = vm.topGrossingAppModel?.entries?[indexPath.item] {
            cell.lbName.text = entry.name
            cell.lbCategory.text = entry.category
            cell.ivImage.af_setImage(withURL: URL(string: entry.image100!)!)

            cell.setNeedsLayout()
        }

        return cell
    }
}
