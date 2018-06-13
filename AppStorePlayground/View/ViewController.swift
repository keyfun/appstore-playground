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
//        vm.fetchData()
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
        let grossingAppFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        grossingAppLayout.scrollDirection = .horizontal
        grossingAppView = UICollectionView(frame: grossingAppFrame, collectionViewLayout: grossingAppLayout)
        grossingAppView.backgroundColor = UIColor.red
        scrollView.addSubview(grossingAppView)
        
        // TODO: init Top Free App
        let offset = CGFloat(20)
        let ty = grossingAppFrame.height + offset
        let th = view.frame.height - ty - 300
        let topFreeAppFrame = CGRect(x: 0, y: ty, width: view.frame.width, height: th)
        topFreeAppView = UITableView(frame: topFreeAppFrame)
        topFreeAppView.backgroundColor = UIColor.blue
        scrollView.addSubview(topFreeAppView)
        print(topFreeAppView.frame)
    }
    
    private func bindUI() {
        hideKeyboardWhenTappedAround()
    }

}

