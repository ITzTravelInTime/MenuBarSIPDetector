//
//  InfoViewController.swift
//  MenuBarSIPDetector
//
//  Created by Pietro Caruso on 18/07/21.
//

import AppKit

@IBDesignable class InfoViewController: NSViewController{
    
    @IBOutlet weak var infoLabel: NSTextField!
    @IBOutlet weak var currentStatusImageView: NSImageView!
    @IBOutlet weak var currentStatusLabel: NSTextField!
    
    private var bit: DebugSIP.SIPBits?
    private var status: Bool = false
    
    private static var instance: NSWindowController? = nil
    
    static func createAndShow( fromBit bit: DebugSIP.SIPBits, withStatus status: Bool ){
        
        if instance == nil{
            instance = (NSStoryboard.init(name: "Main", bundle: Bundle.main).instantiateController(withIdentifier: "InfoWindowController") as? NSWindowController)
            
            if instance == nil{
                return
            }
        }
        
        instance?.window?.title = "Info about: \(bit.name)"
        
        guard let content = instance?.contentViewController as? InfoViewController else { return }
        
        content.bit = bit
        content.status = status
        
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
