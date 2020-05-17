//
//  MainViewController.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewEntry: UIView!
    @IBOutlet weak var viewDeparture: UIView!
    
    var screenSize: CGRect!
    var list = [MenuEntity]()
    var typeId = TypeUtil.TYPE_OFFICAL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    @IBAction func registerEntry(_ sender: UIButton) {
        self.typeId = TypeUtil.TYPE_ENTRY
        self.openAction()
    }
    
    @IBAction func registerDeparture(_ sender: UIButton) {
        self.typeId = TypeUtil.TYPE_DEPARTURE
        self.openAction()
    }
    
    /// Initialize screen
    private func initialize() {
        self.createMenu()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.modifyView()
    }
    
    /// Modify view elements
    private func modifyView() {
        self.screenSize = self.collectionView.layer.bounds
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.screenSize.width/2, height: self.screenSize.height/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.collectionView!.collectionViewLayout = layout
        self.viewEntry.layer.cornerRadius = 4
        self.viewDeparture.layer.cornerRadius = 4
    }
    
    
    /// Create menu
    private func createMenu() {
        let json = JsonUtil.readJson(TypeUtil.FILE_MENU)
     
        for info in json.arrayValue {
            let entity = MenuEntity()
            entity.name = info["name"].stringValue
            entity.icon = info["icon"].stringValue
            entity.type = info["type"].intValue
            
            self.list.append(entity)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuCollectionCell
        let menu = self.list[indexPath.row]
                
        cell.addDashedBorder(UIColor("#4B0082"), width: 0.2)
        cell.lblDesc.text = menu.name
        cell.imgIcon.image = UIImage(systemName: menu.icon!)
        
        return cell
    }
    
    /// Detect tap in tableview
    ///
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - indexPath: IndexPathx
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entity = self.list[indexPath.row]
        
        if entity.type == TypeUtil.TYPE_OFFICAL || entity.type == TypeUtil.TYPE_RESIDENT {
            self.typeId = entity.type
            self.performSegue(withIdentifier: TypeUtil.SEGUE_VEHICLE, sender: self)
        }else if entity.type == TypeUtil.TYPE_ENTRY || entity.type == TypeUtil.TYPE_DEPARTURE {
            self.openAction()
        }else if entity.type == TypeUtil.TYPE_START {
            self.monthStart()
        }else {
            self.performSegue(withIdentifier: TypeUtil.SEGUE_BILL, sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height/2)
    }
    
    /// Start month data
    private func monthStart() {
        self.showOptionAlert(TypeUtil.TEXT_START_MONTH) { (success) in
            if success {
                StayModel.instance.startMonth()
            }
        }
    }
    
    /// Open alert
    private func openAction() {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: TypeUtil.CONTROLLER_ACTION) as! ActionViewController
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        customAlert.typeId = self.typeId
        
        self.present(customAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController = segue.destination as! UINavigationController
        
        if segue.identifier == TypeUtil.SEGUE_VEHICLE {
            if let destViewController : VehicleViewController = destViewController.topViewController as? VehicleViewController {
                destViewController.typeId = self.typeId
            }
        }
    }
    
}
