//
//  MockServer.swift
//  DeliveryScheduler
//
//  Created by Wendong Yang on 3/9/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import Foundation

class MockServer{
    class func getNewOrders()->[Order]{
        var orders :[Order] = []
        let name = "Alex"
        let tip = 2.2
        let time = Date()
        
        let order1 = Order(id: "o1",name: name, address: "3009+S+Union,chicago+IL", tip: tip, time: time.addingTimeInterval(5*60))
        let order2 = Order(id: "o2",name: name, address: "2725+S+princeton,chicago+IL", tip: tip, time: time.addingTimeInterval(30*60))
        let order3 = Order(id: "o3",name: name, address: "55+w+chestnut,chicago+IL", tip: tip, time: time.addingTimeInterval(25*60))
        let order4 = Order(id: "o4",name: name, address: "360+e+s+water,chicago+IL", tip: tip, time: time.addingTimeInterval(40*60))
        let order5 = Order(id: "o5",name: name, address: "420+w+illinois,chicago+IL", tip: tip, time: time.addingTimeInterval(60*35))
        orders = [order1,order2,order3,order4,order5]
        
        return orders
    }
}
