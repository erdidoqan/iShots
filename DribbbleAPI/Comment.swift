//
//  Comment.swift
//  iShots
//
//  Created by Tope Abayomi on 04/01/2015.
//  Copyright (c) 2015 App Design Vault. All rights reserved.
//

import Foundation
import UIKit

class Comment {
    
    var id : Int!
    var body : String!
    var date : String!
    
    var user : User!
    
    init(data : NSDictionary){
        
        self.id = data["id"] as Int
        let bodyHTML = Utils.getStringFromJSON(data, key: "body")
        self.body = Utils.stripHTML(bodyHTML)
        
        let dateInfo = Utils.getStringFromJSON(data, key: "created_at")
        self.date = Utils.formatDate(dateInfo)
 
        if let userData = data["user"] as? NSDictionary {
            self.user = User(data: userData)
        }
    }
}
