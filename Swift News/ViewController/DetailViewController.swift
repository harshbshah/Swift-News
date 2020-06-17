//
//  DetailViewController.swift
//  Swift News
//
//  Created by Harsh Shah on 2020-06-16.
//  Copyright © 2020 Pineapple Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var noDesriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var detailsTextView: UITextView!
    var newsFeedModel:NewsFeedModel?
    var coverImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    
    }
    
    func setupUI()
    {
        DispatchQueue.main.async {
            if(self.newsFeedModel?.articleBody == "")
        {
            
                
            
            self.noDesriptionLabel.text = Defaults.defaultNoDescriptioText
                self.detailsTextView.isHidden = true
            
        }
        else{
            self.detailsTextView.text = self.newsFeedModel?.articleBody
        }
        }
        setupCoverImage()
        setupGradient()
        navigationItem.title = newsFeedModel?.articleTitle

        
    }
    
}

// MARK: UIFunctions
extension DetailViewController{
    func setupGradient()
     {
         DispatchQueue.main.async {
             let gradient = CAGradientLayer()
             let startColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.02803938356)
             let endColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4023972603)
             gradient.frame = self.gradientView.bounds
             gradient.colors = [startColor.cgColor, endColor.cgColor]

             self.gradientView.layer.insertSublayer(gradient, at: 0)
         }
     }
     func setupCoverImage()
     {
         guard let thumbURL = newsFeedModel?.articleImageURL
             else{
                 self.coverImage = nil
                 self.updateCoverImage()
                 
                 return
         }
         guard let url = URL.init(string: thumbURL)
         else{
             self.coverImage = nil
             self.updateCoverImage()
             
             return
         }
         MTAPIClient.downloadImage(url: url, completion: {
             (image,error) in
             if let image = image
             {
                 self.coverImage = image
                 self.updateCoverImage()
             }
         })
     }
    func updateCoverImage()
    {
     if let image = coverImage
     {
         DispatchQueue.main.async {
             
             self.coverImageView.image = image
             //show gradient
             //show title
         }
         
     }
     else
     {
         DispatchQueue.main.async {
             self.coverImageView.image = UIImage.init(named: Defaults.defaultThumbnailImage)
              //hide Gradient
             
             //show title
         }
     }
     }

}
