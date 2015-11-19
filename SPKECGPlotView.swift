//
//  SPKECGPlotView.swift
//  SensorPlotKit_Demo
//
//  Created by Derrick on 11/15/15.
//  Copyright © 2015 ___Derrick_Lo___. All rights reserved.
//

import Foundation
import CorePlot

public class SPKECGPlotView: SPKPlotView {
    
    override func configurePlot()
    {
        super.configurePlot()
        
        let plotParams = dataSource.getPlotParamsFromDataSource(self, tag: self.tag)
        
        let MIN_NUMBER_OF_MINOR_TICKS_PER_MV : Double = 0.1
        let MIN_NUMBER_OF_MAJOR_TICKS_PER_MV : Double = 0.5
        let MIN_NUMBER_OF_MAJOR_TICKS_PER_SEC : Double =  (Double(plotParams.samplingRate) / 5)
        let MIN_NUMBER_OF_MINOR_TICKS_PER_SEC : Double = MIN_NUMBER_OF_MAJOR_TICKS_PER_SEC / 5
        
        let axisSet = self.graph.axisSet as! CPTXYAxisSet
        
        let xAxis = axisSet.xAxis as CPTXYAxis!
        let yAxis = axisSet.yAxis as CPTXYAxis!
        
        //Grid Line styles
        let majorAxisLineSytle = CPTMutableLineStyle()
        majorAxisLineSytle.lineColor = CPTColor.redColor().colorWithAlphaComponent(CGFloat(0.4))
        majorAxisLineSytle.lineWidth = 0.75
        
        let minorAxisLineSytle = CPTMutableLineStyle()
        minorAxisLineSytle.lineColor = CPTColor.redColor().colorWithAlphaComponent(CGFloat(0.4))
        minorAxisLineSytle.lineWidth = 0.25
        
        //Axes style
        //X Axis
        xAxis.labelingPolicy = CPTAxisLabelingPolicy.None
        xAxis.majorGridLineStyle = majorAxisLineSytle
        xAxis.minorGridLineStyle = minorAxisLineSytle
        xAxis.hidden = true  //Hides baseline xAxis with ticks
        
        //Y Axis
        yAxis.labelingPolicy = CPTAxisLabelingPolicy.None
        yAxis.majorGridLineStyle = majorAxisLineSytle
        yAxis.minorGridLineStyle = minorAxisLineSytle
        yAxis.hidden = true  //Hides baseline YAxis
        
        //Setup Y Grid
        let yMajorLocations = NSMutableArray()
        let yMinorLocations = NSMutableArray()
        
        for var tick = Double(plotParams.yLogicalPlotMin); tick <= Double(plotParams.yLogicalPlotCount); tick = tick + MIN_NUMBER_OF_MINOR_TICKS_PER_MV
        {
            yMinorLocations.addObject(tick)
        }
        
        for var tick = Double(plotParams.yLogicalPlotMin); tick <= Double(plotParams.yLogicalPlotCount); tick = tick + MIN_NUMBER_OF_MAJOR_TICKS_PER_MV
        {
            yMajorLocations.addObject(tick)
        }
        
        yAxis.majorTickLocations = NSSet(array: yMajorLocations as [AnyObject]) as? Set<NSNumber>
        yAxis.minorTickLocations = NSSet(array: yMinorLocations as [AnyObject]) as? Set<NSNumber>
        
        //Setup X Grid
        let xMajorLocations = NSMutableArray()
        let xMinorLocations = NSMutableArray()
        
        for var tick = Double(plotParams.xLogicalPlotMin); tick <= Double(plotParams.xLogicalPlotCount); tick = tick + MIN_NUMBER_OF_MAJOR_TICKS_PER_SEC
        {
            xMajorLocations.addObject(tick)
        }
        
        for var tick = Double(plotParams.xLogicalPlotMin); tick <= Double(plotParams.xLogicalPlotCount); tick = tick + MIN_NUMBER_OF_MINOR_TICKS_PER_SEC
        {
            xMinorLocations.addObject(tick)
        }
        
        xAxis.majorTickLocations = NSSet(array: xMajorLocations as [AnyObject]) as? Set<NSNumber>
        xAxis.minorTickLocations = NSSet(array: xMinorLocations as [AnyObject]) as? Set<NSNumber>
    }
}
