//
//  MapTableController.swift
//  On The Map
//
//  Created by Mohamed Shiha on 7/13/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SafariServices

class LocationTableController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var students : [Student]!
    let cellID = "studentLocation"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        students = (UIApplication.shared.delegate as! AppDelegate).students
        
        let font = UIFont.boldSystemFont(ofSize: 16.0)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font], for: .normal)
        
        // style table view
        if students.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = true
            tableView.backgroundColor = UIColor.lightGray
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = false
            tableView.backgroundColor = UIColor.white
        }
        tableView.reloadData()
        
    }
    
    @IBAction func refreshLocations(_ sender: Any) {
        
        getLocationList()
    }

    private func getLocationList() {
        
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
                self.students = students
                print("refreshed")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if students.count != 0 {
            return students.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.textLabel?.text = "\(students[indexPath.row].firstName!) \( students[indexPath.row].lastName!)"
        cell?.detailTextLabel?.text = students[indexPath.row].mediumURK!
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let mediumUrlString = students[indexPath.row].mediumURK {
            
            if LocationTableController.validateUrl(urlString: mediumUrlString) {
                let url = URL(string: mediumUrlString)
                let safari = SFSafariViewController(url: url!)
                updateUI {
                    self.present(safari, animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "Invalid URL", message: "The provided url is not in the correct format", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    static func validateUrl (urlString: String?) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }

    @IBAction func logout(_ sender: Any) {
        
        // Check if user is already signed in with facebook
        if AccessToken.current != nil {
            let fbLoginManager = LoginManager()
            fbLoginManager.logOut()
            updateUI {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            // Log out from Udacity
            UdacityClient.sharedInstance().deleteSession { (success, error) in
                
                if success {
                    updateUI {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print(String(describing: error))
                }
            }
        }
    }
}
