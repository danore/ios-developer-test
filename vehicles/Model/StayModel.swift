//
//  StayModel.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class StayModel {
    
    static var instance = StayModel()
    
    private init() {}
    
    /// Save stay data
    /// - Parameters:
    ///   - plates: String plates vehicle
    ///   - type: TypeVehicleSource type vehicle
    ///   - isParked: Bool status vehicle
    ///   - completion: (Bool, String)
    func save(_ plates: String, type: TypeVehicleSource, isParked: Bool = false, completion: @escaping (Bool, String) -> ()) {
        do {
            let realm = try Realm()
            
            try! realm.write {
                let stay = StaySource()
                
                VehicleModel.instance.save(plates, type: type) { (data, msg) in
                    if data != nil {
                        stay.id = stay.incrementId()
                        stay.is_parked = isParked
                        stay.vehicle = data
                        
                        if isParked {
                            stay.start_date = Date()
                        }

                        realm.add(stay)
                        
                        completion(true, TypeUtil.TEXT_SUCCESS)
                    }else {
                        completion(false, msg)
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedFailureReason!)
            completion(false, TypeUtil.TEXT_EXIST_DATA)
        }
    }
    
    /// Update stay
    /// - Parameters:
    ///   - vehicle: VehicleSource
    ///   - isParked: Bool
    ///   - completion: (Bool, String)
    func update(_ vehicle: VehicleSource, isParked: Bool, completion: @escaping (Bool, String) -> ()) {
        do {
            let realm = try Realm()
            let stay = self.findByVehicle(vehicle)
            var message = TypeUtil.TEXT_SUCCESS
            
            if stay != nil {
                try! realm.write {
                    stay?.is_parked = isParked
                    var minutes = 0
                    
                    if isParked {
                        stay?.start_date = Date()
                    }else {
                        message = TypeUtil.TEXT_DEPARTURE_SUCCESS
                        stay?.end_date = Date()
                    }
                    
                    if stay!.end_date != nil && !isParked {
                        minutes = Date().minutes(stay!.start_date!, end: stay!.end_date!)
                    }
                    
                    if vehicle.type?.id == TypeUtil.TYPE_RESIDENT {
                        stay?.total += minutes
                    }else if vehicle.type?.id == TypeUtil.TYPE_VISITOR {
                        stay?.total_amount = (vehicle.type!.amount * Double(minutes))
                        
                        message = "El tiempo fue de \(minutes) minutos, el total a pagar es: \(stay!.total_amount.asUsdCurrency)"
                    }
                    
                    realm.add(vehicle)
                    
                    if !isParked && vehicle.type?.id == TypeUtil.TYPE_VISITOR {
                        
                        VehicleModel.instance.remove(vehicle) { (success) in
                            if success {
                                self.remove(stay!)
                            }
                        }
                    }
                                    
                    completion(true, message)
                }
            }else {
                completion(false, TypeUtil.TEXT_ERROR_DEPARTURE)
            }
        } catch let error as NSError {
            print(error.localizedFailureReason!)
            completion(false, TypeUtil.TEXT_EXIST_DATA)
        }
    }
    
    /// Updat data resident
    func updateResident() {
        let realm = try! Realm()
        let data = realm.objects(StaySource.self).filter("vehicle.type.id == \(TypeUtil.TYPE_RESIDENT)")
        
        for info in data {
            info.total = 0

            realm.add(info)
        }
    }
    
    /// Find stays by status
    /// - Parameters:
    ///   - type: Bool type vehicle
    ///   - completion: List StaySource
    func findStay(_ type: Int, completion: @escaping ([StaySource]) -> ()) {
        let realm = try! Realm()
        var result = [StaySource]()
        
        let data = realm.objects(StaySource.self).filter("vehicle.type.id == \(type)")
        
        for info in data {
            result.append(info)
        }
        
        completion(result)
    }
    
    /// Find stay by vehicle
    /// - Parameter vehicle: VehicleSource
    func findByVehicle(_ vehicle: VehicleSource)->StaySource? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "vehicle = %@", vehicle)
        let data = realm.objects(StaySource.self).filter(predicate)
        
        return data.count > 0 ? data.first : nil
    }
    
    /// Remove stay data
    /// - Parameter stay: StaySource
    func remove(_ stay: StaySource) {
        let realm = try! Realm()
        realm.delete(stay)
    }
    
    /// Start month data
    func startMonth() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(realm.objects(StaySource.self).filter("vehicle.type.id == \(TypeUtil.TYPE_OFFICAL)"))
            
            self.updateResident()
        }
    }
    
}
