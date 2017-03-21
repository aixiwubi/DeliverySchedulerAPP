//
//  DetailedViewController.swift
//  DeliveryScheduler
//
//  Created by Wendong Yang on 3/9/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class DetailedViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    
    var indexPath :IndexPath?
    var order: Order?{
        didSet{
            updatePlaceMark()
        }
    }
    var selectedPin: MKPlacemark?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //update place mark when it is set
    func updatePlaceMark(){
        guard let address = self.order?.address else{return}
        //get lat and lng using reverse geo coding
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    // set mapview annoatation and focus on place mark
                    let annotation = MKPlacemark(placemark: placemarks.first!)
                    self.mapView.addAnnotation(annotation)
                    self.selectedPin = annotation
                    self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                 
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func getDirection(_ sender: UIButton) {
        startNavigation()
    }
    //start map app to do the navigation
    func startNavigation(){
        guard let selectedPin = selectedPin else { return }
        // pass the place mark for destination
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)

    }
    @IBAction func delivered(_ sender: UIButton) {
        // set order to be delivered
        let manager = OrderManager.getInstance
        if let index = indexPath{
            manager.settleOrder(index: index.row)
            let current = Date()
            if let order = order{
                //if the order is on time, we record that
                if current < order.time{
                manager.onTime += 1
                }
            }
            let alert = UIAlertController(title: "congratulations", message: "You have successfully delivered the order", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                self.performSegue(withIdentifier: "backToAccepted", sender: self)
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
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
