//
//  ManualEnterViewController.swift
//  DeliveryScheduler
//
//  Created by Wendong Yang on 3/14/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit

class ManualEnterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func editEnded(_ sender: UIControl) {
        address.resignFirstResponder()
        name.resignFirstResponder()
        tip.resignFirstResponder()
        date.resignFirstResponder()
        orderNumber.resignFirstResponder()
    }
    
    @IBOutlet weak var orderNumber: UITextField!
    
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var tip: UITextField!
    
    @IBOutlet weak var name: UITextField!
    @IBAction func submit(_ sender: UIButton) {
        if checkInputs(){
            if let name = name.text{
                if let orderNumber = orderNumber.text{
                    if let address = address.text{
                        if let tip = tip.text {
                            let manager = OrderManager.getInstance
                            manager.loadOrder(orderNumber: orderNumber, order: Order(id: orderNumber, name: name, address: address.replacingOccurrences(of: " ", with: "+"), tip: Double(tip)!, time: date.date))
                            let alert = UIAlertController(title: "Successfully added \(orderNumber)", message: "keep up the good work!", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                                self.address.resignFirstResponder()
                                self.name.resignFirstResponder()
                                self.tip.resignFirstResponder()
                                self.date.resignFirstResponder()
                                self.orderNumber.resignFirstResponder()
                                self.performSegue(withIdentifier: "backToNewOrders", sender: self)
                                
                            })
                            alert.addAction(action)
                            present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        let alert = UIAlertController(title: "Invalid Input", message: "Please check your inputs", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func checkInputs()->Bool{
        if orderNumber.text == ""{
            return false
        }
        if name.text == ""{
            return false
        }
        if address.text == ""{
            return false
        }
        if tip.text == ""{
            return false
        }
        return true
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
