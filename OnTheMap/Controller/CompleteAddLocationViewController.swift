//
//  CompleteAddLocationViewController.swift
//  OnTheMap
//
//  Created by Aye Nyein Nyein Su on 21/05/2023.
//

import UIKit
import MapKit

class CompleteAddLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!

    var studentInformation: PostAndPutLocationRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let studentLoc = studentInformation {
            showLocations(student: studentLoc)
        }
    }
    
    func showLocations(student: PostAndPutLocationRequest) {
        let coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude )
        let anno = MKPointAnnotation()
        anno.coordinate = coordinate
        mapView.addAnnotation(anno)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let viewRegion = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(viewRegion, animated: false)
    }

    @IBAction func submitPressed(_ sender: UIButton) {
        setLoading(true)
        if UdacityClient.Auth.objectId == "" {
            addStudentLoc()
        } else {
            updateStudentLoc()
        }
    }
    
    func addStudentLoc() {
        if let studentLocation = studentInformation {
            UdacityClient.addStudentLocation(information: studentLocation) { success, error in
                if success {
                    self.dismissVC()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                }
            }
        }
    }
    
    func updateStudentLoc() {
        if let studentLocation = studentInformation {
            let alertVC = UIAlertController(title: "", message: "This student has already posted a location. Would you like to overwrite the location?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { UIAlertAction in
                UdacityClient.updateStudentLocation(id: UdacityClient.Auth.objectId, information: studentLocation) { success, error in
                    if success {
                        self.dismissVC()
                    } else {
                        self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                    }
                }
            }))
            
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
                DispatchQueue.main.async {
                    self.setLoading(false)
                    self.dismissVC()
                }
            }))
            self.present(alertVC, animated: true)
        }
    }
    
    func dismissVC() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
// MARK: - user improvement
    
    func setLoading(_ loading: Bool) {
        if loading {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        self.submitButton.isEnabled = !loading
    }
    

    
}
