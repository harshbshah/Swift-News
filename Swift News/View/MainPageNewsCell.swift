//
//  MainPageNewsCell.swift
//  Swift News
//
//  Created by Harsh Shah on 2020-06-16.
//  Copyright © 2020 Pineapple Inc. All rights reserved.
//

import UIKit


class MainPageNewsCell: UITableViewCell {
    
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thumbnailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var wrapperView: UIView!
   
    @IBOutlet weak var titleLabel: UILabel!
 
    @IBOutlet weak var newsThumbnail: UIImageView!
    var thumbnailImage:UIImage?
    var imageRemoved:Bool = false
    var isCellLoaded:Bool = false
    var singleNewsObject: NewsFeedModel?
    {
        didSet
        {
            updateCell(self.singleNewsObject)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.isCellLoaded = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(_ obj : NewsFeedModel?)
    {
        DispatchQueue.main.async {
                        if let obj = obj
                        {
                        self.applyShadow()
                        
                        self.titleLabel.text = obj.articleTitle
                        self.getThumbnail(obj)
                        }
            
        
                    }
        
    }
    
    
}
// MARK: UI functions
extension MainPageNewsCell{
    func getThumbnail(_ obj: NewsFeedModel)
    {
        guard let thumbURL = obj.articleThumbUrl
            else{
                self.thumbnailImage = nil
                self.updateThumbnail()
                
                return
        }
        guard let url = URL.init(string: thumbURL)
        else{
            self.thumbnailImage = nil
            self.updateThumbnail()
            
            return
        }
        MTAPIClient.downloadImage(url: url, completion: {
            (image,error) in
            if let image = image
            {
                self.thumbnailImage = image
                self.updateThumbnail()
            }
        })
    }
    func applyShadow()
    {
        self.wrapperView.layer.cornerRadius = 5
                                   self.wrapperView.layer.shadowOpacity = 1
                                   self.wrapperView.layer.shadowColor = UIColor.lightGray.cgColor
                                   self.wrapperView.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    func updateThumbnail()
    {
        if let image = thumbnailImage
        {
            DispatchQueue.main.async {
                self.newsThumbnail.isHidden = false
                self.newsThumbnail.image = image
                 self.titleHeightConstraint = self.titleHeightConstraint.setMultiplier(multiplier: 0.4)
                self.thumbnailHeightConstraint.constant = self.frame.size.getimageAspectRatioHeightAccordingToWidth(imageSize: CGSize.init(width: self.singleNewsObject?.articleThumbnailbWidth ?? 0, height: self.singleNewsObject?.articleThumbnailHeight ?? 0))
                
                
            }
            
        }
        else
        {
            DispatchQueue.main.async {
                self.newsThumbnail.isHidden = true
                self.thumbnailHeightConstraint.constant = 0
                self.titleHeightConstraint = self.titleHeightConstraint.setMultiplier(multiplier: 1.0)
                
            }
        }
    }
}

