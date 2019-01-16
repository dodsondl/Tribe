//
//  IndividualTribeViewController.swift
//  Tribe
//
//  Created by Daniel Dodson on 11/20/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
import GeoFire

class IndividualTribeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    var locationManager = CLLocationManager()
    var eventPosts = [eventPostInfo]()
    var tribePosts = [tribePostInfo]()
    var eventPost: eventPostInfo!
    var tribePost: tribePostInfo!
    var imagePicker: UIImagePickerController!
    var geoFire: GeoFire!
    var mapHasCenterdOnce = false
    var geoFireRef: DatabaseReference!
    var tribeKey = ""
    
   
    var tribename = ""
    var tribeType = ""
    var eventLatitude = ""
    var eventLongitude = ""
    
    
let annotation = MKPointAnnotation()
    
   
    @IBOutlet weak var tribeName: UILabel!
    
    @IBOutlet weak var tribeMembers: UILabel!
    
    @IBOutlet weak var tribeLocationMap: MKMapView!
    
    @IBAction func joinTribe(_ sender: Any) {
        
        let userID = Auth.auth().currentUser?.uid
        
       let addUser = Database.database().reference().child("tribes").child(tribeKey).child("members").child("\(userID!)")
        
        let post: Dictionary<String, AnyObject> = [
            "memberID": userID as AnyObject]
        
        addUser.setValue(post)
        
        let addTribe = Database.database().reference().child("users").child("\(userID!)").child("tribes").child("\(tribeKey)")
        
        let tribePost: Dictionary<String, AnyObject> = [
            "tribeID": tribeKey as AnyObject,
            "tribeName": tribename as AnyObject,
            "tribeType": tribeType as AnyObject]
        
        addTribe.setValue(tribePost)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //eventName.text = eventPosts[eventIndex].eventname
        //eventDate.text = eventPosts[eventIndex].eventdate
        print(eventLongitude)
      
        
        
        Database.database().reference().child("tribes").child(tribeKey).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.tribename = (value?["tribeName"] as? String)!
           self.tribeType = (value?["tribeType"] as? String)!
           // self.eventLatitude = (value?["eventLatitude"] as? String)!
            //self.eventLongitude = (value?["eventLongitude"] as? String)!
          
            self.tribeName.text = self.tribename
            self.tribeMembers.text = "23 Members"
            self.eventLatitude = (value?["tribeLat"] as? String)!
            self.eventLongitude = (value?["tribeLong"] as? String)!
            self.centerMapOnLocation()
           // self.eventDate.text = self.eventdate
        })
        
    
        
        
    }
    
    
    func viewDidAppear(eventPost: eventPostInfo) {
        //eventName.text = eventPosts[eventIndex].eventname
        // eventDate.text = eventPosts[eventIndex].eventdate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func centerMapOnLocation() {
        var eventLat = Double(eventLatitude)!
        var eventLon = Double(eventLongitude)!
        var eventLoc = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLon)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(eventLoc, 2000, 2000)
        self.tribeLocationMap.setRegion(coordinateRegion, animated: true)
        annotation.coordinate = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLon)
        self.tribeLocationMap.addAnnotation(annotation)
    }
    
    
    
    
}
