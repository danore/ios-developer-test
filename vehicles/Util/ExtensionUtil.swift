//
//  ExtensionUtil.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import UIKit

protocol MaterialView {
    func elevate(_ elevation: Double)
}

extension UIView: MaterialView {

    /// Elevate view
    ///
    /// - Parameter elevation: Double
    func elevate(_ elevation: Double) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: elevation)
        self.layer.shadowRadius = CGFloat(elevation)
        self.layer.shadowOpacity = 0.24
    }
    
    /// Line dashed border
    ///
    /// - Parameters:
    ///   - color: UIColor
    ///   - width: CGFloat
    func addDashedBorder(_ color: UIColor, width: CGFloat) {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }

}

extension UIColor {
    
    convenience init(_ hex: String) {
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        let scanner = Scanner(string: cString)
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
}

extension Date {
    
    func minutes(_ start: Date, end: Date) -> Int {
        let diff = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)

        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
        return minutes
    }
    
    func hour(_ format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
}

extension UIImage {
    
    func imageWithImage(_ newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))  )
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

extension UIViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func addToolBar(_ textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = UIColor.white
        let doneButton = UIBarButtonItem(image: UIImage(systemName: "chevron.compact.down")?.imageWithImage(CGSize(width: 35.0, height: 30.0)), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    /// Done choose
    @objc func donePressed(){
        view.endEditing(true)
    }
    
    func showError(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ text: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: "Exitoso", message: text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            completion()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showOptionAlert(_ text: String, completion: @escaping (Bool) -> ()) {
        let alert = UIAlertController(title: "Alerta", message: text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { action in
            completion(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension Double {
    
    ///  Format currency
    var asUsdCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
       
        return formatter.string(from: NSNumber(value: self))!
    }
    
}
