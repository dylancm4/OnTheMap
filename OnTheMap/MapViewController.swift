//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Dylan Miller on 2/14/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: MapListViewControllerBase, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        addAnnotations()
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
        
        addAnnotations()
    }
    
    // Add a student location for the current user.
    @IBAction func onAddButton(_ sender: UIBarButtonItem) {

        addLocation(withSegueIdentifier: UIConstants.mapAddLocationSegue)
    }
    
    // Create annotations and add them to the mapView, removing any existing
    // annotations.
    func addAnnotations() {
        
        var annotations = [MKPointAnnotation]()
        for studentLocation in StudentLocation.studentLocations {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: CLLocationDegrees(studentLocation.latitude),
                longitude: CLLocationDegrees(studentLocation.longitude))
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = studentLocation.mediaUrl
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    // MARK: - MKMapViewDelegate
    
    // Create/reuse an MKAnnotationView with a "right callout accessory view".
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // When an annotation is tapped, open its URL.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            if let urlString = view.annotation?.subtitle!, let url = URL(string: urlString) {
                
                UIApplication.shared.open(url)
            }
        }
    }
}
