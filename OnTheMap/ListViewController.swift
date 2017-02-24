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

    override func viewDidLoad() {
        
        super.viewDidLoad()

        tableView.rowHeight = 66.0
    }
    
    // Delete the Udacity session and return to the log in view controller.
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        
        logout()
    }
    
    // Refresh the array of student locations.
    @IBAction func onRefreshButton(_ sender: UIBarButtonItem) {
        
        refreshLocations()
    }

    // Reload the map/list based on the current student locations.
    override func onRefreshComplete() {
        
        tableView.reloadData()
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
