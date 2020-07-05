//
//  PreferencesVC.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 26.06.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Cocoa

struct PreferencesKey {
    static let showOnlyOwnProcesses = "com.process_manager.show_only_own_processes"
}

extension Notification {
    static let preferencesChangedKey = Notification.Name(rawValue: "Preferences has changed")
}

class PreferencesVC: NSViewController {
    @IBOutlet var onlyOwnProcessesButton: NSButton!
    
    @IBAction
    func displayOwnProcessesChanged(_ sender: Any) {
        guard let button = sender as? NSButton else {
            return
        }
        let isEnabled = button.state == NSButton.StateValue.on
        UserDefaults.standard.set(isEnabled, forKey: PreferencesKey.showOnlyOwnProcesses)
        NotificationCenter.default.post(name: Notification.preferencesChangedKey, object: isEnabled)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isEnabled = UserDefaults.standard.bool(forKey: PreferencesKey.showOnlyOwnProcesses)
        self.onlyOwnProcessesButton.state = isEnabled ? NSButton.StateValue.on : NSButton.StateValue.off
    }
}
