//
//  String+WriteToURL.swift
//  AniDraw
//
//  Created by Mike on 7/12/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation

extension String {
    func appendLineToURL(fileURL: NSURL) throws {
        try self.stringByAppendingString("\n").appendToURL(fileURL)
    }
    
    func appendToURL(fileURL: NSURL) throws {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        try data.appendToURL(fileURL)
    }
}

extension NSData {
    func appendToURL(fileURL: NSURL) throws {
        if let fileHandle = try? NSFileHandle(forWritingToURL: fileURL) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.writeData(self)
        }
        else {
            try writeToURL(fileURL, options: .DataWritingAtomic)
        }
    }
}