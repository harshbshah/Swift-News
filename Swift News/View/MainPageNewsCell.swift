//
//  MainPageNewsCell.swift
//  Swift News
//
//  Created by Harsh Shah on 2020-06-16.
//  Copyright © 2020 Pineapple Inc. All rights reserved.
//

import UIKit


class MainPageNewsCell: UITableViewCell {
    
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet weak var imageThumbnailWidth: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var newsThumbnail: UIImageView!
    var thumbnailImage:UIImage?
    var isCellLoaded:Bool = false
    var singleNewsObject: NewsFeedModel?
    {
        didSet
        {
            //update cell
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
                           
                        self.bodyLabel.text = obj.articleBody
                         self.titleLabel.text = obj.articleTitle
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
            
        
                    }
        
    }
    func updateThumbnail()
    {
        if let image = thumbnailImage
        {
            DispatchQueue.main.async {
                self.newsThumbnail.image = image
                self.imageThumbnailWidth = self.imageThumbnailWidth.setMultiplier(multiplier: 0.4)
                
            }
            
        }
        else
        {
            DispatchQueue.main.async {
                self.newsThumbnail.image = UIImage.init(named: Defaults.defaultThumbnailImage)
                 self.imageThumbnailWidth = self.imageThumbnailWidth.setMultiplier(multiplier: 0.04)
            }
        }
    }
    
}

