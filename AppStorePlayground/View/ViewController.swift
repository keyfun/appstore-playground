//
//  ViewController.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/13/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import AlamofireImage

final class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let vm = MainViewModel()
    private lazy var searchBar = UISearchBar()
    private lazy var activityIndicator = UIActivityIndicatorView()

    private var topGrossingAppView: TopGrossingAppView!
    private var topFreeAppView: TopFreeAppView!

    // for search bar
    let placeholderWidth = CGFloat(100) // Fix Size
    var offset = UIOffset()

    var headerView: AppHeaderView?

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindUI()
        vm.fetchData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        offset = UIOffset(horizontal: (size.width - placeholderWidth) / 2, vertical: 0)
        searchBar.setPositionAdjustment(offset, for: .search)
    }

    private func initUI() {
        view.backgroundColor = UIColor.white

        // init SearchBar
        navigationItem.titleView = searchBar
        searchBar.placeholder = locale("search_placeholder")
        // align placeholder to center
        offset = UIOffset(horizontal: (view.frame.width - placeholderWidth) / 2, vertical: 0)
        searchBar.setPositionAdjustment(offset, for: .search)
        searchBar.delegate = self

        // init Top Free App
        topFreeAppView = TopFreeAppView()
        topFreeAppView.delegate = self
        topFreeAppView.dataSource = self
        topFreeAppView.backgroundColor = UIColor.clear
        view.addSubview(topFreeAppView)

        topFreeAppView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
            $0.width.height.equalToSuperview()
        }

        // init activity indicator
        view.addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }

        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.startAnimating()
    }

    private func bindUI() {
        hideKeyboardWhenTappedAround()

        vm.sIsLoading
            .subscribe(onNext: onIsLoading)
            .disposed(by: disposeBag)

        vm.sError
            .subscribe(onNext: onError)
            .disposed(by: disposeBag)

        vm.sGotTopGrossingApp
            .subscribe(onNext: onGotTopGrossingApp)
            .disposed(by: disposeBag)

        vm.sGotTopFreeApp
            .subscribe(onNext: onGotTopFreeApp)
            .disposed(by: disposeBag)
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

    private func onGotTopGrossingApp() {
        headerView?.reloadData()
    }

    private func onGotTopFreeApp() {
        topFreeAppView.reloadData()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let noOffset = UIOffset(horizontal: 0, vertical: 0)
        searchBar.setPositionAdjustment(noOffset, for: .search)
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setPositionAdjustment(offset, for: .search)
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TopFreeAppView.reuseIdHeader) as? AppHeaderView
        headerView?.setData(vm)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getTopFreeAppCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TopFreeAppView.reuseIdentifier,
            for: indexPath) as! TopFreeAppViewCell

        if let entry = vm.topFreeAppModel?.entries?[indexPath.item] {
            cell.lbName.text = entry.name
            cell.lbCategory.text = entry.category
            cell.ivImage.af_setImage(withURL: URL(string: entry.image75!)!)
            cell.update(index: indexPath.item)
            cell.setCount(entry.userRatingCount ?? 0)
            cell.setRating(entry.averageUserRating ?? 0)
        }

        return cell
    }
}

