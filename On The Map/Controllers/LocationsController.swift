//
//  LocationsMapViewController.swift
//  On The Map
//
//  Created by Mohamed Shiha on 7/11/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import MapKit
import SafariServices

class LocationsController: UIViewController, MKMapViewDelegate {

    var students = [Student]()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont.boldSystemFont(ofSize: 16.0)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font], for: .normal)

        getAnnotations()
    }
    
    @IBAction func refreshLocations(_ sender: Any) {
        
        getAnnotations()
    }
    
    private func getAnnotations() {
        
        var annotations = [MKPointAnnotation]()
        let parameters = [
            UdacityClient.ParamterKeys.Order: "-\(UdacityClient.JsonResponseKeys.UpdatedAt)",
            UdacityClient.ParamterKeys.Limit : 100
            ] as [String:AnyObject]
        UdacityClient.sharedInstance().getStudentLocations(parameters: parameters) { (students, error) in
            
            if error != nil {
                print(String(describing: error))
                updateUI {
                    let alertController = UIAlertController(title: "Couldn't load data", message: "An error occured while reloading the locations", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                return
            }
            
            if let students = students {
                
                updateUI {
                    (UIApplication.shared.delegate as! AppDelegate).students = students
                }
                for student in students {
                    
                    let coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(student.firstName!) \(student.lastName!)"
                    annotation.subtitle = student.mediumURK!
                    
                    annotations.append(annotation)
                }
            }
            updateUI {
                self.mapView.addAnnotations(annotations)
            }
            print("refreshed")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let urlString = view.annotation?.subtitle {
                if LocationTableController.validateUrl(urlString: urlString) {
                    let safari = SFSafariViewController(url: URL(string: urlString!)!)
                    self.present(safari, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Invalid URL", message: "The provided url is not in the correct format", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        
        // Check if user is already signed in with facebook
        if AccessToken.current != nil {
            let fbLoginManager = LoginManager()
            fbLoginManager.logOut()
            updateUI {
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            // Log out from Udacity
            UdacityClient.sharedInstance().deleteSession { (success, error) in
                
                if success {
                    updateUI {
//                        if let loginMen = self.storyboard?.instantiateViewController(withIdentifier: "loginMenu") {
//                            self.present(loginMen, animated: true, completion: nil)
//                            self.navigationController?.popViewController(animated: true)
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    }
                } else {
                    print(String(describing: error))
                }
            }
        }
    }
}
