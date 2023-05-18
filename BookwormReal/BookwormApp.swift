//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Vladimir Kratinov on 2023-05-17.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
