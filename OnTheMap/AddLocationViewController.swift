//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Dylan Miller on 2/23/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: ViewControllerBase, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Rounded buttons.
        findLocationButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        
        // Dimiss the keyboard when a user taps outside of a text field.
        view.endEditing(true)
    }
    
    @IBAction func onFindLocation(_ sender: UIButton) {

        // Validate the text fields.
        let locationText = locationTextField.text ?? ""
        let websiteText = websiteTextField.text ?? ""
        if locationText == "" || websiteText == "" {
            
            displayError(title: "Invalid Input", message: "Please enter a location and website.")
            return
        }
        
        // Display progress HUD before the request is made.
        prepareForRequest()
        
        // Forward geocode the location.
        geocoder.geocodeAddressString(locationText) { (placemarks: [CLPlacemark]?, error: Error?) in
            
            if let error = error {
                
                self.requestDidFail(title: "Location Not Found", message: "Could not geocode the location. \(error.localizedDescription)")
            }
            else {
                
                if let placemark = placemarks?.first {
                    
                    self.requestDidSucceed()
                    
                    DispatchQueue.main.async {
                        
                        self.placemark = placemark
                        self.performSegue(withIdentifier: UIConstants.verifyLocationSegue, sender: self)
                    }
                }
                else {
                    
                    self.requestDidFail(title: "Location Not Found", message: "Could not find the location.")
                }
            }
        }
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let verifyLocationViewController = segue.destination as? VerifyLocationViewController {
            
            verifyLocationViewController.placemark = placemark
            verifyLocationViewController.mediaUrl = websiteTextField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
}
