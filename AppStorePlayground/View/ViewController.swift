//
//  ViewController.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/13/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {

    private let vm = MainViewModel()
    private lazy var searchBar = UISearchBar()
    private lazy var scrollView = UIScrollView()
    
    private lazy var grossingAppLayout = UICollectionViewFlowLayout()
    private var grossingAppView: UICollectionView!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        scrollView.backgroundColor = UIColor.brown
        
        // init Grossing App
        grossingAppLayout.scrollDirection = .horizontal
        grossingAppView = UICollectionView(frame: CGRect.zero, collectionViewLayout: grossingAppLayout)
        grossingAppView.backgroundColor = UIColor.red
        scrollView.addSubview(grossingAppView)
        
        grossingAppView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        topFreeAppView = UITableView(frame: CGRect.zero)
        topFreeAppView.backgroundColor = UIColor.blue
        scrollView.addSubview(topFreeAppView)
        
        topFreeAppView.snp.makeConstraints {
            $0.top.equalTo(grossingAppView.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
    
    private func bindUI() {
        hideKeyboardWhenTappedAround()
    }

}

