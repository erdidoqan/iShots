//
//  ShotZoomController.swift
//  iShots
//
//  Created by Tope Abayomi on 05/01/2015.
//  Copyright (c) 2015 App Design Vault. All rights reserved.
//

import Foundation
import UIKit

class ShotZoomController : UIViewController {
    
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var shotImageView : UIImageView!
    @IBOutlet var descriptionLabel : UILabel!
    
    var shot : Shot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.text = shot.description
        
        if let imageData = shot.imageData {
            
            let image = UIImage(data: imageData)
            shotImageView.image = UIImage(data: imageData)
            //shotImageView.bounds = CGRectMake(0, 0, image?.size.width, image?.size.height);
        }
        
        
        scrollView.contentSize = shotImageView.frame.size
    }
}