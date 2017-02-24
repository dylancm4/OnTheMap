//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Dylan Miller on 1/9/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

import UIKit

class LoginViewController: ViewControllerBase {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var dontHaveAccountLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpLabelLeadingConstraint: NSLayoutConstraint!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        // Login screen only supports portrait orientation.
        return UIInterfaceOrientationMask.portrait
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Center dontHaveAccountLabel+signUpLabel.
        dontHaveAccountLeadingConstraint.constant = (view.bounds.width - (dontHaveAccountLabel.bounds.width + signUpLabelLeadingConstraint.constant + signUpButton.bounds.width)) / 2
        
        // Rounded buttons.
        loginButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func onTextFieldDidEndOnExit(_ sender: UITextField) {
        
        login()
    }

    @IBAction func onLoginButton(_ sender: UIButton) {
        	
        login()
    }

    @IBAction func onSignUpButton(_ sender: UIButton) {

        if let url = URL(string: UdacityClient.Constants.signUpUrl) {
            
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        
        // Dimiss the keyboard when a user taps outside of a text field.
        view.endEditing(true)
    }
    
    // Login to Udacity using the specified user name and password.
    func login() {
        
        if let userName = emailTextField.text, let password = passwordTextField.text {
            
            // Display progress HUD before the request is made.
            prepareForRequest()

            UdacityClient.shared.createSession(
                userName: userName,
                password: password,
                success: {
                    
                    UdacityClient.shared.getUserData(
                        success: {
                            
                            if let currentUser = User.current {
                                
                                ParseClient.shared.getStudentLocation(
                                    uniqueKey: currentUser.userKey,
                                    success: { (studentLocation: StudentLocation?) in
                                        
                                        currentUser.studentLocationObjectId = studentLocation?.objectId
                                        
                                        ParseClient.shared.getStudentLocations(
                                            limit: 100,
                                            success: {
                                                
                                                self.requestDidSucceed()
                                                
                                                DispatchQueue.main.async {
                                                    
                                                    self.emailTextField.text = nil
                                                    self.passwordTextField.text = nil
                                                    
                                                    self.performSegue(withIdentifier: UIConstants.loginSegue, sender: self)
                                                }
                                            },
                                            failure: { (error: Error) in
                                                
                                                self.requestDidFail(title: "Error Getting Student Locations", message: "\(error.localizedDescription)")
                                            })
                                    },
                                    failure: { (error: Error) in
                                        
                                        self.requestDidFail(title: "Error Getting User Student Location", message: "\(error.localizedDescription)")
                                    })
                            }
                        },
                        failure: { (error: Error) in
                            
                            self.requestDidFail(title: "Error Getting User Data", message: "\(error.localizedDescription)")
                        })
                    
                },
                failure: { (error: Error) in
                    
                    var description = error.localizedDescription
                    if description == "403: forbidden" {
                        
                        description = "Incorrect email or password"
                    }
                    self.requestDidFail(title: "Login Error", message: "\(description)")
                })
        }
    }
}

