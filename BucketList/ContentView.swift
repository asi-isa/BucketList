//
//  ContentView.swift
//  BucketList
//
//  Created by Ali Soner Inceoglu on 07.12.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Read and Write") {
                let data = Data("Hello, World!".utf8)
                let url = URL.applicationDirectory.appending(path: "document.txt")
                
                do {
                    try data.write(to: url, options: [.atomic, .completeFileProtection])
                    
                    let readData = try String(contentsOf: url, encoding: .utf8)
                    print(readData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
