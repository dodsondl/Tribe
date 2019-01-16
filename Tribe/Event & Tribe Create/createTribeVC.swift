//
//  createTribeVC.swift
//  Tribe
//
//  Created by Daniel Dodson on 10/22/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import GeoFire

class createTribeVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 

    @IBOutlet weak var tribeName: UITextField!
    
    
    @IBOutlet weak var tribeTypePickerField: UITextField!
    
    var tribePicker = UIPickerView()
    
    var tribeType = ["Sports", "Fitness", "Social", "business", "Hobbies", "Dance", "Arts", "Music", "Outdoors", "Food & Drink", "Book Club"]
    
     var tribeLocation = CLLocationCoordinate2D()
    var lat = ""
    var long = ""
    
    func createTribeTypePicker () {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(tribeDoneSelector))
        toolbar.setItems([done], animated: false)
        
        tribeTypePickerField.inputAccessoryView = toolbar
        tribeTypePickerField.inputView = tribePicker
    }
    
    @objc func tribeDoneSelector() {
        
        self.view.endEditing(true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tribeType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tribeType[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tribeTypePickerField.text = tribeType[row]
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tribePicker.dataSource = self
        tribePicker.delegate = self
        createTribeTypePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postToFirebase() {
        
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //let data = snapshot.value as! Dictionary<String, AnyObject>
            
          
            let tribeName = self.tribeName.text
            let tribeTypet = self.tribeTypePickerField.text
            let tribeLat = self.lat
            let tribeLong = self.long
            
          
           
            
          
            
            let post: Dictionary<String, AnyObject> = [
                "tribeName": tribeName as AnyObject,
                "tribeType": tribeTypet as AnyObject,
                "tribeLat": tribeLat as AnyObject,
                "tribeLong": tribeLong as AnyObject]
            
            let firebasePost = Database.database().reference().child("tribes").childByAutoId()
            
            firebasePost.setValue(post)
            
            
        })
        
    }
    

    @IBAction func createTribePressed(_ sender: Any) {
        postToFirebase()
    }
    
}
