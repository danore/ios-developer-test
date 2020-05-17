//
//  TypeVehicleSource.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation
import RealmSwift

class TypeVehicleSource: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var desc: String?
    @objc dynamic var amount: Double = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
