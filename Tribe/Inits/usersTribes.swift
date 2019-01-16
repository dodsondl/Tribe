//
//  usersTribes.swift
//  Tribe
//
//  Created by Daniel Dodson on 11/26/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class usersTribes {
    // private var postImg: String!
    //private var postName: String!
    //private var postDate: Date!
    //private var postLat: String!
    //private var postLong: String!
    let userID = Auth.auth().currentUser?.uid
    
    private var _tribeID: String!
    
    
    
    
    private var _tribeKey: String!
    private var _tribePostRef: DatabaseReference!
    
    
    var tribeID: String {
        return _tribeID
    }
  
    
    
    
    var tribeKey: String {
        return _tribeKey
    }
    
    
    init(tribeID: String) {
        _tribeID = tribeID
       
        
        
    }
    
    init(tribeKey: String, tribeData: Dictionary<String, AnyObject>) {
        
        _tribeKey = tribeKey
        
        if let tribeID = tribeData["tribeID"] as? String {
            _tribeID = tribeID
        }
    
        
        
        
        _tribePostRef = Database.database().reference().child("users").child("\(userID)").child("tribes")
        
        
    }
}
