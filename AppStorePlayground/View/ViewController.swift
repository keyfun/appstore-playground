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
    private lazy var scrollView = UIScrollView()

    private var topGrossingAppView: TopGrossingAppView!
    private var topFreeAppView: UITableView!
    
    let placeholderWidth = CGFloat(100) // Fix Size
    var offset = UIOffset()

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

        // init Scroll View
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        // init Grossing App
        topGrossingAppView = TopGrossingAppView()
        topGrossingAppView.delegate = self
        topGrossingAppView.dataSource = self
        scrollView.addSubview(topGrossingAppView)

        topGrossingAppView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(200)
        }

        // init Top Free App
        topFreeAppView = UITableView(frame: CGRect.zero)
        scrollView.addSubview(topFreeAppView)

        topFreeAppView.snp.makeConstraints {
            $0.top.equalTo(topGrossingAppView.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
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
        topGrossingAppView.reloadData()
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

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {

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
            cell.ivImage.af_setImage(withURL: URL(string: entry.image!)!)

            cell.setNeedsLayout()
        }

        return cell
    }

}

