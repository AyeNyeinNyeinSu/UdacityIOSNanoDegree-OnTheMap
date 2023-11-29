//
//  Results.swift
//  OnTheMap
//
//  Created by Aye Nyein Nyein Su on 19/05/2023.
//

import Foundation

struct Results: Codable {
    
    let uniqueKey: String
    let objectId: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let createdAt: String
    let updatedAt: String
}
