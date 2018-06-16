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

final class ViewController: UIViewController {

    let disposeBag = DisposeBag()

    private let vm = MainViewModel()
    private lazy var searchBar = UISearchBar()
    private lazy var scrollView = UIScrollView()

    private lazy var grossingAppLayout = UICollectionViewFlowLayout()
    private var grossingAppView: UICollectionView!
    fileprivate let reuseIdentifier = "GrossingAppCell"

    private var topFreeAppView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindUI()
        vm.fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func initUI() {
        view.backgroundColor = UIColor.white

        // init SearchBar
        navigationItem.titleView = searchBar
        searchBar.placeholder = locale("search_placeholder")

        // init Scroll View
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.edges.equalToSuperview()
        }
//        scrollView.backgroundColor = UIColor.brown

        // init Grossing App
        grossingAppLayout.scrollDirection = .horizontal
        grossingAppLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        grossingAppView = UICollectionView(frame: CGRect.zero, collectionViewLayout: grossingAppLayout)
        grossingAppView.backgroundColor = UIColor.clear
        grossingAppView.delegate = self
        grossingAppView.dataSource = self
        grossingAppView.register(GrossingAppViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        grossingAppView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(grossingAppView)

        grossingAppView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(100)
        }

        topFreeAppView = UITableView(frame: CGRect.zero)
//        topFreeAppView.backgroundColor = UIColor.blue
        scrollView.addSubview(topFreeAppView)

        topFreeAppView.snp.makeConstraints {
            $0.top.equalTo(grossingAppView.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }

    private func bindUI() {
        hideKeyboardWhenTappedAround()

        vm.sIsLoading
            .subscribe(onNext: onIsLoading)
            .disposed(by: disposeBag)

        vm.sError
            .subscribe(onNext: onError)
            .disposed(by: disposeBag)

        vm.sGotGrossingApp
            .subscribe(onNext: onGotGrossingApp)
            .disposed(by: disposeBag)
    }

    private func onIsLoading(value: Bool) {
        // TODO: show loading
    }

    private func onError(error: Error) {
        // TODO: show error
    }

    private func onGotGrossingApp() {
        grossingAppView.reloadData()
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.getGrossingAppCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath)
        
        cell.backgroundColor = UIColor.black
        cell.setNeedsLayout()
        
        return cell
    }

}

