//
//  messageTribePost.swift
//  Tribe
//
//  Created by Daniel Dodson on 12/5/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase



class messageTribePost {
    
    private var _tribeName: String!
    private var _tribeType: String!
    
     let userID = Auth.auth().currentUser?.uid
    
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
        
        
        
        _tribePostRef = Database.database().reference().child("users").child(userID!).child("tribes").child(_tribePostKey)
        
        
        
    }
}
