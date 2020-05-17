//
//  JsonUtil.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation
import SwiftyJSON

class JsonUtil {
    
    /// Read json and create menu
    /// - Parameter name: String
    static func readMenu(_ name: String) ->[MenuEntity] {
        var list = [MenuEntity]()
        
        do {
            if let file = Bundle.main.url(forResource: name, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                let jsonData  = JSON(json)
                
                for info in jsonData.arrayValue {
                    let entity = MenuEntity()
                    entity.name = info["name"].stringValue
                    entity.icon = info["icon"].stringValue
                    entity.type = info["type"].intValue
                    
                    list.append(entity)
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return list
    }
    
    /// Read json file
    /// - Parameter name: String
    static func readJson(_ name: String) ->JSON {
        var result: JSON?
        
        do {
            if let file = Bundle.main.url(forResource: name, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                result = JSON(json)
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return result!
    }
}
