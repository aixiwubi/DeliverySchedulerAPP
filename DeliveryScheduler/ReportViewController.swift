//
//  ReportViewController.swift
//  DeliveryScheduler
//
//  Created by Wendong Yang on 3/14/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = OrderManager.getInstance
        delivered.text = manager.settled.count.description
        onTime.text = manager.onTime.description
        let orders = manager.settled
        var total = 0.0
        for order in orders{
            total += order.tip
            
        }
        earning.text = total.description
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var delivered: UILabel!
    @IBOutlet weak var onTime: UILabel!

    @IBOutlet weak var earning: UILabel!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
