/*
 
     MenuBarSIPDetector: A simple app to know the current status of the System Integrity Protection.
     Copyright (C) 2021 Pietro Caruso (ITzTravelInTime)

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 
 */

import AppKit

@IBDesignable class InfoViewController: NSViewController{
    
    @IBOutlet weak var infoLabel: NSTextField!
    @IBOutlet weak var currentStatusImageView: NSImageView!
    @IBOutlet weak var currentStatusLabel: NSTextField!
    
    private var bit: DebugSIP.SIPBits?
    private var status: Bool = false
    
    private static var instance: NSWindowController? = nil
    
    static func createAndShow( fromBit bit: DebugSIP.SIPBits, withStatus cstatus: Bool ){
        
        if instance == nil{
            instance = (NSStoryboard.init(name: "Main", bundle: Bundle.main).instantiateController(withIdentifier: "InfoWindowController") as? NSWindowController)
            
            if instance == nil{
                return
            }
        }
        
        instance?.window?.title = "Info about: \(bit.name)"
        
        guard let content = instance?.contentViewController as? InfoViewController else { return }
        
        content.bit = bit
        content.status = cstatus
        
        if content.infoLabel != nil && content.currentStatusLabel != nil && content.currentStatusImageView != nil{
            content.viewDidAppear()
        }
        
        instance?.showWindow(self)
        instance?.window?.makeKeyAndOrderFront(self)
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.infoLabel.stringValue = self.bit?.userDescription ?? "[Error getting info]"
        self.currentStatusLabel.stringValue = status ? "Currently enabled" : "Currently disabled"
        self.currentStatusImageView.image = status.badge()
    }
    
}

class BitMenuItem: NSMenuItem{
    var bit: DebugSIP.SIPBits?
    var bitStatus: Bool = false
}
