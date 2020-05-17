//
//  TypeUtil.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation

class TypeUtil {
    
    static var FILE_TYPES = "types"
    static var FILE_MENU = "menu"
    
    static var SEGUE_VEHICLE = "VehicleController"
    static var SEGUE_BILL = "BillController"
    
    static var CONTROLLER_ACTION = "ActionViewController"
    
    static var TYPE_OFFICAL = 10
    static var TYPE_RESIDENT = 20
    static var TYPE_VISITOR = 30
    static var TYPE_START = 40
    static var TYPE_PAYMENT = 50
    static var TYPE_ENTRY = 60
    static var TYPE_DEPARTURE = 70
    
    static var TEXT_OFFICIAL = "Ingresar placas para agregar vehículo de oficial"
    static var TEXT_RESIDENT = "Ingresar placas para agregar vehículo de residente"
    static var TEXT_VISITOR = "Ingresar placas para agregar vehículo de residente"
    static var TEXT_ENTRY = "Ingresar placas para registrar entrada"
    static var TEXT_DEPARTURE = "Ingresar placas para registrar salida"
    static var TEXT_ERROR_SAVE = "Registro ya existe en base de datos"
    static var TEXT_ERROR_DEPARTURE = "Vehículo no se encuentra en parqueo"
    static var TEXT_SUCCESS = "Registro ingresado correctamente"
    static var TEXT_DEPARTURE_SUCCESS = "Registro de salida de vehículo exitosa"
    static var TEXT_EXIST_DATA = "Error en base de datos al registrar entrada de vehículo"
    static var TEXT_VEHICLE_SUCCESS = "Vehículo registrado correctamente"
    static var TEXT_SAVE_VISITOR = "No existe vehículo en base de datos ¿Deseas guardarlo visitante?"
    static var TEXT_START_MONTH = "¿Deseas comenzar mes?"
    
}
