//
//  AppDelegate.swift
//  MenuBarSIPDetector
//
//  Created by Pietro Caruso on 29/06/21.
//

import Cocoa
import TINURecovery

public class DebugSIP: SIP{
    public override class var simulatedStatus: SIPStatus?{
        return nil//SIPStatus(resultsEnabled: nil, usesCustomConfiguration: !false)
    }
}

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
        
        DispatchQueue.global(qos: .userInteractive).async {
            let status = DebugSIP.status
            
            DispatchQueue.main.sync {
                
                self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
                
                var itemImage: NSImage?
                var title = ""
                
                if let stat = status.resultsEnabled{
                    title = "SIP is \(stat ? "enabled" : "disabled")"
                
                    itemImage =  NSImage(named: stat ? NSImage.statusAvailableName : NSImage.statusUnavailableName)
                }else{
                    title = "SIP status unknown"
                    itemImage = NSImage(named: NSImage.statusPartiallyAvailableName)
                }
                
                title += status.usesCustomConfiguration ? " (custom config.)" : ""
                
                //itemImage?.isTemplate = true
                self.statusItem?.button?.title = title
                self.statusItem?.button?.image = itemImage
                self.statusItem?.button?.imagePosition = NSControl.ImagePosition.imageLeft
                
                if let menu = self.menu {
                    self.statusItem?.menu = menu
                }
                
            }
        }
        
    }
    
    @IBAction func checkOnGithub(_ sender: Any) {
        let _ = NSWorkspace.shared.open(URL(string: "https://github.com/ITzTravelInTime/MenuBarSIPDetector")!)
    }
    
    @IBAction func showInFinder(_ sender: Any) {
        NSWorkspace.shared.selectFile(Bundle.main.bundlePath, inFileViewerRootedAtPath: Bundle.main.bundleURL.deletingLastPathComponent().path)
    }
    

}

