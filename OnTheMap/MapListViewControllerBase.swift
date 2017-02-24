//
//  MapListViewControllerBase.swift
//  OnTheMap
//
//  Created by Dylan Miller on 2/23/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

import UIKit

// Base class for map/list view controllers.
class MapListViewControllerBase: ViewControllerBase {
    
    var refreshLocationsObserver: NSObjectProtocol?

    deinit {
        
        // Remove all of this object's observers. For block-based observers,
        // we need a separate removeObserver(observer:) call for each observer.
        if let refreshLocationsObserver = refreshLocationsObserver {
            
            NotificationCenter.default.removeObserver(refreshLocationsObserver)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Refresh the array of student locations when notified to do so.
        refreshLocationsObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: UIConstants.refreshLocationsNotification),
            object: nil,
            queue: OperationQueue.main)
        { [weak self] (notification: Notification) in
            
            if let _self = self {
                
                DispatchQueue.main.async {
                    
                    _self.refreshLocations()
                }
            }
        }
    }
    
    // Delete the Udacity session and return to the log in view controller.
    func logout() {
        
        // Display progress HUD before the request is made.
        prepareForRequest()
        
        UdacityClient.shared.deleteSession(
            success: {
            
                self.requestDidSucceed()
                
                DispatchQueue.main.async {
                    
                    self.navigationController?.topViewController?.dismiss(animated: true, completion: nil)
                }
            },
            failure: { (error: Error) in
            
                self.requestDidFail(
                    title: "Error Logging Out",
                    message: "\(error.localizedDescription)",
                    handler: { (action: UIAlertAction) in
                        
                        DispatchQueue.main.async {
                            
                            self.navigationController?.topViewController?.dismiss(animated: true, completion: nil)
                        }
                })
                
            })
    }
    
    // Refresh the array of student locations.
    func refreshLocations() {
        
        // Display progress HUD before the request is made.
        prepareForRequest()
        
        ParseClient.shared.getStudentLocations(
            limit: 100,
            success: {
                
                self.requestDidSucceed()

                DispatchQueue.main.async {

                    self.onRefreshComplete()
                }
            },
            failure: { (error: Error) in
                
                self.requestDidFail(title: "Error Getting Student Locations", message: "\(error.localizedDescription)")
            })
    }

    // Reload the map/list based on the current student locations.
    func onRefreshComplete() {
        
        fatalError("Must Override")
    }

    // Add a student location for the current user.
    func addLocation(withSegueIdentifier: String) {
        
        if let currentUser = User.current {
            
            if currentUser.studentLocationObjectId != nil {
                
                let alert = UIAlertController(title: "Overwrite Location?", message: "The logged in user has already posted a student location. Would you like to overwrite it?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(
                    title: "Overwrite",
                    style: UIAlertActionStyle.default,
                    handler: { (action: UIAlertAction) in
                        
                        self.performSegue(withIdentifier: withSegueIdentifier, sender: self)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true)
            }
            else {
                
                self.performSegue(withIdentifier: withSegueIdentifier, sender: self)
            }
        }
    }
}

