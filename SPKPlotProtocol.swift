//
//  SPKPlotProtocol.swift
//  ECGMonitor
//
//  Created by Derrick on 10/11/15.
//  Copyright © 2015 ___Derrick_Lo___. All rights reserved.
//

import Foundation
import CoreGraphics

enum ECGYAxisScale {
    case millivolts
    case volts
}

enum ECGXAxisScale {
    case milliseconds
    case seconds
}

protocol SPKPlotProtocol {
    var plotName : String { get }
    var samplingRate : Int { get }
    var scale : PlotAxisScale { get }
    var duration : Int { get }
    var lineColor : CGColor { get }
    var xLogicalPlotMin: Int { get }
    var xLogicalPlotCount: Int { get }
    var yLogicalPlotMin: Int { get }
    var yLogicalPlotCount: Int { get }
}

protocol PlotAxisScale {
    var xAxis : ECGXAxisScale { get }
    var yAxis : ECGYAxisScale { get }
}
