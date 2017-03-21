//
//  ConfirmOrderViewController.swift
//  DeliveryScheduler
//
//  Created by Wendong Yang on 3/9/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var deliverTime: UILabel!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tip: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var detailedItem: Order?{
        didSet {
           // print("set detailed order")
            self.updateView()
            
        }
        
    }
    var indexPath: IndexPath?
    func updateView(){
       // print("update view")
        if let order = detailedItem{
         //   print(order)
            if let label = self.name{
               // print("set name")
                label.text = "Customer Name: \(order.name)"
            }
            if let label = self.address{
                label.text = "Address: \(order.address.replacingOccurrences(of: "+", with: " "))"
            }
            if let label = self.deliverTime{
                let date = order.time
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                label.text = "Deliver by: \(hour):\(minutes)"
            }
            if let label = self.tip{
                label.text = "Tip: $\(order.tip.description)"
            }
        }
    }
    @IBAction func processOrder(_ sender: UIButton) {
        if let command = sender.titleLabel?.text{
            if command == "Accept"{
                // handle accpet
                let alert = UIAlertController(title: "Accept Order", message: "Would you like to accept this order?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
                    let manager = OrderManager.getInstance
                    //add accepted order here
                    manager.loadOrder(orderNumber: self.detailedItem!.id, order: self.detailedItem!)
                    if let index = self.indexPath{
                        manager.waitingOrders.remove(at: index.row)
                    }
                    self.performSegue(withIdentifier: "backToNewOrders", sender: self)
                })
                let no = UIAlertAction(title: "No", style: .default, handler: nil)
                alert.addAction(no)
                alert.addAction(yes)
                
                present(alert, animated: true, completion: nil)
                
            }
            else{
                let alert = UIAlertController(title: "Decline Order", message: "Would you like to Decline this order?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
                    let manager = OrderManager.getInstance
                    if let index = self.indexPath{
                        manager.waitingOrders.remove(at: index.row)
                        
                    }
                    self.performSegue(withIdentifier: "backToNewOrders", sender: self)

                })
                let no = UIAlertAction(title: "No", style: .default, handler: nil)
                alert.addAction(no)
                alert.addAction(yes)
                
                present(alert, animated: true, completion: nil)
                
            }
        }
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
