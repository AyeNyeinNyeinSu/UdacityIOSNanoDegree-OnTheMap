//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Aye Nyein Nyein Su on 20/05/2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentsLists()
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        getStudentsLists()
    }
    
    func getStudentsLists() {
        
        activityIndicator.startAnimating()

        UdacityClient.getStudentLocations() { results, error in
            if error != nil {
                self.showAlert(message: error!.localizedDescription, title: "Invalid Student Locations Temporarily")
                self.activityIndicator.stopAnimating()
            } else {
                for pin in results! {
                    let anno = MKPointAnnotation()
                    anno.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                    anno.title = "\(pin.firstName) \(pin.lastName)"
                    anno.subtitle = pin.mediaURL
                    self.mapView.addAnnotation(anno)
                    
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
// MARK: - MKMapview delegate
    
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let url = URL(string: (view.annotation?.subtitle!)!) else { return }
            UIApplication.shared.openURL(url)
        }
    }
    
}
