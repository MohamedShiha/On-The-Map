//
//  AddLocationController.swift
//  On The Map
//
//  Created by Mohamed Shiha on 7/13/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var mapLocationTextField: UITextField!
    @IBOutlet weak var profileUrlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        let font = UIFont.boldSystemFont(ofSize: 16.0)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font], for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        print(UIScreen.main.bounds.height)
        if profileUrlTextField.isFirstResponder && view.frame.height <= 568.0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if profileUrlTextField.isFirstResponder && view.frame.height <= 568.0 {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func geoCode(_ completionHandler: @escaping(_ coordinate: CLLocationCoordinate2D, _ error: String?) -> Void) {
        let geoCoder = CLGeocoder()
        let address = mapLocationTextField.text!
        
        geoCoder.geocodeAddressString(address) { (placemark, error) in
            
            if let error = error {
                completionHandler(CLLocationCoordinate2D.init(), error.localizedDescription)
                return
            }
            
            if let placemark = placemark, placemark.count > 0 {
                
                let location = placemark.first?.location
                
                if let location = location {
                    let coordinates = location.coordinate
                    completionHandler(coordinates, nil)
                    return
                }
            }
        }
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        if mapLocationTextField.text != "" || profileUrlTextField.text != "" {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
    
            geoCode { (coordinate, error) in
                
                if error != nil {
                    let alertController = UIAlertController(title: "Couldn't process location", message: "An error occured while loading the location", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                    updateUI {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.present(alertController, animated: true, completion: nil)
                    }
                    return
                }
                
                updateUI {
                    let postLocationView = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationView") as! PostLocation
                    postLocationView.coordinate = coordinate
                    postLocationView.mapString = self.mapLocationTextField.text
                    postLocationView.mediumUrl = self.profileUrlTextField.text
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.navigationController?.pushViewController(postLocationView, animated: true)
//                    self.present(postLocationView, animated: true, completion: nil)
                }
            }
        } else {
            let alertController = UIAlertController(title: "Couldn't show location", message: "Enter valid data to proceed", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
            updateUI {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
