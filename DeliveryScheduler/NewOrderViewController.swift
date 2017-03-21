//
//  NewOrderViewController.swift
//  DeliveryScheduler
//
//  Created by Wendong Yang on 2/18/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit
class NewOrderViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var confirmOrderViewController: ConfirmOrderViewController? = nil
    let orderManager = OrderManager.getInstance
    var waitingOrders :[Order] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        waitingOrders = orderManager.waitingOrders

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        waitingOrders = orderManager.waitingOrders
        tableView.reloadData()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return waitingOrders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath) as! OrderTableViewCell
        let order = waitingOrders[indexPath.row]
        cell.name.text = "Name: \(order.name)"
        cell.address.text = "Address: \(order.address.replacingOccurrences(of: "+", with: " "))"
        let date = order.time
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        cell.deliverTime.text = "Deliver By: \(hour):\(minutes)"
        cell.tipAmount.text = "Tip: $\(order.tip.description)"
        
        return cell
    }
    // implement the swipe buttons
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let accept = UITableViewRowAction(style: .normal, title: "Accept"){ action, index in
            print("accept")
            let order = self.waitingOrders.remove(at: index.row)
            self.orderManager.waitingOrders.remove(at: index.row)
            self.orderManager.loadOrder(orderNumber: order.id, order: order)
            tableView.deleteRows(at: [index], with: UITableViewRowAnimation.automatic)
        }
        let decline = UITableViewRowAction(style: .normal, title: "Decline"){ action, index in
            print("decline")
            self.waitingOrders.remove(at: index.row)
            self.orderManager.waitingOrders.remove(at: index.row)
            tableView.deleteRows(at: [index], with: UITableViewRowAnimation.automatic)
        }
        accept.backgroundColor = .green
        decline.backgroundColor = .red
        return [accept,decline]
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    @IBAction func refresh(_ sender: UIButton) {
        tableView.reloadData()
       // print(orderManager.orders)
    }
    
    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "confirmOrder" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let order = waitingOrders[indexPath.row]
                let controller = segue.destination as! ConfirmOrderViewController
                controller.detailedItem = order
                controller.indexPath = indexPath
               
  
            }
        }
    }
 
    

}


