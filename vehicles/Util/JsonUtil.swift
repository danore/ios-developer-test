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
    
    /// Read json files
       ///
       /// - Parameter name: String
       /// - Returns: JSON SwiftyJson
       static func readJson(_ name: String) ->JSON {
           var result:JSON!
           
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
           
           return result
       }
    
}
