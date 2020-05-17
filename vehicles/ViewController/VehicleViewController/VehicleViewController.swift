//
//  VehicleViewController.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation
import UIKit

class VehicleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    private var list = [StaySource]()
    var typeId: Int = TypeUtil.TYPE_OFFICAL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: UIButton) {
        let alertCtrl = self.alertController
        alertCtrl.typeId = self.typeId
        alertCtrl.callback = {
            self.loadData()
        }
        
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    /// Initialize screen
    private func initialize() {
        self.title = self.typeId == TypeUtil.TYPE_OFFICAL ? "VEHÍCULOS OFICIALES" : "VEHÍCULOS RESIDENTES"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.modifyView()
        self.loadData()
    }
    
    private func modifyView() {
        self.btnAdd.layer.cornerRadius = self.btnAdd.bounds.height / 2
    }
    
    /// Load data vehicle
    private func loadData() {
        StayModel.instance.findStay(typeId) { (data) in
            if data.count > 0 {
                self.list = data
                
                self.tableView.reloadData()
            }else {
                self.tableView.isHidden = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VehicleTableCell
        let entity = self.list[indexPath.row]
        
        cell.lblType.text = entity.vehicle?.type?.desc
        cell.lblPlates.text = entity.vehicle?.plates
        cell.lblTime.text = "0 minutos"
        
        if entity.start_date != nil {
            if self.typeId == TypeUtil.TYPE_RESIDENT || self.typeId == TypeUtil.TYPE_VISITOR {
                let endDate = entity.is_parked ? Date() : entity.end_date

                cell.lblTime.text = entity.is_parked ? "\(Date().minutes(entity.start_date!, end: endDate!) + entity.total) minutos" : "\(entity.total) minutos"
            }else {
                let date = entity.is_parked ? entity.start_date! : entity.end_date!
                let title = entity.is_parked ? "Ingreso:" : "Salida:"
                
                cell.lblTime.text = "\(date.hour("HH:mm")) hrs"
                cell.lblTitle.text = title
            }
        }
        
        cell.imgStatus.image = UIImage(systemName: "circle.fill")!
        cell.imgStatus.tintColor = entity.is_parked ? .green : .darkGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
