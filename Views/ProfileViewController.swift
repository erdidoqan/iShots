//
//  ProfileViewController.swift
//  iShots
//
//  Created by Tope Abayomi on 20/11/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var bgImageView : UIImageView!
    @IBOutlet var profileImageView : UIImageView!
    
    @IBOutlet var profileContainer : UIView!
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var locationLabel : UILabel!
    @IBOutlet var locationImageView : UIImageView!
    
    @IBOutlet var followersLabel : UILabel!
    @IBOutlet var followersCount : UILabel!
    @IBOutlet var followingLabel : UILabel!
    @IBOutlet var followingCount : UILabel!
    @IBOutlet var photosLabel : UILabel!
    @IBOutlet var photosCount : UILabel!
    
    @IBOutlet var checkinsLabel : UILabel!
    @IBOutlet var friendsLabel : UILabel!
    
    @IBOutlet var photosContainer : UIView!
    @IBOutlet var photosCollectionLabel : UILabel!
    @IBOutlet var photosCollectionView : UICollectionView!
    @IBOutlet var photosLayout : UICollectionViewFlowLayout!
    
    @IBOutlet var friendsCollectionLabel : UILabel!
    @IBOutlet var friendsCollectionView : UICollectionView!
    @IBOutlet var friendsLayout : UICollectionViewFlowLayout!
    
    var user : User!
    var shots = [Shot]()
    var followingUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        
        if let avatarData = user.avatarData {
            profileImageView.image = UIImage(data: avatarData)
            bgImageView.image = UIImage(data: avatarData)
        }else{
            Utils.asyncLoadUserImage(user, imageView: profileImageView)
        }
        
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        
        nameLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.text = user.name
        
        locationLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.text = user.location
        
        locationImageView.image = UIImage(named: "location")
        
        let statsCountFontSize : CGFloat = 16
        let statsLabelFontSize : CGFloat = 12
        let statsCountColor = UIColor.whiteColor()
        let statsLabelColor = UIColor(white: 0.7, alpha: 1.0)
        
        followingCount.font = UIFont(name: MegaTheme.boldFontName, size: statsCountFontSize)
        followingCount.textColor = statsCountColor
        followingCount.text = "\(user.followingCount)"
        
        followingLabel.font = UIFont(name: MegaTheme.fontName, size: statsLabelFontSize)
        followingLabel.textColor = statsLabelColor
        followingLabel.text = "FOLLOWING"
        
        followersCount.font = UIFont(name: MegaTheme.boldFontName, size: statsCountFontSize)
        followersCount.textColor = statsCountColor
        followersCount.text = "\(user.followersCount)"
        
        followersLabel.font = UIFont(name: MegaTheme.fontName, size: statsLabelFontSize)
        followersLabel.textColor = statsLabelColor
        followersLabel.text = "FOLLOWERS"
        
        photosCount.font = UIFont(name: MegaTheme.boldFontName, size: statsCountFontSize)
        photosCount.textColor = statsCountColor
        photosCount.text = "\(user.shotsCount)"
        
        photosLabel.font = UIFont(name: MegaTheme.fontName, size: statsLabelFontSize)
        photosLabel.textColor = statsLabelColor
        photosLabel.text = "SHOTS"
        
        addBlurView()
        
        photosCollectionLabel.font = UIFont(name: MegaTheme.boldFontName, size: 14)
        photosCollectionLabel.textColor = UIColor.blackColor()
        photosCollectionLabel.text = "MY OTHER SHOTS"
        
        photosContainer.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.backgroundColor = UIColor.clearColor()
        
        photosLayout.itemSize = CGSizeMake(90, 90)
        photosLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        photosLayout.minimumInteritemSpacing = 5
        photosLayout.minimumLineSpacing = 10
        photosLayout.scrollDirection = .Horizontal
        
        let api = DribbbleAPI()
        api.loadShots(user.shotsUrl, completion: didLoadShots)
        api.loadUsers(user.followingUrl, completion: didLoadUsers)
        
        friendsCollectionLabel.font = UIFont(name: MegaTheme.boldFontName, size: 14)
        friendsCollectionLabel.textColor = UIColor.blackColor()
        friendsCollectionLabel.text = "I FOLLOW THESE PEOPLE"
        
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        friendsCollectionView.backgroundColor = UIColor.clearColor()
        
        friendsLayout.itemSize = CGSizeMake(45, 45)
        friendsLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        friendsLayout.minimumInteritemSpacing = 5
        friendsLayout.minimumLineSpacing = 10
        friendsLayout.scrollDirection = .Horizontal
    }
    
    func didLoadShots(shots: [Shot]){
        self.shots = shots
        photosCollectionView.reloadData()
    }
    
    func didLoadUsers(users: [User]){
        self.followingUsers = users
        friendsCollectionView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            return 250
        }else if indexPath.row == 1 {
            return 400
        }else if indexPath.row == 2 {
            return 100
        }else{
            return 44
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == photosCollectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
            
            let imageView = cell.viewWithTag(1) as UIImageView
            let shot = shots[indexPath.row]
            
            if let data = shot.imageData {
                imageView.image = UIImage(data: data)
            }else{
                Utils.asyncLoadShotImage(shot, imageView: imageView)
            }

            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
            
            let imageView = cell.viewWithTag(1) as UIImageView
            imageView.layer.cornerRadius = 20
            
            let user = followingUsers[indexPath.row]
            
            if let data = user.avatarData {
                imageView.image = UIImage(data: data)
            }else{
                Utils.asyncLoadUserImage(user, imageView: imageView)
            }

            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == photosCollectionView {
            return shots.count
        }else{
            return followingUsers.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == photosCollectionView {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("ShotDetailController") as ShotDetailController
            
            let selectedItems = photosCollectionView.indexPathsForSelectedItems() as [NSIndexPath]
            let seletedIndexPath = selectedItems[0]
            
            let shot = shots[seletedIndexPath.row]

            shot.user = user
            controller.shot = shot
            
            self.navigationController?.pushViewController(controller, animated: true)
           
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
            
            let selectedItems = friendsCollectionView.indexPathsForSelectedItems() as [NSIndexPath]
            let seletedIndexPath = selectedItems[0]
            
            let user = followingUsers[seletedIndexPath.row]
            controller.user = user
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func addBlurView(){
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, 600, 100)
        
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        profileContainer.insertSubview(blurView, aboveSubview: bgImageView)
        
        let topConstraint = NSLayoutConstraint(item: profileContainer, attribute: .Top, relatedBy: .Equal, toItem: blurView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        
        let bottomConstraint = NSLayoutConstraint(item: profileContainer, attribute: .Bottom, relatedBy: .Equal, toItem: blurView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        
        let leftConstraint = NSLayoutConstraint(item: profileContainer, attribute: .Left, relatedBy: .Equal, toItem: blurView, attribute: .Left, multiplier: 1.0, constant: 0.0)
        
        let rightConstraint = NSLayoutConstraint(item: profileContainer, attribute: .Right, relatedBy: .Equal, toItem: blurView, attribute: .Right, multiplier: 1.0, constant: 0.0)
        
        self.profileContainer.addConstraints([topConstraint, rightConstraint, leftConstraint, bottomConstraint])
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    @IBAction func doneTapped(sender: AnyObject?){
        dismissViewControllerAnimated(true, completion: nil)
    }
}