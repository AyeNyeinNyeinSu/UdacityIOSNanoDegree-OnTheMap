//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Aye Nyein Nyein Su on 21/05/2023.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        linkTextField.delegate = self
    }

    @IBAction func cancelAddLocation(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func findOnMapTapped(sender: UIButton) {
        setAddingLoc(true)
        findLocation()
    }
    
    func findLocation() {
        let geoencoder = CLGeocoder()
        geoencoder.geocodeAddressString(locationTextField.text!) { placemarks, error in
            if error != nil {
                self.showAlert(message: error?.localizedDescription ?? "", title: "Location Not Found")
                self.setAddingLoc(false)
            } else {
                if let placemark = placemarks?.first {
                    self.routeToCompleteAddLocation(placemark: placemark)
                    self.setAddingLoc(false)
                }
            }
        }
    }
        
    func routeToCompleteAddLocation(placemark: CLPlacemark) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "CompleteAddLocationViewController") as? CompleteAddLocationViewController {
            let studentInfo = PostAndPutLocationRequest(
                uniqueKey: UdacityClient.Auth.objectId,
                firstName: UdacityClient.Auth.firstName,
                lastName: UdacityClient.Auth.lastName,
                mapString: placemark.name!,
                mediaURL: linkTextField.text ?? "",
                latitude: (placemark.location?.coordinate.latitude)!,
                longitude: (placemark.location?.coordinate.longitude)!)
            controller.studentInformation = studentInfo
            navigationController?.pushViewController(controller, animated: true)
        }
    }

// MARK: - user improvement
        
    func setAddingLoc(_ addingLoc: Bool) {
        if addingLoc {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        self.locationTextField.isEnabled = !addingLoc
        self.linkTextField.isEnabled = !addingLoc
        self.findOnMapButton.isEnabled = !addingLoc
       
    }

//MARK: - TextField Delegate Method
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        findOnMapTapped(sender: findOnMapButton)
        
        return true
    }
   
    
}
