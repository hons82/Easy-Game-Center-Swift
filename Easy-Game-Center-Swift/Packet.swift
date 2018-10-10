//
//  Packet.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 13/04/2015.
//  Copyright (c) 2015 DaRk-_-D0G. All rights reserved.
//

import Foundation
/**
*  Packet
*/
struct Packet {
    var name: String
    var index: Int64
    var numberOfPackets: Int64
    
    /**
    *  Struc
    */
    struct ArchivedPacket {
        var index : Int64
        var numberOfPackets : Int64
        var nameLength : Int64
    }
    /**
    Archive Packet
    
    - returns: NSData
    */
    func archive() -> NSData {
        
        var archivedPacket = ArchivedPacket(index: Int64(self.index), numberOfPackets: Int64(self.numberOfPackets), nameLength: Int64(self.name.lengthOfBytes(using: String.Encoding.utf8)))
        
        let metadata = NSData(
            bytes: &archivedPacket,
            length: MemoryLayout<ArchivedPacket>.size
        )
        
        let archivedData = NSMutableData(data: metadata as Data)
        archivedData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        return archivedData
    }
    /**
    Unarchive Packet
    
    - parameter data: NSData
    
    - returns: Packet
    */
    static func unarchive(data: NSData!) -> Packet {
        var archivedPacket = ArchivedPacket(index: 0, numberOfPackets: 0, nameLength: 0) //, dataLength: 0
        let archivedStructLength = MemoryLayout<ArchivedPacket>.size
        
        let archivedData = data.subdata(with: NSMakeRange(0, archivedStructLength)) as NSData
        archivedData.getBytes(&archivedPacket, length: data.length)
        
        let nameRange = NSMakeRange(archivedStructLength, Int(archivedPacket.nameLength))
        let nameData = data.subdata(with: nameRange)
        let name = NSString(data: nameData, encoding: String.Encoding.utf8.rawValue)! as String
        let packet = Packet(name: name, index: archivedPacket.index, numberOfPackets: archivedPacket.numberOfPackets)
        
        return packet
    }
}
