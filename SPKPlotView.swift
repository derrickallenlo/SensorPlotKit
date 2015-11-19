//
//  SPKPlotView.swift
//  SensorPlotKit_Demo
//
//  Created by Derrick on 11/15/15.
//  Copyright © 2015 ___Derrick_Lo___. All rights reserved.
//

import Foundation
import CorePlot

protocol SPKPlotViewDataSource : class {
    func getPlotParamsFromDataSource(sender: SPKPlotView, tag : Int) -> SPKPlotProtocol
    func numberOfPointsForPlot(sender: SPKPlotView, tag : Int) -> UInt
    func numberForPlot(sender: SPKPlotView, field fieldEnum: UInt, recordIndex idx: UInt, tag : Int) -> AnyObject!
}

@IBDesignable public class SPKPlotView: UIView {
    
    // MARK: -
    // MARK: SPKPlotView UI Designable attributes
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: -
    // MARK: QTECGLeadView Private variables
    public var graphView: CPTGraphHostingView!
    public var graph: CPTGraph!
    public var leadPlot: CPTScatterPlot!
    public var plotNeedsUpdate : Bool = false
    public var _plotDataUpdated: Bool = false
    
    private var xLogicalPlotMin = 0
    private var xLogicalPlotCount = 100
    private var yLogicalPlotMin = -4
    private var yLogicalPlotCount = 8
    
    private var plotTimer: NSTimer? = nil
    private var plotParams : SPKPlotProtocol!
    
    var dataSource :  SPKPlotViewDataSource!
    
    init() {
        super.init(frame: CGRectZero)
        dispatch_async(dispatch_get_main_queue()) {
            self.setupParams()
            self.createGraph()
            self.configurePlot()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initialization code
        dispatch_async(dispatch_get_main_queue()) {
            self.setupParams()
            self.createGraph()
            self.configurePlot()
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        dispatch_async(dispatch_get_main_queue()) {
            self.setupParams()
            self.createGraph()
            self.configurePlot()
        }
    }
    
    func setupParams() {
        plotParams = dataSource.getPlotParamsFromDataSource(self, tag: self.tag)
        
        xLogicalPlotMin = plotParams.xLogicalPlotMin
        xLogicalPlotCount = plotParams.xLogicalPlotCount
        yLogicalPlotMin = plotParams.yLogicalPlotMin
        yLogicalPlotCount = plotParams.yLogicalPlotCount
        
    }
    
    func createGraph()
    {
        self.graphView = CPTGraphHostingView(frame: self.bounds)
        self.graph = CPTXYGraph(frame: self.graphView.bounds)
        //self.graph.title = plotParams.plotName
        //self.graph.titleDisplacement = CGPointMake(0.0, 20.0) //SETUP TITLE DISPLACEMENT!!!!
        
        //Create Lead Plot
        self.leadPlot = CPTScatterPlot(frame: self.graph.frame)
        self.leadPlot.dataSource = self
        self.leadPlot.interpolation = CPTScatterPlotInterpolation.Curved
        
        self.graph.cornerRadius = self.cornerRadius
        self.graph.plotAreaFrame!.cornerRadius = self.cornerRadius
        self.graph.plotAreaFrame!.borderColor = CPTColor.redColor().colorWithAlphaComponent(CGFloat(0.4)).cgColor
        self.graph.plotAreaFrame!.borderWidth = (0.75 / 3)
        self.leadPlot.cornerRadius = self.cornerRadius
        
        self.graph.addPlot(self.leadPlot)
        self.graphView.hostedGraph = self.graph
        
        self.graph.paddingLeft = 0.0;
        self.graph.paddingTop = 0.0;
        self.graph.paddingRight = 0.0;
        self.graph.paddingBottom = 0.0;
        
        self.addSubview(self.graphView)
    }
    
    func configurePlot()
    {
        ///Lead Line style
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineColor = CPTColor(CGColor: plotParams.lineColor)
        lineStyle.lineWidth = 2.0
        self.leadPlot.dataLineStyle = lineStyle
        
        //PlotSpace
        let plotSpace = self.graph.defaultPlotSpace as? CPTXYPlotSpace
        plotSpace!.xRange = CPTPlotRange(location: xLogicalPlotMin, length: xLogicalPlotCount)
        plotSpace!.yRange = CPTPlotRange(location: yLogicalPlotMin, length: yLogicalPlotCount)
    }
    
    func reloadData() {
        self.leadPlot.reloadData()
        //self.leadPlot.insertDataAtIndex(idx: idx, numberOfRecords: UInt(1))
        
    }
    
}

extension SPKPlotView : CPTPlotDataSource {
    
    public func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        return dataSource.numberOfPointsForPlot(self, tag: self.tag)
    }
    
    public func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject! {
        return dataSource.numberForPlot(self, field: fieldEnum, recordIndex: idx, tag: self.tag)
    }
}