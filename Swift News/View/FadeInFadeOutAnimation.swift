//
//  FadeInFadeOutAnimation.swift
//  Swift News
//
//  Created by Harsh Shah on 2020-06-16.
//  Copyright © 2020 Pineapple Inc. All rights reserved.
//

import Foundation
import UIKit

class FadeInOutLoadingAnimation {
    
    private static var loadingView : UIView!
    private static var loadingIconFileName = Defaults.loadingIcon
    private static var animationCompletionFlag : Bool = false
    private static var alreadyOnScreen : Bool = false
    
    private static var loadingIcon = UIImageView(image: UIImage(named: loadingIconFileName))
    
    static func createContent(superview: UIView) {
        if alreadyOnScreen{
            return
        }
        
        animationCompletionFlag = false
        
        // let
        loadingView = UIView.init(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        loadingView.backgroundColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        loadingView.alpha = 0.9
        
        
        
        loadingView.layer.masksToBounds = true
        loadingView.layer.cornerRadius = 10
        
        if !animationCompletionFlag{
            loadingView.addSubview(loadingIcon)
            superview.addSubview(loadingView)
        }
        
        loadingIcon.translatesAutoresizingMaskIntoConstraints = false
        loadingIcon.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        loadingIcon.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        loadingIcon.heightAnchor.constraint(equalToConstant: 56).isActive = true
        loadingIcon.widthAnchor.constraint(equalToConstant: 67.83).isActive = true
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: -40).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        //self.loadingView = loadingView
        startAnimation(image: &loadingIcon)
        
        alreadyOnScreen = true
        print("add animation")
    }
    
    private static func startAnimation(image: inout UIImageView) {
        fadeOut(image: &image)
    }
    
    private static func fadeOut(image: inout UIImageView) {
        UIView.animate(withDuration: 1.0, animations: { [weak image] in
            guard let image = image else { return }
            image.alpha = 0.0
        }) { [weak image](_) in
            guard var image = image else { return }
            self.fadeIn(image: &image)
        }
    }
    
    private static func fadeIn(image: inout UIImageView) {
        UIView.animate(withDuration: 1.0, animations: { [weak image] in
            guard let image = image else { return }
            image.alpha = 1.0
        }) { [weak image] (_) in
            guard var image = image else { return }
            self.fadeOut(image: &image)
        }
    }
    
    static func removeContent() {
        animationCompletionFlag = true
        alreadyOnScreen = false
        self.loadingIcon.removeFromSuperview()
        self.loadingView?.removeFromSuperview()
        self.loadingView?.layer.removeAllAnimations()
        self.loadingView?.layoutIfNeeded()
        self.loadingView = nil
        print("remove animation")
    }
}
