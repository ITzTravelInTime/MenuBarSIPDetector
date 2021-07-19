//
//  SIP.swift
//  MenuBarSIPDetector
//
//  Created by Pietro Caruso on 17/07/21.
//

import Foundation
import AppKit
import TINURecovery

class DebugSIP: SIP{
    public override class var simulatedStatus: SIPStatus?{
        return nil
    }
}

extension SIP.SIPStatus{
    func statusBadge() -> NSImage?{
        if let stat = self.resultsEnabled{
            return stat.badge()
        }else{
            return NSImage(named: NSImage.statusPartiallyAvailableName)
        }
    }
}

extension Bool{
    func badge() -> NSImage?{
        return NSImage(named: self ? NSImage.statusAvailableName : NSImage.statusUnavailableName)
    }
}


