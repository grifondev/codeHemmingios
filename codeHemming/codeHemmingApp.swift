//
//  codeHemmingApp.swift
//  codeHemming
//
//  Created by grifondev on 28.04.2023.
//

import SwiftUI

@main
struct codeHemmingApp: App {
    var body: some Scene {
        WindowGroup {
            codeHemmingView()
        }
    }
}

extension UIScreen {
    public static let screenWidth = UIScreen.main.bounds.size.width
    public static let screenHeight = UIScreen.main.bounds.size.height
}
