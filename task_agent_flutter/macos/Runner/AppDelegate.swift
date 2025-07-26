import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    
    override func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        // Hide main window
        NSApp.setActivationPolicy(.accessory)
    }
    
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            if #available(macOS 11.0, *) {
                button.image = NSImage(systemSymbolName: "checklist", accessibilityDescription: "Task Manager")
            } else {
                button.image = NSImage(named: NSImage.listViewTemplateName)
            }
            button.action = #selector(togglePopover(_:))
        }
        
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 400, height: 600)
        popover?.behavior = .transient
        popover?.animates = true
        
        if let flutterViewController = NSApplication.shared.windows.first?.contentViewController as? FlutterViewController {
            popover?.contentViewController = flutterViewController
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.close()
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
