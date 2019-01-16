//
//  createEventVC.swift
//  Tribe
//
//  Created by Daniel Dodson on 10/10/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import GeoFire

class createEventVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var eventNameField: UITextField!
    
  
    @IBOutlet weak var eventDateField: UITextField!
    
    @IBOutlet weak var eventPickerField: UITextField!
    
    let dateFormatter = DateFormatter()
    
   var datePicker = UIDatePicker()
    
    var eventPicker = UIPickerView()
    
    var eventType = ["Sports", "Fitness", "Social", "business", "Hobbies", "Dance", "Arts", "Music", "Outdoors", "Food & Drink", "Book Club"]
   
    
  var lat = ""
    var long = ""
    var eventLocation = CLLocationCoordinate2D()
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!
    var dateyo = ""
    
    
    func postToFirebase() {
        
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            
            let username = data["username"]
            let eventname = self.eventNameField.text
            let eventLatitude = self.lat
            let eventLongitude = self.long
            let datee = self.eventDateField.text
            let eventTypet = self.eventPickerField.text
            
        
           
          
        
       
            
            let post: Dictionary<String, AnyObject> = [
                "username": username as AnyObject,
                "eventname": eventname as AnyObject,
                "eventLatitude": eventLatitude as AnyObject,
                "eventLongitude": eventLongitude as AnyObject,
                "eventdate": datee as AnyObject,
                "eventType": eventTypet as AnyObject]
            
            let firebasePost = Database.database().reference().child("posts").childByAutoId()
           
            
            firebasePost.setValue(post)
            let childAutoID = firebasePost.key
           
           // let plz = Database.database().reference().child("posts").child("\(childAutoID)")
             let geoFireLocation = CLLocation(latitude: self.eventLocation.latitude, longitude: self.eventLocation.longitude)
            var geo = GeoFire(firebaseRef: self.geoFireRef.child("postsLocation"))
            geo.setLocation(geoFireLocation, forKey: "\(childAutoID)")
           // self.geoFire.setLocation(geoFireLocation, forKey: "\(childAutoID)")
        
           
          
      
            

            
            })
        
       
    }
    
    
    @IBAction func createEventPressed(_ sender: Any) {
        postToFirebase()
    }
    
    func createEventPicker () {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(eventDoneSelector))
        toolbar.setItems([done], animated: false)
        
        eventPickerField.inputAccessoryView = toolbar
        eventPickerField.inputView = eventPicker
        
    }
    
    func createDatePicker () {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneSelector))
        toolbar.setItems([done], animated: false)
        
        eventDateField.inputAccessoryView = toolbar
        eventDateField.inputView = datePicker
    }
    
    @objc func eventDoneSelector() {
        
        self.view.endEditing(true)
        
    }
    
    @objc func doneSelector() {
        
        //date format
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: datePicker.date)
        
        let dateyo = "\(dateString)"
        eventDateField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geoFireRef = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
      print(lat)
        print(long)
        createDatePicker()
        createEventPicker()
        eventPicker.dataSource = self
        eventPicker.delegate = self
     
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eventType[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        eventPickerField.text = eventType[row]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
