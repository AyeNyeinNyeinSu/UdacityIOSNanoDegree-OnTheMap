//
//  StudentsData.swift
//  OnTheMap
//
//  Created by MgKaung on 31/05/2023.
//  Copyright © 2023 Fabio Italiano. All rights reserved.
//

import Foundation

class StudentsData: NSObject {

    var students = [Results]()

    class func sharedInstance() -> StudentsData {
        struct Singleton {
            static var sharedInstance = StudentsData()
        }
        return Singleton.sharedInstance
    }

}
