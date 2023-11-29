//
//  PostAndPutLocationRequest.swift
//  OnTheMap
//
//  Created by Aye Nyein Nyein Su on 19/05/2023.
//

import Foundation

struct PostAndPutLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
}
