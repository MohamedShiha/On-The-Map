//
//  AudacityConstants.swift
//  On The Map
//
//  Created by Mohamed Shiha on 7/7/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation

extension UdacityClient {

    // Mark: Constants
    struct Constsants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "onthemap-api.udacity.com"
        static let ApiPath = "/v1"
    }
    
    // MARK: Methods
    struct Methods {
        
        static let StudentLocation = "/StudentLocation"
        static let Session = "/session"
        static let Users = "/users"
    }
    
    // Mark: URLKeys
    struct URLKeys {
        
        static let ObjectID = "<objectId>"
        static let UserID = "<user_id>"
    }
    
    // Mark: ParamterKeys
    struct ParamterKeys {
        
        static let objectID = "<objectId>"
        static let userID = "<user_id>"
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let UniqueKey = "uniqueKey"
    }
    
    // Mark: JsonBodyKeys
    struct JsonBodyKeys {
        
        // Mark: User Public Data
        static let UserKey = "user"
        
        // Mark: Posting a session
        static let UserName = "username"
        static let Password = "password"
        
        // Mark: Putting a Student Location
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // Mark: JsonResponseKeys
    struct JsonResponseKeys {
        
        // Mark: Account
        static let Account = "account"
        static let Account_IsRegistered = "registered"
        static let AccountKey = "key"
        
        // Mark: Session
        static let Session = "session"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        
        // Mark : Result
        static let Results = "results"
        
        // Mark: User Data
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
        
        // Mark: User Public Data
        static let First_Name = "first_name"
        static let Last_Name = "last_name"
    }
}
