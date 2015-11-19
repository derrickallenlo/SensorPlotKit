//
//  SPKFilter.swift
//  ECGMonitor
//
//  Created by Derrick on 7/26/15.
//  Copyright (c) 2015 ___Derrick_Lo___. All rights reserved.
//

import Foundation

enum FilterType{
    case LowerLimit
    case UpperLimit
    case Filter
}

public class SPKFilter {
    
    private var name : String
    private var filtersToApply : Dictionary<FilterType, Any>
    
    init(filterWithName : String, filter: FilterType, filterValue: Any) {
        
        self.name = filterWithName
        self.filtersToApply = [FilterType : Any]()
        self.filtersToApply[filter] = filterValue
    }
    
    func applyFilter(inputBuffer : [Double]) -> [Double] {
        
        if let filter = filtersToApply.keys.first {
            
            switch (filter) {
                
                case FilterType.UpperLimit:
                    let limit = filtersToApply[filter] as! Double
                    return inputBuffer.filter({x in x < limit})
                
                case FilterType.LowerLimit:
                    let limit = filtersToApply[filter] as! Double
                    return inputBuffer.filter({x in x > limit})
                
                default:
                    return inputBuffer
            }
            
        }
   
        return inputBuffer
    }
}