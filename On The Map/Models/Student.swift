//
//  Student.swift
//  On The Map
//
//  Created by Mohamed Shiha on 7/12/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation

struct Student {
    
    let uniqueKey : String?
    let firstName : String?
    let lastName : String?
    let latitude : Double?
    let longitude : Double?
    let mapString : String?
    let mediumURK : String?
    
    init(studentDictionary : [String:AnyObject]) {
        
        uniqueKey = studentDictionary[UdacityClient.JsonResponseKeys.UniqueKey] as? String
        firstName = studentDictionary[UdacityClient.JsonResponseKeys.FirstName] as? String
        lastName = studentDictionary[UdacityClient.JsonResponseKeys.LastName] as? String
        latitude = studentDictionary[UdacityClient.JsonResponseKeys.Latitude] as? Double
        longitude = studentDictionary[UdacityClient.JsonResponseKeys.Longitude] as? Double
        mapString = studentDictionary[UdacityClient.JsonResponseKeys.MapString] as? String
        mediumURK = studentDictionary[UdacityClient.JsonResponseKeys.MediaURL] as? String
    }
    
    static func studentsFromJSON(studentsData: [[String:AnyObject]]) -> [Student] {
        
        var students = [Student]()
        
        for studentData in studentsData {
            students.append(Student(studentDictionary: studentData))
        }
        return students
    }
}
