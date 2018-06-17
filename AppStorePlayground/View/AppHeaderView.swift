//
//  AppHeaderView.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/17/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import UIKit
import RxSwift

final class AppHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var lbTitle: UILabel!
    private lazy var activityIndicator = UIActivityIndicatorView()

    private let disposeBag = DisposeBag()
    private let kGrossingAppHeight = CGFloat(200)
    private var topGrossingAppView: TopGrossingAppView!
    private var vm = AppHeaderViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        print("AppHeaderView::awakeFromNib")
        initUI()
        bindUI()
        vm.fetchData()
    }

    private func initUI() {
        lbTitle.text = locale("recommend")

        // init grossing app collection view
        topGrossingAppView = TopGrossingAppView()
        topGrossingAppView.delegate = self
        topGrossingAppView.dataSource = self
        self.addSubview(topGrossingAppView)

        topGrossingAppView.snp.makeConstraints {
            $0.top.equalTo(lbTitle.snp.bottom).offset(8)
            $0.left.right.width.equalToSuperview()
            $0.height.equalTo(kGrossingAppHeight)
        }
        
        // init activity indicator
        addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.startAnimating()
    }

    private func bindUI() {
        vm.sIsLoading
            .subscribe(onNext: onIsLoading)
            .disposed(by: disposeBag)

        vm.sError
            .subscribe(onNext: onError)
            .disposed(by: disposeBag)

        vm.sGotTopGrossingApp
            .subscribe(onNext: onGotTopGrossingApp)
            .disposed(by: disposeBag)
    }

    private func onGotTopGrossingApp() {
        topGrossingAppView.reloadData()
    }
    
    private func onIsLoading(value: Bool) {
        if value {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func onError(error: Error) {
        DialogUtils.show(error.localizedDescription)
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

        if let entry = vm.topGrossingAppModel?.entries?[indexPath.row] {
            cell.lbName.text = entry.name
            cell.lbCategory.text = entry.category
            cell.ivImage.af_setImage(withURL: URL(string: entry.image100!)!)

            cell.setNeedsLayout()
        }

        return cell
    }
}
