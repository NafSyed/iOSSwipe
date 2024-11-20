//
//  ContentView.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 12/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = SwipeVM()
    var body: some View {
        IntroView()
    }
}

#Preview {
    ContentView()
}
