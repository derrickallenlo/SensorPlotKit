//
//  SPKDataSource.swift
//  SensorPlotKit_Demo
//
//  Created by Derrick on 11/15/15.
//  Copyright © 2015 ___Derrick_Lo___. All rights reserved.
//

import Foundation


import Foundation
import CorePlot


protocol SPKModelDataSource {
    func dataFromSensor(sender: SPKDataSource) -> Double
    func plotParamsFromModel(sender: SPKDataSource) -> SPKPlotProtocol
}

class SPKDataSource : SPKPlotViewDataSource {
    
    var dataSource : SPKModelDataSource?
    var displayBufferSize : Int!
    var displayBuffer : [Double]!
    var plotParams : SPKPlotProtocol!
    var plotNeedsUpdate = false
    var currentIndex : Int!
    var currentNumberOfPoints : Int!
    
    func setupDataSource() {
        self.plotParams = dataSource!.plotParamsFromModel(self)
        displayBufferSize = plotParams.duration * plotParams.samplingRate
        
        self.displayBuffer = [Double](count: displayBufferSize, repeatedValue: 0.0)
        currentIndex = 0
    }
    
    func flushSensorDataBuffer() {
        
        displayBuffer.insert(dataSource!.dataFromSensor(self), atIndex: currentIndex)
        
        if currentIndex < displayBufferSize{
            currentIndex!++
        }
        else
        {
            currentIndex = 0
        }
        
    }
    
    //SPKPlotViewDataSource Protocol
    func getPlotParamsFromDataSource(sender: SPKPlotView, tag : Int) -> SPKPlotProtocol {
        
        //VALIDATE PLOT PARAMETERS HERE
        return dataSource!.plotParamsFromModel(self)
    }
    
    func numberOfPointsForPlot(sender: SPKPlotView, tag : Int) -> UInt {
        
        return UInt(currentIndex)
    }
    
    func numberForPlot(sender: SPKPlotView, field fieldEnum: UInt, recordIndex idx: UInt, tag : Int) -> AnyObject! {
        
        switch fieldEnum {
            
        //Defining X-Axis 0 (0 to Display Buffer Size - 1)
        case UInt(CPTScatterPlotField.X.rawValue):
            return idx
            
        //Return corresponding Y value for X (idx) within Display Buffer
        case UInt(CPTScatterPlotField.Y.rawValue):
            return displayBuffer[Int(idx)]
            
        default:
            return 0
            
        }
    }
}