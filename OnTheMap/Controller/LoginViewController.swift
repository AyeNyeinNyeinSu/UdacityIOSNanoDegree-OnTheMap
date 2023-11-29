//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Aye Nyein Nyein Su on 19/05/2023.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        setLoggingIn(true)
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        UdacityClient.login(username: emailTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            self.setLoggingIn(true)
            self.performSegue(withIdentifier: "login", sender: nil)
            self.setLoggingIn(false)
        } else {
            self.setLoggingIn(true)
            showAlert(message: "\(error?.localizedDescription)", title: "Username & Password are incorrect.")
            self.setLoggingIn(false)
        }
    }
    
// MARK: - user improvement
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        self.emailTextField.isEnabled = !loggingIn
        self.passwordTextField.isEnabled = !loggingIn
        self.loginButton.isEnabled = !loggingIn
        self.signUpButton.isEnabled = !loggingIn
    }
    
//MARK: - TextField Delegate
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
        textField.resignFirstResponder()
        loginTapped(loginButton)
            
        return true
    }
    
}
