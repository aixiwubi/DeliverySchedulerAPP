//
//  ScheduleTableViewController.swift
//  DeliveryScheduler
//
//  Created by Wendong Yang on 3/9/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {
    var scheduledOrders: [Order] = []
    let orderManager = OrderManager.getInstance
    
    @IBOutlet weak var taskProgress: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledOrders = orderManager.accepted
        
        
        taskProgress.hidesWhenStopped = true
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        scheduledOrders = orderManager.accepted
        tableView.reloadData()
        
        
    }
    @IBAction func rankTheOrders(_ sender: UIButton) {
        //implementing the activity indicator
        scheduledOrders.removeAll()
        tableView.reloadData()
        taskProgress.startAnimating()
        let verticalCenter: CGFloat = UIScreen.main.bounds.size.height / 2.0
        let horizontalCenter: CGFloat = UIScreen.main.bounds.size.width / 2.0
        
        taskProgress.center = CGPoint(x: horizontalCenter, y: verticalCenter)
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            //do the https request and sort the order
            if let orders = self.orderManager.sortByMinLate(){
                // when task finished stop acitivity indicator and reloard the data 
                DispatchQueue.main.async {
                    self.taskProgress.stopAnimating()
                    self.scheduledOrders = orders
                    self.tableView.reloadData()
                }
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return scheduledOrders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath) as! OrderTableViewCell
        // Configure the cell...
        
        let order = scheduledOrders[indexPath.row]
       // print(order)
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
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailedView" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let order = scheduledOrders[indexPath.row]
                let controller = segue.destination as! DetailedViewController
                controller.order = order
                controller.indexPath = indexPath
                
            }
        }
    }
    
    
}
