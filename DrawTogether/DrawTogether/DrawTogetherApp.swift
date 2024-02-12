//
//  Draw_TogetherApp.swift
//  Draw Together
//
//  Created by Thalia Woods on 08/01/2024.
//

import SwiftUI

@main
struct Draw_TogetherApp: App {
    
    @StateObject var viewRouter = ViewRouter()
    var body: some Scene {
        WindowGroup {
            ContentView(viewRouter: viewRouter)
        }
    }
}
