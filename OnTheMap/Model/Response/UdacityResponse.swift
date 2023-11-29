//
//  UdacityResponse.swift
//  OnTheMap
//
//  Created by Aye Nyein Nyein Su on 19/05/2023.
//

import Foundation

struct UdacityResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
