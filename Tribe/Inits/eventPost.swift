//
//  Posts.swift
//  Tribe
//
//  Created by Daniel Dodson on 10/3/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import MapKit

class eventPostInfo: NSObject, MKAnnotation {
    
    var coordinate = CLLocationCoordinate2D()
    
   // private var postImg: String!
    //private var postName: String!
    //private var postDate: Date!
    //private var postLat: String!
    //private var postLong: String!
    
    private var _username: String!
    private var _eventname: String!
    private var _eventdate: String!
    private var _eventLatitude: String!
    private var _eventLongitude: String!
    private var _eventType: String!
   // private var _eventLocation: CLLocationCoordinate2D!

    var _eventPostKey: String!
    var _eventPostRef: DatabaseReference!
    
    
   
    
    var eventname: String {
        return _eventname
    }
    
    var eventLatitude: String {
        return _eventLatitude
    }
    
    var eventLongitude: String {
        return _eventLongitude
    }
    
    var eventdate: String {
        return _eventdate
    }
    
    var eventPostKey: String {
        return _eventPostKey
    }
  
    var eventType: String {
        return _eventType
    }
   
    init(username: String, eventname: String, eventLatitude: String, eventLongitude: String, eventdate: String, eventType: String, eventPostKey: String, coordinate: CLLocationCoordinate2D) {
        
   
        //_eventname = eventname
        _eventname = eventname
        _eventdate = eventdate
        _eventLatitude = eventLatitude
        _eventLongitude = eventLongitude
        _eventType = eventType
         _eventPostKey = eventPostKey
        self.coordinate = coordinate
       
        _username = username
        
    }
    /*init(eventname: String, eventPostKey: String, coordinate: CLLocationCoordinate2D) {
        
    }
    */
  
   
    
    init(eventPostKey: String, eventPostData: Dictionary<String, AnyObject>) {
        
        _eventPostKey = eventPostKey
    
      
        
        if let username = eventPostData["username"] as? String {
            _username = username
        }
        if let eventname = eventPostData["eventname"] as? String {
            _eventname = eventname
        }
        if let eventLatitude = eventPostData["eventLaditude"] as? String {
            _eventLatitude = eventLatitude
        }
        if let eventLongitude = eventPostData["eventLongitude"] as? String {
            _eventLongitude = eventLongitude
        }
        if let eventdate = eventPostData["eventdate"] as? String {
            _eventdate = eventdate
        }
        if let eventType = eventPostData["eventType"] as? String {
            _eventType = eventType
        }
        if let _coordinate = eventPostData["eventLocation"] as? CLLocationCoordinate2D {
            coordinate = _coordinate
        }
        
        _eventPostRef = Database.database().reference().child("posts").child(_eventPostKey)
        
        
    }
}
