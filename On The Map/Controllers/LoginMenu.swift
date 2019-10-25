//
//  LoginMenu.swift
//  On The Map
//
//  Created by Mohamed Shiha on 7/9/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SafariServices

class LoginMenu: UIViewController, UITextFieldDelegate, LoginButtonDelegate {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var seperator: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        
        usernameField.text = ""
        passwordField.text = ""
        
        let fbLoginBtn = FBLoginButton()

        view.addSubview(fbLoginBtn)

        //Set facebook login button properties and constraints for layout
        fbLoginBtn.frame = CGRect(x: 20, y: 50, width: 300, height: 50)
        fbLoginBtn.titleLabel?.font = UIFont(name: (fbLoginBtn.titleLabel?.font.fontName)!, size: 21)

        fbLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = fbLoginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let leftConstraint = fbLoginBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40)
        let rightContstraint = fbLoginBtn.rightAnchor.constraint(greaterThanOrEqualTo: view.rightAnchor, constant: 40)
        let heightConstraint = fbLoginBtn.heightAnchor.constraint(equalToConstant: 50)
        let verticalSpacingConstraint = fbLoginBtn.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 20)
        view.addConstraints([horizontalConstraint, heightConstraint, rightContstraint, leftConstraint, verticalSpacingConstraint])

        fbLoginBtn.delegate = self

        if AccessToken.current != nil {
            updateUI {
                let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavTabBarView") as! UITabBarController
                self.navigationController?.pushViewController(tabViewController, animated: true)
            }
            print("User is already logged in")
        }
    }
    
    // Mark: Facebook login delegate methods
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {

        if let result = result {
            if result.isCancelled {
                print("Sign in has been canceled")
                return
            }
//            print("User logged in")
            
            // Presesnt next View controller
            updateUI {
                let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavTabBarView") as! UITabBarController
                self.navigationController?.pushViewController(tabViewController, animated: true)
            }
        } else {
            print(error!.localizedDescription)
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User has logged out")
    }
    

    @IBAction func loginWithUdacity(_ sender: Any) {
        
        // Authenticate User
        UdacityClient.sharedInstance().authenticateUser(username: usernameField.text ?? "", password: passwordField.text ?? "") { (success, error) in
            if success {
                // Perform Seguo to the next View Controller
                updateUI {
                    let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavTabBarView") as! UITabBarController
                    self.navigationController?.pushViewController(tabViewController, animated: true)
                }
            } else {
                print(error!)
                updateUI {
                    let loginAlert = UIAlertController(title: "Couldn't sign in", message: "Username or password is incorrect", preferredStyle: .alert)
                    loginAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                    self.present(loginAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func redirectToSignUp(_ sender: Any) {
        let url = URL(string: "https://auth.udacity.com/sign-up")
        let safariViewController = SFSafariViewController(url: url!)
        present(safariViewController, animated: true, completion: nil)
    }
}
