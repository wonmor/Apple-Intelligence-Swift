//
//  ContentView.swift
//  Apple Intelligence
//
//  Created by John Seong on 10/20/24.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var chatOutput: String = "Unofficial Apple Intelligence Chatbot"

    var body: some View {
        VStack {
            ScrollView {
                Text(chatOutput)
                    .padding()
                
                Image("logo")
                          .resizable()  // To allow the image to be resizedaaa
                          .aspectRatio(contentMode: .fit)  // Fit the image within its container
                          .frame(width: 80, height: 80)  // Set the desired frameaaaaa
                          .opacity(0.5)
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            HStack {
                TextField("Type your message...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 40)
                
                Button(action: {
                    sendInputToChatbot(input: userInput)
                }) {
                    Text("Send")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .padding()
    }
    
    func sendInputToChatbot(input: String) {
        let formattedInput = "system A conversation between a user and a helpful understanding assistant. Always answer the user queries and questions. Continue this conversation. \(input)"
        
        let appleScriptCommand = """
        set a to path to frontmost application as text
        
        tell application "Notes"
            delay 0.2
            tell account "iCloud"
                set newNote to make new note ¬
                at folder "Notes" ¬
                with properties {name:"Apple Intelligence Chatbot", body:"\(formattedInput)"}
                
                delay 0.2
                show newNote
                delay 0.2
            end tell
        end tell
        
        tell application "System Events"
            key code 124
            delay 0.1
            keystroke "a" using {command down}
            delay 0.1
            key code 126
            delay 0.1
            key code 125
            delay 0.1
            key code 125 using {command down, shift down}
        end tell
        
        set startTime to current date
        tell application "System Events"
            keystroke "c" using command down
        end tell
        delay 0.1
        set initialClipboard to the clipboard
        
        tell application "System Events"
            delay 0.1
            tell application "Notes" to activate
            tell process "Notes"
                click menu bar item "Edit" of menu bar 1

                click menu item "Writing Tools" of menu "Edit" of menu bar item "Edit" of menu bar 1
                delay 0.1
                
                click menu item "Rewrite" of menu 1 of menu item "Writing Tools" of menu "Edit" of menu bar item "Edit" of menu bar 1
                delay 0.1
            end tell
        end tell
        
        repeat
            delay 1
            
            tell application "System Events"
                keystroke "c" using command down
            end tell
            
            set currentClipboard to the clipboard
            
            if currentClipboard is not initialClipboard then
                delay 0.5
                tell application "Notes"
                    delete newNote
                end tell
                delay 0.5
                activate application a
                delay 0.1
                return currentClipboard
            end if
        end repeat
        """
        
        let result = executeAppleScript(script: appleScriptCommand)
        DispatchQueue.main.async {
            chatOutput += "\n\nAssistant: \(result)"
            userInput = ""
        }
    }
    
    func executeAppleScript(script: String) -> String {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            if let error = error {
                return "AppleScript Error: \(error)"
            } else {
                return output.stringValue ?? "No response"
            }
        }
        return "Failed to execute AppleScript"
    }
}

#Preview {
    ContentView()
}
