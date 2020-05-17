//
//  ActionViewController.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation
import UIKit

class ActionViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var fieldPlates: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    var typeId = TypeUtil.TYPE_OFFICAL
    
    var callback : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.initialize()
    }
    
    @IBAction func hideView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        self.view.endEditing(true)
        
        if !self.fieldPlates.text!.isEmpty {
            self.doAction()
        }else {
            self.showError("Es necesario ingresar placas")
        }
    }
    
    /// Initialize screen
    private func initialize() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        var title: String?
        
        if self.typeId == TypeUtil.TYPE_OFFICAL {
            title = TypeUtil.TEXT_OFFICIAL
        }else if self.typeId == TypeUtil.TYPE_RESIDENT {
            title = TypeUtil.TEXT_OFFICIAL
        }else if self.typeId == TypeUtil.TYPE_VISITOR {
            title = TypeUtil.TEXT_VISITOR
        }else if self.typeId == TypeUtil.TYPE_ENTRY {
            title = TypeUtil.TEXT_ENTRY
        }else {
            title = TypeUtil.TEXT_DEPARTURE
        }
        
        self.lblTitle.text = title
        
        self.modifyView()
    }
    
    /// Modify view elements
    private func modifyView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.btnSave.layer.cornerRadius = 8
        
        addToolBar(self.fieldPlates)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.alertView.addGestureRecognizer(swipeDown)
        
        self.animateView()
    }
    
    /// Execute actions with plates
    private func doAction() {
        let vehicle = VehicleModel.instance.findByPlates(self.fieldPlates.text!)
        let type = VehicleModel.instance.findType(self.typeId)
        
        if self.typeId == TypeUtil.TYPE_OFFICAL || self.typeId == TypeUtil.TYPE_RESIDENT {
            self.registerVehicle(vehicle, type: type)
        }else if self.typeId == TypeUtil.TYPE_ENTRY {
            self.registerEntry(vehicle, type: type)
        }else {
            self.registerDeparture(vehicle)
        }
    }
    
    /// Register vehicles
    /// - Parameters:
    ///   - vehicle: VehicleSource
    ///   - type: TypeVehicleSource
    private func registerVehicle(_ vehicle: VehicleSource?, type: TypeVehicleSource?) {
        if vehicle == nil {
            StayModel.instance.save(self.fieldPlates.text!, type: type!) { (success, msg) in
                if success {
                    self.showAlert(msg) {
                        self.callback?()
                        self.dismiss(animated: true, completion: nil)
                    }
                }else {
                    self.showError(msg)
                }
            }
        }else {
            self.showError(TypeUtil.TEXT_ERROR_SAVE)
        }
    }
    
    /// Register vehicle entry
    /// - Parameters:
    ///   - vehicle: VehicleSource
    ///   - type: TypeVehicleSource
    private func registerEntry(_ vehicle: VehicleSource?, type: TypeVehicleSource?) {
        var typeTemp: TypeVehicleSource?
        
        if vehicle != nil {
            if vehicle!.type!.id != TypeUtil.TYPE_OFFICAL {
                StayModel.instance.update(vehicle!, isParked: true) { (success, msg) in
                    if success {
                        self.showAlert(msg) {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else {
                        self.showError(msg)
                    }
                }
            }else {
                typeTemp = VehicleModel.instance.findType(vehicle!.type!.id)!
                
                StayModel.instance.save(self.fieldPlates.text!, type: typeTemp!, isParked: true) { (success, msg) in
                    if success {
                        self.showAlert(msg) {
                            self.callback?()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else {
                        self.showError(msg)
                    }
                }
            }
        }else {
            self.showOptionAlert(TypeUtil.TEXT_SAVE_VISITOR) { (success) in
                if success {
                    typeTemp = VehicleModel.instance.findType(TypeUtil.TYPE_VISITOR)!
                    
                    StayModel.instance.save(self.fieldPlates.text!, type: typeTemp!, isParked: true) { (success, msg) in
                        if success {
                            self.showAlert(msg) {
                                self.callback?()
                                self.dismiss(animated: true, completion: nil)
                            }
                        }else {
                            self.showError(msg)
                        }
                    }
                }else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    /// Register vehicle departure
    /// - Parameter vehicle: VehicleSource
    private func registerDeparture(_ vehicle: VehicleSource?) {
        if vehicle != nil {
            StayModel.instance.update(vehicle!, isParked: false, completion: { (success, msg) in
                if success {
                    self.showAlert(msg) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }else {
                    self.showError(msg)
                }
            })
        }else {
            self.showError(TypeUtil.TEXT_ERROR_DEPARTURE)
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .down {
            let transition: CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromBottom
            self.view.window!.layer.add(transition, forKey: nil)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    /// Animate view
    private func animateView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    /// Adjust keyboard to field text show
    ///
    /// - Parameter notification: NSNotification
    @objc func keyboardWillShow(_ notification: NSNotification){
        self.scrollView.contentInset = self.keyboardShow(notification, scrollView: self.scrollView)
    }
    
    /// Adjust keyboard to field text hide
    ///
    /// - Parameter notification: NSNotification
    @objc func keyboardWillHide(_ notification: NSNotification){
        self.scrollView.contentInset = self.keyboardHide(notification)
    }
    
}
