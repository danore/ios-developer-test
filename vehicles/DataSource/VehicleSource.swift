//
//  VehicleSource.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation
import RealmSwift

class VehicleSource: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var plates: String?
    @objc dynamic var type: TypeVehicleSource?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func incrementId() -> Int {
        let realm = try! Realm()
        return (realm.objects(VehicleSource.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
}
