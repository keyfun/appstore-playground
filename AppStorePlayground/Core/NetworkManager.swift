//
//  NetworkManager.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/17/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import Foundation
import Reachability

final class NetworkManager: NSObject {

    static let shared = NetworkManager()
    fileprivate var reachability: Reachability?
    fileprivate var isStarted = false

    var status = Reachability.Connection.none

    override init() {
        super.init()
        self.reachability = Reachability()
        if let connection = reachability?.connection {
            status = connection
        }
        print("[NetworkManager] init: \(status.description)")
    }

    func startMonitoring() {
        if(isStarted) {
            return
        }
        isStarted = true

        NotificationCenter.default.addObserver(self,
            selector: #selector(NetworkManager.reachabilityChanged),
            name: Notification.Name.reachabilityChanged,
            object: reachability)

        do {
            try reachability?.startNotifier()
        } catch {
            print("[NetworkManager] Unable to start notifier")
        }
    }

    func stoptMonitoring() {
        isStarted = false
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self,
            name: Notification.Name.reachabilityChanged,
            object: reachability)
    }

    func hasNetwork() -> Bool {
        return status != .none
    }

    @objc private func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        status = reachability.connection
        print("[NetworkManager] reachabilityChanged: \(status.description)")
    }
}

