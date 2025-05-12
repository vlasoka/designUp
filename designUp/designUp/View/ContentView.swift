//
//  ContentView.swift
//  designUp
//
//  Created by София Кармаева on 31/3/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: K.isLoggedInInfoKey) ?? false

    var body: some View {
        if isLoggedIn {
            MainView()
        } else {
            LoginRegisterView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
}
