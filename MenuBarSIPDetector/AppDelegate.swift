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

import Cocoa
import TINURecovery

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var firstMenuItem: NSMenuItem?
    @IBOutlet weak var refreshMenuItem: NSMenuItem?
    
    private var statusItem: NSStatusItem?
    private var itemsAdded = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        awakeFromNib()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        if refreshMenuItem != nil {
            refreshMenuItem?.isHidden = !Recovery.status
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let status = DebugSIP.status
            
            DispatchQueue.main.sync {
                
                self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
                
                let itemImage = status.statusBadge()
                let title = status.statusStrig()
                
                //itemImage?.isTemplate = true
                self.statusItem?.button?.title = title
                self.statusItem?.button?.image = itemImage
                self.statusItem?.button?.imagePosition = NSControl.ImagePosition.imageLeft
                
                if !self.itemsAdded{
                    
                    self.itemsAdded.toggle()
                    
                    for i in self.menu?.items ?? []{
                        if i as? BitMenuItem != nil{
                            self.menu?.removeItem(i)
                        }
                    }
                    
                    for bit in status.detailedConfiguration.sorted(by: { $0.key.rawValue > $1.key.rawValue }){
                        let m = BitMenuItem(title: bit.key.name , action: #selector(self.openBitInfo(_:)), keyEquivalent: "")
                        
                        m.bit = bit.key
                        m.bitStatus = bit.value
                        
                        m.image = bit.value.badge()
                        
                        self.menu?.insertItem(m, at: 0)
                    }
                }
                
                if let menu = self.menu {
                    self.statusItem?.menu = menu
                }
                
            }
        }
        
    }
    
    @IBAction func openBitInfo( _ sender: BitMenuItem){
        if sender.bit == nil{
            return
        }
        
        InfoViewController.createAndShow(fromBit: sender.bit!, withStatus: sender.bitStatus)
    }
    
    @IBAction func checkOnGithub(_ sender: Any) {
        let _ = NSWorkspace.shared.open(URL(string: "https://github.com/ITzTravelInTime/MenuBarSIPDetector")!)
    }
    
    @IBAction func showInFinder(_ sender: Any) {
        NSWorkspace.shared.selectFile(Bundle.main.bundlePath, inFileViewerRootedAtPath: Bundle.main.bundleURL.deletingLastPathComponent().path)
    }
    
    @IBAction func refresh( _ sender: Any){
        
        
        
        self.itemsAdded = false
        awakeFromNib()
    }
    

}

