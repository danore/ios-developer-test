//
//  VehicleModel.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftyJSON

class VehicleModel {
    
    static var instance = VehicleModel()
    
    private init() {}
    
    /// Register vehicle
    /// - Parameters:
    ///   - plates: String
    ///   - type: TypeVehicleSource
    ///   - completion: VehicleSource
    func save(_ plates: String, type: TypeVehicleSource, completion: @escaping (VehicleSource?, String) -> ()) {
        do {
            let realm = try Realm()
            var vehicle = self.findByPlates(plates)
            
            if vehicle == nil {
                vehicle = VehicleSource()
                vehicle?.id = vehicle!.incrementId()
                vehicle?.plates = plates
                vehicle?.type = type

                realm.add(vehicle!)
                completion(vehicle!, TypeUtil.TEXT_VEHICLE_SUCCESS)
            }else {
                completion(vehicle!, TypeUtil.TEXT_SUCCESS)
            }
        } catch let error as NSError {
            print(error.localizedFailureReason!)
            completion(nil, "Error en base de datos al registrar vehículo")
        }
    }
    
    /// Save vehicles types
    /// - Parameter json: JSON SwiftyJSON
    func saveTypes(_ json: JSON) {
        do {
            let realm = try Realm()
            
            try! realm.write {
                for info in json.arrayValue {
                    let data = self.findType(info["id"].intValue    )
                    
                    if data == nil {
                        let entity = TypeVehicleSource()
                        entity.id = info["id"].intValue
                        entity.desc = info["name"].stringValue
                        entity.amount = info["amount"].doubleValue

                        realm.add(entity)
                    }
                }
            }
        } catch let error as NSError {
           print(error.localizedFailureReason!)
        }
    }
    
    /// Find vehicle by plates
    /// - Parameter plates: String
    func findByPlates(_ plates: String)->VehicleSource? {
        let realm = try! Realm()
        let data = realm.objects(VehicleSource.self).filter("plates == '\(plates)'")
        
        return data.count > 0 ? data.first! : nil
    }
    
    /// Find all types
    func findTypes()->[TypeVehicleSource] {
        let realm = try! Realm()
        var result = [TypeVehicleSource]()
        
        let data = realm.objects(TypeVehicleSource.self)
        
        for info in data {
            result.append(info)
        }
        
        return result
    }
    
    /// Find one type by id
    /// - Parameter id: Int
    func findType(_ id: Int)->TypeVehicleSource? {
        let realm = try! Realm()
        let data = realm.objects(TypeVehicleSource.self).filter("id == \(id)")
        
        return data.count > 0 ? data.first : nil
    }
    
    /// Remove vehicle
    /// - Parameters:
    ///   - vehicle: VehicleSource
    ///   - completion: Bool success
    func remove(_ vehicle: VehicleSource, completion: @escaping (Bool) -> ()) {
        let realm = try! Realm()
        realm.delete(vehicle)
        
        completion(true)
    }
    
}
