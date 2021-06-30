//
//  AppDelegate.swift
//  MenuBarSIPDetector
//
//  Created by Pietro Caruso on 29/06/21.
//

import Cocoa
import TINURecovery

#if TEST
public class DebugSIP: SIP{
    public static var simulatedStatus: Bool? = nil
    
    public static var status: Bool{
        if let sim = simulatedStatus{
            return sim
        }
        
        return actualStatus
    }
}

#else
public typealias DebugSIP = SIP
#endif

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var firstMenuItem: NSMenuItem?
    private var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        awakeFromNib()
     
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "SIP is \(DebugSIP.status ? "enabled" : "disabled")"
        
        let itemImage = DebugSIP.status ? NSImage(named: NSImage.statusAvailableName) : NSImage(named: NSImage.statusUnavailableName)
        //itemImage?.isTemplate = true
        statusItem?.button?.image = itemImage
        statusItem?.button?.imagePosition = NSControl.ImagePosition.imageLeft
        
        if let menu = menu {
            statusItem?.menu = menu
        }
        
    }


}

