//
//  SPKDataStore.swift
//  ECGMonitor
//
//  Created by Derrick on 8/6/15.
//  Copyright (c) 2015 ___Derrick_Lo___. All rights reserved.
//

import Foundation

public class SPKDataStore {
    
    private var processingBuffer : SPKBuffer
    
    public var bufferUrl : NSURL!
    public var uniqueFileName : String! = ""
    
    init()
    {
        processingBuffer = SPKBuffer()
    }
    
    func update(datum : Double)
    {
        self.processingBuffer.addDataToBuffer(datum)
    }
    
    func saveToDisk()
    {
        let fileManager = NSFileManager.defaultManager()
        
        if let docsDir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
            
            let uniqueFileName = NSDate.timeIntervalSinceReferenceDate()
            self.bufferUrl = docsDir.URLByAppendingPathComponent("\(uniqueFileName).data")
            
            let bfr : NSArray = processingBuffer.consumeData(processingBuffer.getCount())
                
            bfr.writeToURL(bufferUrl, atomically: true)
            self.uniqueFileName = bufferUrl.absoluteString.lastPathComponent
            NSLog("SaveFile Path: \(bufferUrl.absoluteString)")
        }
    }
    
    static func readFileFromDisk(fileName : String) -> [Double]?
    {
        let fileManager = NSFileManager.defaultManager()
        var fileURL : NSURL?
        
        if let docsDir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
            fileURL = docsDir.URLByAppendingPathComponent(fileName)

            return (NSArray(contentsOfURL: fileURL!) as! [Double])

        }
        
        return nil
    }
}

extension String {
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
}