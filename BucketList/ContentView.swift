//
//  ContentView.swift
//  BucketList
//
//  Created by Ali Soner Inceoglu on 07.12.25.
//

import LocalAuthentication
import SwiftUI

struct ContentView: View {
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        Task {
            let context = LAContext()
            var error: NSError?
            
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                // no biometrics
                return
            }
                        
            do {
               let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "We need to unlock your data.")
               if success {
                   // Authentication successful
                   isUnlocked = true
               }
             } catch {
                 // Authentication failed
             }
            
        }
    }
}

#Preview {
    ContentView()
}
