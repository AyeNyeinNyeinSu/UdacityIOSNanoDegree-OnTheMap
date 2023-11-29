//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Aye Nyein Nyein Su on 19/05/2023.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: Udacity
}

struct Udacity: Codable {
    let username: String
    let password: String
}
