//
//  PostLocation.swift
//  On The Map
//
//  Created by Mohamed Shiha on 7/14/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit
import MapKit

class PostLocation: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    var coordinate : CLLocationCoordinate2D?
    var mapString : String?
    var mediumUrl : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        let font = UIFont.boldSystemFont(ofSize: 16.0)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font], for: .normal)
        
        getAnnotation()
        viewLocation(mapView, CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude))
    }
    
    private func viewLocation(_ mapView: MKMapView, _ location: CLLocation) {
        
        let regionRadius : CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func getAnnotation() {
        
        if let coordinate = coordinate, let mapString = mapString, let mediumUrl = mediumUrl {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = mapString
            annotation.subtitle = mediumUrl
            
            updateUI {
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "promptLocation"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView != nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    @IBAction func setLocation(_ sender: Any) {
        
        let studentData = [
            UdacityClient.JsonResponseKeys.UniqueKey: UdacityClient.sharedInstance().userID!,
            UdacityClient.JsonResponseKeys.FirstName: "Test",
            UdacityClient.JsonResponseKeys.LastName: "Client",
            UdacityClient.JsonResponseKeys.Latitude: (coordinate?.latitude)!,
            UdacityClient.JsonResponseKeys.Longitude: (coordinate?.longitude)!,
            UdacityClient.JsonResponseKeys.MapString: mapString!,
            UdacityClient.JsonResponseKeys.MediaURL: mediumUrl!
        ] as [String:AnyObject]
        
        let dummyStudent = Student(studentDictionary: studentData)
        
        UdacityClient.sharedInstance().postStudentLocation(for: dummyStudent) { (success, error) in
            
            if success {
                updateUI {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                updateUI {
                    let alertController = UIAlertController(title: "Couldn't set location", message: "An error occured while setting your locations", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                return
            }
        }
    }
}
