//
//  ViewController.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 26.06.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Cocoa
import ServiceManagement

class ViewController: NSViewController {
    
    lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView(frame: self.view.bounds)
        self.view.addSubview(scrollView)
        scrollView.hasVerticalRuler = true
        scrollView.hasVerticalScroller = true
        return scrollView
    }()
    
    lazy var processesTableView: NSTableView = {
        var tableView = NSTableView(frame: self.view.bounds)
        self.scrollView.documentView = tableView
        tableView.delegate = self.tableDelegateHandler
        tableView.dataSource = self.tableDataSource
        tableView.usesAutomaticRowHeights = true
        tableView.headerView?.needsDisplay = true
        
        var column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("identifier"))
        column.headerCell.stringValue = "Process ID"
        column.width = 100.0
        tableView.addTableColumn(column)
        
        column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("owner"))
        column.headerCell.stringValue = "Owner"
        column.width = 200.0
        tableView.addTableColumn(column)
        
        column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("name"))
        column.headerCell.stringValue = "Name"
        column.width = 400.0
        tableView.addTableColumn(column)
        
        return tableView
    }()
    
    lazy private(set) var processService: ProcessService = {
        return ProcessService()
    }()
    
    lazy private(set) var processesFetcher: ProcessItemsFetcher = {
        let fetcher = ProcessItemsFetcher()
        fetcher.itemsFetchedBlock = { [weak self] (itemsById) in
            print("did fetch items: \(itemsById.count)")
            guard let self = self else {
                return
            }
            var itemsToAdd: [Identifiable] = []
            for item in self.processesContainer.allItems() {
                if itemsById[item.identifier] == nil {
                    self.processesContainer.removeItem(identifier: item.identifier)
                }
            }
            let items = Array(itemsById.values)
            self.processesContainer.addItems(items)
        }
        var appDelegate = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.activeBlock = { [weak self] in
            self?.processesFetcher.startFetchEvents()
        }
        appDelegate?.inactiveBlock = { [weak self] in
            self?.processesFetcher.finishFetchEvents()
        }
        return fetcher
    }()
    
    lazy private(set) var processesContainer: IdentifiableItemsContainer = {
        var container = IdentifiableItemsContainerFactory.defaultContainer()
        IdentifiableItemsContainerFactory.orderedInsertionsContainer(&container)
        return container
    }()
    
    lazy var tableDataSource: NSTableViewDataSource = {
        return TableDatsSourceFactory.sourceFromContainer(self.processesContainer)
    }()
    
    lazy var tableDelegateHandler: NSTableViewDelegate = {
        let itemSelectBlock: (ProcessItem?) -> Void = { [weak self] (item) in
            guard let self = self else {
                return
            }
            self.selectedProcess = item
        }
        let handler = TableViewDelegateHandlerDefault(container: self.processesContainer, selectBlock: itemSelectBlock)
        return handler
    }()
    
    private(set) var selectedProcess: ProcessItem? {
        didSet {
            self.killProcessButton.isEnabled = self.selectedProcess != nil
        }
    }
    
    lazy var killProcessButton: NSButton = {
        let button = NSButton(title: "Kill process", target: self, action: #selector(killProcessButtonPressed(_ :)))
        self.view.addSubview(button)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.setupConstraints()
        
        IdentifiableItemsContainerFactory.decoratedDynamicBatchChangesItemsContainer(&self.processesContainer, tableView: self.processesTableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillCloseNotification), name: NSWindow.willCloseNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applyFiltering), name: Notification.preferencesChangedKey, object: nil)
        self.processesFetcher.filterUserId = UserDefaults.standard.bool(forKey: PreferencesKey.showOnlyOwnProcesses) ? getuid() : nil
        self.processesFetcher.startFetchEvents()
    }
    
    private func setupConstraints() {
        self.scrollView.makeConstraints { (make) in
            make.left.top.right.equalTo(self.view).inset(StyleSheet.Offsets.l)
            make.height.equalTo(400.0)
        }
        
        self.killProcessButton.makeConstraints { (make) in
            make.top.equalTo(self.scrollView.cm.bottom).offset(StyleSheet.Offsets.l)
            make.left.equalTo(self.processesTableView)
            make.bottom.equalTo(self.view).inset(StyleSheet.Offsets.l)
        }
        self.killProcessButton.setContentHuggingPriority(NSLayoutConstraint.Priority.required, for: NSLayoutConstraint.Orientation.horizontal)
    }
    
    @objc
    private func killProcessButtonPressed(_ sender: NSButton) {
        
        guard
            let processToKill = self.selectedProcess,
            let pidRaw = Int32(processToKill.identifier)
        else {
            return
        }
        
        let killProcessActionBlock: () -> () = { [weak self] in
            self?.sendKillProcessWithId(pidRaw)
        }
        
        let currentId = getpid()
        if currentId == pidRaw {
            self.showAlertWithMessage("You are about to close process of this application. Are you sure?", continueBlock: killProcessActionBlock)
            return
        }
        let message = "Process '\(processToKill.name)' will be killed. Are you sure?"
        self.showAlertWithMessage(message, continueBlock: killProcessActionBlock)
    }
    
    @objc
    private func windowWillCloseNotification(_ notification: Notification) {
        guard
            let window = notification.object as? NSWindow,
            window.contentViewController == self else {
                return
        }
        self.processesFetcher.finishFetchEvents()
    }
    
    func showAlertWithMessage(_ message: String, continueBlock: @escaping VoidBlock ) {
                
        let alert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: "Continue")
        alert.addButton(withTitle: "Cancel")
        if alert.runModal() == .alertFirstButtonReturn {
            continueBlock()
        }
    }
    
    func showNotificationMessage(_ message: String ) {
        let notification = NSTextField.notificationWithMessage(message)
        
        self.view.addSubview(notification)
        notification.makeConstraints { (make) in
            make.top.equalToSuperView().offset(StyleSheet.Offsets.l)
            make.centerX.equalToSuperView()
            make.width.lessOrEqualTo(200.0)
        }
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 2.0
            notification.animator().alphaValue = 1.0
            context.allowsImplicitAnimation = true
        }) {
            notification.removeFromSuperview()
        }
    }
    
    private func sendKillProcessWithId(_ pid: pid_t) {
        self.processService.killProcessWithId(pid) { [weak self] (result) in
            RedispatchToMain({
                if result == 0 {
                    self?.showNotificationMessage("Kill confirmed")
                    return
                }
                self?.requestPrivilegedKillProcesWithId(pid)
            })
        }
    }
    
    @objc
    private func applyFiltering(_ notification: Notification) {
        guard let filteringEnabled = notification.object as? Bool else {
            return
        }
        self.processesFetcher.filterUserId = filteringEnabled ? getuid() : nil
    }
    
    private func requestPrivilegedKillProcesWithId(_ pid: pid_t) {
        self.processService.killPrivilegedProcessWithId(pid) { (answer) in
            RedispatchToMain {
                self.showNotificationMessage(answer)
            }
        }
    }
}
