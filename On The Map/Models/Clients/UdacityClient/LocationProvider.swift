//
//  LocationProvider.swift
//  On The Map
//
//  Created by Mohamed Shiha on 7/11/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import MapKit

extension UdacityClient {
    
    // Mark: Get student locations
    
    func getStudentLocations(parameters: [String:AnyObject], completionHandler: @escaping(_ results: [Student]?, _ error: String?) -> Void) {
        
        let _ = getRequestMethod(Methods.StudentLocation, parameters: parameters) { (results, error) in
            
            if error != nil {
                print(String(describing: error?.localizedDescription))
                return
            }
            
            if let results = results {
                
                let jsonData = results as? Data
                var parsedData : [String:AnyObject]! = nil
                do {
                    parsedData = try JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String:AnyObject]
                } catch {
                    completionHandler(nil, "")
                    return
                }
                if let studentsData = parsedData[JsonResponseKeys.Results] as? [[String:AnyObject]] {
                    let students = Student.studentsFromJSON(studentsData: studentsData)
                    completionHandler(students, nil)
                }
            }
        }
    }
    
    
    // Mark: Post (set) student location
    
    func postStudentLocation(for student: Student, completionHandler: @escaping(_ success: Bool, _ error: String?) -> Void) {
        
        let httpBody = "{\"uniqueKey\": \"\(student.uniqueKey!)\", \"firstName\": \"\(student.firstName!)\", \"lastName\": \"\(student.lastName!)\",\"mapString\": \"\(student.mapString!)\", \"mediaURL\": \"\(student.mediumURK!)\",\"latitude\": \(student.latitude!), \"longitude\": \(student.longitude!)}"
        
        let _ = postRequestMethod(Methods.StudentLocation, jsonBody: httpBody) { (result, error) in
            
            var responseData : [String:AnyObject]! = nil
            
            if error != nil {
                completionHandler(false, "Couldn't register user location")
                return
            }
            
            if let result = result {

                do {
                    responseData = try JSONSerialization.jsonObject(with: result as! Data, options: []) as? [String:AnyObject]
                } catch {
                    completionHandler(false, "Coudn't parse data")
                    return
                }
                
                if let objectID = responseData[JsonResponseKeys.ObjectId] as? String {
                 
                    UdacityClient.sharedInstance().objectID = objectID
                    completionHandler(true, nil)
                    return
                }
            }
        }
    }
}
