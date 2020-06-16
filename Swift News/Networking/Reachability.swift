//
//  Reachability.swift
//  Swift News
//
//  Created by Harsh Shah on 2020-06-16.
//  Copyright © 2020 Pineapple Inc. All rights reserved.
//

import Foundation
import Reachability

//Reachability
//declare this property where it won't go out of scope relative to your listener
fileprivate var reachability: Reachability!

protocol ReachabilityActionDelegate {
    func reachabilityChanged(_ isReachable: Bool)
}

protocol ReachabilityObserverDelegate: class, ReachabilityActionDelegate {
    func addReachabilityObserver() throws
    func removeReachabilityObserver()
}

// Declaring default implementation of adding/removing observer
extension ReachabilityObserverDelegate {
    
    /** Subscribe on reachability changing */
    func addReachabilityObserver() throws {
        reachability = try Reachability()
        
        reachability.whenReachable = { [weak self] reachability in
            self?.reachabilityChanged(true)
        }
        
        reachability.whenUnreachable = { [weak self] reachability in
            self?.reachabilityChanged(false)
        }
        
        try reachability.startNotifier()
    }
    
    /** Unsubscribe */
    func removeReachabilityObserver() {
        reachability.stopNotifier()
        reachability = nil
    }
}



class ReachabilityHandler: ReachabilityObserverDelegate {
  
  //MARK: Lifecycle
  
    var rechabilityStatus : Bool{
        get{
          return reachability.connection != .unavailable
        }
    }
    
  required init() {
    try? addReachabilityObserver()
  }
  
  deinit {
    removeReachabilityObserver()
  }
  
  //MARK: Reachability
    
  func reachabilityChanged(_ isReachable: Bool) {
    if !isReachable {
        print("No internet connection")
        //comment to allow access when internet is not on
       // showNoInternetAlert()
    }
}
    
    func showNoInternetAlert(){
        let alertController = UIAlertController(title: "No internet connection", message: "Please connect to the network", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Retry", style: .default) { (action) in
            if  reachability.connection == .unavailable{
                self.showNoInternetAlert()
            }
        }
        alertController.addAction(alertAction)
        if let vc = UIApplication.getTopViewController(){
            vc.navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
}


var rechabilityManager : ReachabilityHandler? = ReachabilityHandler()
