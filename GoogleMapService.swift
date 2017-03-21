//
//  GoogleMapService.swift
//  DeliveryScheduler
//
//  Created by Wendong Yang on 2/20/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import Foundation
/*
 GoogleMap service class to make api request and return the time cost from one location to another location by driving
 */
class GoogleMapService{
    //asynchronous call
    class func getTimeCostAsync(startLocation: String, endLocation:String, completion: ((_ result:String?) -> Void)!){
        let api = "AIzaSyBbsCbf7YLrs1A8EHBWhOA-HkPUfnB72kQ" //api key
        var timeCost = "" // capture api return
        // check if url is valid
        if let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(startLocation)&destination=\(endLocation)&key=\(api)"){
            let config = URLSessionConfiguration.default // Session Configuration
            let session = URLSession(configuration: config) // Load configuration into Session
            //set up task
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                // on callback if error print error
                if error != nil {
                    
                    print(error!.localizedDescription)
                    
                } else {
                    
                    do {
                        //cast data to json
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        {
                            // parsing to get the value I need
                            let routes = json["routes"] as? [[String:Any]]
                            for route in routes!{
                                if let legs = route["legs"] as? [[String:Any]]{
                                    for item in legs{
                                        if let duration = item["duration"] as? [String:Any]{
                                            if let time = duration["text"] as? String{
                                                print("the time cost is \(time)")
                                                //valid value found and invoke the call back func
                                                timeCost = time
                                                completion(timeCost)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                    } catch {
                        // there is error in json parsing
                        print("error in JSONSerialization")
                    }

                }
            })
            // start the task
            task.resume()}
    }
    //synchronous call
    class func getTimeCostSync(startLocation:String,endLocation:String) -> Int?{
        var data: Data?, error: Error?
        var timeCost = 0
        let semaphore = DispatchSemaphore(value: 0)
        let api = "AIzaSyBbsCbf7YLrs1A8EHBWhOA-HkPUfnB72kQ" //api key
        // check if url is valid
        if let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(startLocation)&destination=\(endLocation)&key=\(api)"){
            let config = URLSessionConfiguration.default // Session Configuration
            let session = URLSession(configuration: config) // Load configuration into Session
            session.dataTask(with: url) {
            data = $0; error = $2
            semaphore.signal()
            }.resume()
            semaphore.wait()
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                do {
                    //cast data to json
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        // parsing to get the value I need
                        let routes = json["routes"] as? [[String:Any]]
                        for route in routes!{
                            if let legs = route["legs"] as? [[String:Any]]{
                                for item in legs{
                                    if let duration = item["duration"] as? [String:Any]{
                                        if let time = duration["value"] as? Int{
                                        //   print("the time cost is \(time)")
                                            timeCost = time
                                            //valid value found and invoke the call back func
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    // there is error in json parsing
                    print("error in JSONSerialization")
                }
            }
        }
        return timeCost
    }
}
