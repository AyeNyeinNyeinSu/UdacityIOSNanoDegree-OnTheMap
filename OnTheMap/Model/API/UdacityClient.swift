//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Aye Nyein Nyein Su on 19/05/2023.
//

import Foundation
import UIKit

class UdacityClient: NSObject {
    
    struct Auth {
        static var sessionId = ""
        static var userId = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case signUp
        case login
        case getStudentLocations
        case addLocation
        case updateLocation
        case getUserData
        case logout
        
        var stringValue: String {
            switch self {
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            case .login:
                return "\(Endpoints.base)/session"
            case .getStudentLocations:
                return "\(Endpoints.base)/StudentLocation?limit=100&order=-updatedAt"
            case .addLocation:
                return "\(Endpoints.base)/StudentLocation"
            case .updateLocation:
                return "\(Endpoints.base)/StudentLocation/\(Auth.objectId)"
            case .getUserData:
                return "\(Endpoints.base)/users/\(Auth.userId)"
            case .logout:
                return "\(Endpoints.base)/session"
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }

    
    // MARK: - Login
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = LoginRequest(udacity: Udacity(username: username, password: password))
        
        HTTPMethods.taskForPOSTRequestForLogin(url: Endpoints.login.url, responseType: UdacityResponse.self, body: body, httpMethod: "POST") { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.userId = response.account.key
                getUserProfile(completion: { (success, error) in
                })
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // MARK: - Get Logged In User's Data
    
    class func getUserProfile(completion: @escaping (Bool, Error?) -> Void) {

        HTTPMethods.taskForGETRequestForUserData(url: Endpoints.getUserData.url, responseType: UserData.self) { (response, error) in
            if let response = response {
                //print("First Name : \(response.firstName) && Last Name : \(response.lastName) && Full Name: \(response.nickname)")
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true, nil)
            } else {
                print("Failed to get user's data.")
                completion(false, error)
            }
        }
    }
    
    // MARK: - Log Out
    
    class func logout(completionHandler: @escaping () -> Void) {    //completionHandler is empty
        
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            Auth.sessionId = ""
            completionHandler()
        }
        task.resume()
    }
    
    // MARK: - Get Student Location
    
    class func getStudentLocations(completion: @escaping ([Results]?, Error?) -> Void) {
      
        HTTPMethods.taskForGETRequest(url: Endpoints.getStudentLocations.url, responseType: StudentLocationResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
                print("Failed to get student location.")
            }
        }
    }
    
    // MARK: - Add Student Location
   
    class func addStudentLocation(information: PostAndPutLocationRequest, completion: @escaping (Bool, Error?) -> Void) {

        let body = PostAndPutLocationRequest(uniqueKey: information.uniqueKey, firstName: information.firstName, lastName: information.lastName, mapString: information.mapString, mediaURL: information.mediaURL, latitude: information.latitude, longitude: information.longitude)
        
        HTTPMethods.taskForPOSTRequest(url: Endpoints.addLocation.url, responseType: PostLocationResponse.self, body: body, httpMethod: "POST") { (response, error) in
            if let response = response {
                Auth.objectId = response.objectId
                completion(true, nil)
            }
            completion(false, error)
        }
    }
    
    // MARK: - Update Student Location
 
    class func updateStudentLocation(id: String, information: PostAndPutLocationRequest, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = PostAndPutLocationRequest(uniqueKey: information.uniqueKey, firstName: information.firstName, lastName: information.lastName, mapString: information.mapString, mediaURL: information.mediaURL, latitude: information.latitude, longitude: information.longitude)
        
        HTTPMethods.taskForPOSTRequest(url: Endpoints.updateLocation.url, responseType: PutLocationResponse.self, body: body, httpMethod: "PUT") { (response, error) in
            if let response = response {
                completion(true, nil)
            }
            completion(false, error)
        }
    }

}
