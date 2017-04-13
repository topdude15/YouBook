//
//  Classes.swift
//  YouBook
//
//  Created by Trevor Rose on 4/12/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import Foundation

class UserName {
    static var sharedInstance = UserName()
    private init () { }
    
    var email: String!
    var password: String!
    
}
let defaults = UserDefaults.standard
