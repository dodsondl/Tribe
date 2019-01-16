//
//  messageDetail.swift
//  Tribe
//
//  Created by Daniel Dodson on 10/22/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper


class messageDetail {
    
    private var _tribeName: String!
    private var _messageKey: String!
    private var _messageRef: DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    let userID = Auth.auth().currentUser?.uid
    
    var tribeName: String {
        return _tribeName
    }
    
    var messageKey: String {
        return _messageKey
    }
    
    var messageRef: DatabaseReference {
        return _messageRef
    }
    
    init(tribeName: String) {
        _tribeName = tribeName
    }
    
    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
        _messageKey = messageKey
        
        if let tribeName = messageData["tribeName"] as? String {
            _tribeName = tribeName
        }
        
        _messageRef = Database.database().reference().child("tribeName").child(_messageKey)
    }
}
