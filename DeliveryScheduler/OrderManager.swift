//
//  OrderManager.swift
//  DeliveryScheduler
//
//  Created by Wendong Yang on 2/18/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import Foundation
struct Order {
    var id: String
    var name: String
    var address: String
    var tip: Double
    var time: Date
    
    
    init(id: String,name: String, address:String, tip: Double, time: Date) {
        self.id = id
        self.name = name
        self.address = address
        self.tip = tip
        self.time = time
    }
    
}

class OrderManager{
    static let getInstance: OrderManager = OrderManager()
    var orders = [String:Order]()
    var accepted:[Order] = []
    var waitingOrders: [Order] = MockServer.getNewOrders()
    var settled: [Order] = []
    var onTime: Int = 0
    func sortByMinLate()->[Order]?{
        var orderPath:[Order]? = nil
        orderPath = self.minLate(currentLocation: "62+e+madison,chicago+IL", orders: accepted, startTime: Date()).0
        if let orders = orderPath{
            accepted = orders
        }
        return orderPath
    }
    func loadOrder(orderNumber:String, order:Order){
        orders[orderNumber] = order
        accepted.append(order)
    }
    
    func getOptimalOrderPath()-> [Order]?{
        var orderPath:[Order]? = nil
        //need current location here
        orderPath = self.bestChoice(start:"62+e+madison,chicago+il",orders: self.accepted, timeCost: Int.max).0
        if let orders = orderPath{
            accepted = orders
        }
        return orderPath
    }
    func settleOrder(index: Int){
        settled.append(accepted.remove(at: index))
    }
    
    private func bestChoice(start:String, orders: [Order], timeCost: Int) -> ([Order],Int){
        var timeCostTemp = timeCost
        var path:[Order] = []
        if orders.count == 1 {
            path.append(orders[0])
            return (path,0)
        }
        for i in 0..<orders.count{
            var tempOrders = orders
            let currentOrder = tempOrders.remove(at: i)
            let result = bestChoice(start: currentOrder.address, orders: tempOrders, timeCost: timeCostTemp)
            if let time = GoogleMapService.getTimeCostSync(startLocation: start, endLocation: orders[i].address){
                //print("time cost from \(start) to \(orders[i].address) is \(time)")
                if time + result.1<timeCostTemp{
                    path = result.0
                    path.append(orders[i])
                    timeCostTemp = time + result.1
                }
            }
        }
        return (path,timeCostTemp)
    }
    
    private func minLate(currentLocation: String, orders: [Order], startTime:Date)->([Order],Date,Int){
        var path:[Order] = []
        if orders.count == 0{
            return (path,startTime.addingTimeInterval(0.0),0)
        }
        var minsLate = Int.max
        var returnCurrentTime = startTime
        for i in 0..<orders.count{
            var tempOrders = orders
            let currentOrder = tempOrders.remove(at: i)
            let result = minLate(currentLocation:currentOrder.address,orders: tempOrders, startTime: startTime)
            let currentTime = result.1
            if let timeCost = GoogleMapService.getTimeCostSync(startLocation: currentLocation, endLocation: orders[i].address){
                let finishTime = currentTime.addingTimeInterval(Double(timeCost))
                let thisOrderLate = Int(finishTime.timeIntervalSince(orders[i].time))
                if thisOrderLate < minsLate{
                    path = result.0
                    path.append(orders[i])
                    minsLate = thisOrderLate
                    returnCurrentTime = finishTime
                }
                
            }
            
        }
        return (path, returnCurrentTime, minsLate)
    }
    
    
}


