//
//  BillViewController.swift
//  vehicles
//
//  Created by Desarollo on 5/16/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation
import UIKit

class BillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var list = [StaySource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Initialize screen
    private func initialize() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        self.loadData()
    }
    
    /// Load resident data
    private func loadData() {
        StayModel.instance.findStay(TypeUtil.TYPE_RESIDENT) { (data) in
            self.list = data
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BillTableCell
        let entity = self.list[indexPath.row]
        
        cell.lblPlates.text = "Placas: \(entity.vehicle!.plates!)"
        cell.lblAmount.text = "Monto a pagar: \((Double(entity.total) * entity.vehicle!.type!.amount).asUsdCurrency)"
        cell.lblTime.text = "Tiempo: \(entity.total) minutos"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
