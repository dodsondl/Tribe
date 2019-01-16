//
//  locationAnnotation.swift
//  Tribe
//
//  Created by Daniel Dodson on 11/4/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import MapKit

class locationAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    private var eventPostKey: String
    private var _eventPostRef: DatabaseReference!
   internal var title: String?
    internal var date: String?
    
 
  
  
    init(coordinate: CLLocationCoordinate2D, eventPostKey: String, title: String, date: String) {
        self.coordinate = coordinate
        self.eventPostKey = eventPostKey
       self.title = title
        self.date = date
        
        
        
        _eventPostRef = Database.database().reference().child("postsLocation").child(eventPostKey)
    }
}
