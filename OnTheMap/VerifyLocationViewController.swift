//
//  VerifyLocationViewController.swift
//  OnTheMap
//
//  Created by Dylan Miller on 2/23/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

import UIKit
import MapKit

class VerifyLocationViewController: ViewControllerBase {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    weak var placemark: CLPlacemark?
    var mediaUrl: String?

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Rounded buttons.
        finishButton.layer.cornerRadius = 5.0
        
        // Add and zoom to annotation for the location.
        if let location = placemark?.location {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = placemark?.name
            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: true)
        }
    }

    @IBAction func onFinishButton(_ sender: UIButton) {
        
        if let currentUser = User.current, let location = placemark?.location, let mediaUrl = mediaUrl {
            
            let studentLocation = StudentLocation(objectId: currentUser.studentLocationObjectId ?? "", userKey: currentUser.userKey, firstName: currentUser.firstName, lastName: currentUser.lastName, mapString: placemark?.name ?? "", mediaUrl: mediaUrl, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            if currentUser.studentLocationObjectId != nil {
                
                // Display progress HUD before the request is made.
                prepareForRequest()
                
                ParseClient.shared.updateStudentLocation(
                    studentLocation: studentLocation,
                    success: {
                        
                        self.requestDidSucceed()
                        self.onFinishButtonComplete(success: true)
                    },
                    failure: { (error: Error) in
                        
                        self.requestDidFail(
                            title: "Error Adding Location",
                            message: "Could not add the student location. \(error.localizedDescription)",
                            handler: { (action: UIAlertAction) in
                                
                                self.onFinishButtonComplete(success: false)
                            })
                    })
            }
            else {
                
                // Display progress HUD before the request is made.
                prepareForRequest()
                
                ParseClient.shared.addStudentLocation(
                    studentLocation: studentLocation,
                    success: { (objectId: String?) in
                        
                        self.requestDidSucceed()
                        currentUser.studentLocationObjectId = objectId
                        self.onFinishButtonComplete(success: true)
                    },
                    failure: { (error: Error) in
                        
                        self.requestDidFail(
                            title: "Error Adding Location",
                            message: "Could not add the student location. \(error.localizedDescription)",
                            handler: { (action: UIAlertAction) in
                                
                                self.onFinishButtonComplete(success: false)
                            })
                    })
                
            }
        }
    }
    
    // Dismiss the VerifyLocationViewController and AddLocationViewController.
    // This could alternatively be done a bit more elegantly using a delegate
    // pattern.
    func onFinishButtonComplete(success: Bool) {
        
        if success {
            
            // Instruct view controllers to refresh the array of student
            // locations.
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UIConstants.refreshLocationsNotification), object: nil)
        }
        
        DispatchQueue.main.async {
            
            _ = self.navigationController?.popViewController(animated: true)
            self.navigationController?.topViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
