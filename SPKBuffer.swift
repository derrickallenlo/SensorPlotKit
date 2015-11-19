//
//  SPKBuffer.swift
//  ECGMonitor
//
//  Created by Derrick on 8/17/15.
//  Copyright (c) 2015 ___Derrick_Lo___. All rights reserved.
//

import Foundation

public class SPKBuffer {

    private var buffer : [Double]
    private var head : Int = 0

    init() {
        buffer = [Double]()
    }
    
    func addDataToBuffer(newValue : Double) {
        buffer.append(newValue)
    }
    
    func addDataToBuffer(newValues : [Double]) {
        buffer += newValues
    }
    
    func getCount() -> Int {
        return self.buffer.count
    }
    
    func consumeData(count : Int) -> [Double]
    {
        let range = Range<Int>(start: head, end: count)
        let dataToConsume : [Double] = Array(buffer[head..<count])
        buffer.removeRange(range)
        
        return dataToConsume
    }
    
    func consumeDatum() -> Double
    {
        return buffer.popLast()!
    }
}