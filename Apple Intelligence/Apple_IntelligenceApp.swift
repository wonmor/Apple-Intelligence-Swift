//
//  Apple_IntelligenceApp.swift
//  Apple Intelligence
//
//  Created by John Seong on 10/20/24.
//

import SwiftUI
import AppKit
import Cocoa

func checkAccessibilityPermission() -> Bool {
    let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
    let accessEnabled = AXIsProcessTrustedWithOptions(options)
    
    if !accessEnabled {
        print("Access not enabled. Please enable accessibility permissions.")
    }
    
    return accessEnabled
}

func requestAutomationPermission() {
        let script = "tell application \"System Events\" to keystroke \"a\""
        
        let process = Process()
        process.launchPath = "/usr/bin/osascript"
        process.arguments = ["-e", script]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                print("Script Output: \(output)")
            }
        } catch {
            print("Failed to run AppleScript: \(error)")
        }
    }

func requestAutomationPermission2() {
        let script = "tell application \"Notes\" to keystroke \"a\""
        
        let process = Process()
        process.launchPath = "/usr/bin/osascript"
        process.arguments = ["-e", script]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                print("Script Output: \(output)")
            }
        } catch {
            print("Failed to run AppleScript: \(error)")
        }
    }

@main
struct AppleIntelligenceChatbotApp: App {
    init() {
        requestAutomationPermission()
        requestAutomationPermission2()
        
        if checkAccessibilityPermission() {
            openNotesInBackground()
        } else {
            print("Accessibility permissions are required for this app to function properly.")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func openNotesInBackground() {
        let appleScriptCommand = """
        if application "Notes" is not running then
            tell application "Notes" to activate
            repeat until application "Notes" is running
                delay 0.5
            end repeat
        end if
        delay 0.5
        tell application "System Events" to set visible of process "Notes" to false
        """

        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: appleScriptCommand) {
            scriptObject.executeAndReturnError(&error)
            if let error = error {
                print("Error opening Notes app: \(error)")
            }
        }
    }
}
