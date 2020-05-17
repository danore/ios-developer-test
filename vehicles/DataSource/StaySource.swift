//
//  StaySource.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation
import RealmSwift

class StaySource: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var start_date: Date?
    @objc dynamic var end_date: Date?
    @objc dynamic var total: Int = 0
    @objc dynamic var total_amount: Double = 0
    @objc dynamic var is_parked: Bool = false
    @objc dynamic var vehicle: VehicleSource?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func incrementId() -> Int {
        let realm = try! Realm()
        return (realm.objects(StaySource.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
}
