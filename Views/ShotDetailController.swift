//
//  ShotDetailController.swift
//  iShots
//
//  Created by Tope Abayomi on 03/01/2015.
//  Copyright (c) 2015 App Design Vault. All rights reserved.
//

import Foundation
import UIKit

class ShotDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var topImageView : UIImageView!
    @IBOutlet var topGradientView : UIView!
    @IBOutlet var dateImageView : UIImageView!
    
    @IBOutlet var backbutton : UIButton!
    
    @IBOutlet var profileImageView : UIImageView!
    @IBOutlet var nameLabel : UILabel!
    
    @IBOutlet var descriptionLabel : UILabel!
    @IBOutlet var commentTableView : UITableView!
    
    @IBOutlet var viewsCount : UILabel!
    @IBOutlet var viewsLabel : UILabel!
    @IBOutlet var likesCount : UILabel!
    @IBOutlet var likesLabel : UILabel!
    @IBOutlet var commentsCount : UILabel!
    @IBOutlet var commentsLabel : UILabel!
    
    @IBOutlet var topImageViewHeightConstraint : NSLayoutConstraint!
 
    var shot : Shot!
    var comments : [Comment] = [Comment]()
    
    var photos : [String]!
    
    var transitionOperator = TransitionOperator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = shot.title
        
        titleLabel.font = UIFont(name: MegaTheme.fontName, size: 21)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = shot.title
        
        dateLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.text = shot.date
        
        dateImageView.image = UIImage(named: "clock")?.imageWithRenderingMode(.AlwaysTemplate)
        dateImageView.tintColor = UIColor.whiteColor()
        
        
        if let imageData = shot.imageData {
            topImageView.image = UIImage(data: imageData)
        }else{
            Utils.asyncLoadShotImage(shot, imageView: topImageView)
        }
        topImageViewHeightConstraint.constant = 240
        
        nameLabel.font = UIFont(name: MegaTheme.fontName, size: 16)
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.text = "by \(shot.user.name)"
        
        Utils.asyncLoadUserImage(shot.user, imageView: profileImageView)
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true
        
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "profileTapped")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        nameLabel.userInteractionEnabled = true
        nameLabel.addGestureRecognizer(tapGesture)
        
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        let statsCountFontSize : CGFloat = 16
        let statsLabelFontSize : CGFloat = 12
        let statsCountColor = UIColor(red: 0.32, green: 0.61, blue: 0.94, alpha: 1.0)
        let statsLabelColor = UIColor(white: 0.7, alpha: 1.0)
        
        viewsCount.font = UIFont(name: MegaTheme.boldFontName, size: statsCountFontSize)
        viewsCount.textColor = statsCountColor
        viewsCount.text = "\(shot.viewsCount)"
        
        viewsLabel.font = UIFont(name: MegaTheme.fontName, size: statsLabelFontSize)
        viewsLabel.textColor = statsLabelColor
        viewsLabel.text = "VIEWS"
        
        likesCount.font = UIFont(name: MegaTheme.boldFontName, size: statsCountFontSize)
        likesCount.textColor = statsCountColor
        likesCount.text = "\(shot.likesCount)"
        
        likesLabel.font = UIFont(name: MegaTheme.fontName, size: statsLabelFontSize)
        likesLabel.textColor = statsLabelColor
        likesLabel.text = "LIKES"
        
        commentsCount.font = UIFont(name: MegaTheme.boldFontName, size: statsCountFontSize)
        commentsCount.textColor = statsCountColor
        commentsCount.text = "\(shot.commentCount)"
        
        commentsLabel.font = UIFont(name: MegaTheme.fontName, size: statsLabelFontSize)
        commentsLabel.textColor = statsLabelColor
        commentsLabel.text = "COMMENTS"
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.estimatedRowHeight = 100.0;
        commentTableView.rowHeight = UITableViewAutomaticDimension;
        
        let api = DribbbleAPI()
        api.loadComments(shot.commentUrl, completion: didLoadComments)
        
        var tapGestureZoom = UITapGestureRecognizer(target: self, action: "zoomShot:")
        tapGestureZoom.numberOfTapsRequired = 1
        tapGestureZoom.numberOfTouchesRequired = 1
        topImageView.userInteractionEnabled = true
        topImageView.addGestureRecognizer(tapGestureZoom)
        
    }
    
    func didLoadComments(comments: [Comment]){
        self.comments = comments
        commentTableView.reloadData()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addShotGradient()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as CommentCell
        
        let comment = comments[indexPath.row]
        
        cell.nameLabel.text = comment.user.name
        cell.postLabel?.text = comment.body
        cell.dateLabel.text = comment.date
        
        Utils.asyncLoadUserImage(comment.user, imageView: cell.profileImageView)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }

    func backTapped(sender: AnyObject?){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addShotGradient(){
    
        topGradientView.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0, 0, 1000, 90)
        gradientLayer.colors = [UIColor(white: 0.0, alpha: 0.0).CGColor, UIColor(white: 0.0, alpha: 0.5).CGColor]
        
        self.topGradientView.layer.addSublayer(gradientLayer)
    }
    
    func profileTapped(){
        performSegueWithIdentifier("profile", sender: self)
    }
    
    @IBAction func zoomShot(sender: AnyObject?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("ShotZoomController") as ShotZoomController
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        controller.transitioningDelegate = transitionOperator
        controller.shot = shot
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profile" {
            var controller = segue.destinationViewController as ProfileViewController
            
            controller.user = shot.user
        }
    }
}
