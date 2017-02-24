//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Dylan Miller on 2/20/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

import UIKit

class ListViewController: MapListViewControllerBase, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var locationsRefreshedObserver: NSObjectProtocol?
    
    deinit {
        
        // Remove all of this object's observers. For block-based observers,
        // we need a separate removeObserver(observer:) call for each observer.
        if let locationsRefreshedObserver = locationsRefreshedObserver {
            
            NotificationCenter.default.removeObserver(locationsRefreshedObserver)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        tableView.rowHeight = 66.0
        
        // Reload the table based on the current student locations when told to
        // do so.
        locationsRefreshedObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: UIConstants.locationsRefreshedNotification),
            object: nil,
            queue: OperationQueue.main)
        { [weak self] (notification: Notification) in
            
            if let _self = self {
                
                DispatchQueue.main.async {
                    
                    _self.tableView.reloadData()
                }
            }
        }
    }
    
    // Delete the Udacity session and return to the log in view controller.
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        
        logout()
    }
    
    // Refresh the array of student locations.
    @IBAction func onRefreshButton(_ sender: UIBarButtonItem) {
        
        refreshLocations()
    }

    // Add a student location for the current user.
    @IBAction func onAddButton(_ sender: UIBarButtonItem) {
        
        addLocation(withSegueIdentifier: UIConstants.listAddLocationSegue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return StudentLocation.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell") as! StudentLocationTableViewCell
        
        // Initialize cell.
        let studentLocation = StudentLocation.studentLocations[indexPath.row]
        cell.nameLabel.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.mediaUrlLabel.text = studentLocation.mediaUrl
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let studentLocation = StudentLocation.studentLocations[indexPath.row]
        if let url = URL(string: studentLocation.mediaUrl) {
            
            UIApplication.shared.open(url)
        }
    }
}
