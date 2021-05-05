//
//  Database+Extensions.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/4/21.
//

import Foundation
import Firebase

extension Database {
    static let refRoot = Database.database().reference()
    static let refUsers = Database.database().reference().child("users")
    static let refDriverLocations = Database.database().reference().child("driver-locations")
    static let refTrips = Database.database().reference().child("trips")
}
