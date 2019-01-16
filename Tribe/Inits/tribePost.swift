//
//  tribePost.swift
//  Tribe
//
//  Created by Daniel Dodson on 10/22/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class tribePostInfo {
    // private var postImg: String!
    //private var postName: String!
    //private var postDate: Date!
    //private var postLat: String!
    //private var postLong: String!
    
    private var _tribeName: String!
    private var _tribeType: String!
    
  
    
    private var _tribePostKey: String!
    private var _tribePostRef: DatabaseReference!
    
    
    var tribeName: String {
        return _tribeName
    }
    var tribeType: String {
        return _tribeType
    }
    
 
    
    var tribePostKey: String {
        return _tribePostKey
    }
    
    
    init(tribeName: String, tribeType: String) {
        _tribeName = tribeName
        _tribeType = tribeType
 
        
    }
    
    init(tribePostKey: String, tribePostData: Dictionary<String, AnyObject>) {
        
        _tribePostKey = tribePostKey
        
        if let tribeName = tribePostData["tribeName"] as? String {
            _tribeName = tribeName
        }
        if let tribeType = tribePostData["tribeType"] as? String {
            _tribeType = tribeType
        }
     
   
        
        _tribePostRef = Database.database().reference().child("tribes").child(_tribePostKey)
        
        
        
    }
}
