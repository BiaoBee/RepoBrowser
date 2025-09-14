//
//  OnFirstAppear.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import SwiftUI

/// A view modifier that runs an action only the first time the view appears.
struct OnFirstAppear: ViewModifier {
    @State private var hasAppeared = false
    /// The action to perform on the first appearance.
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasAppeared {
                    hasAppeared = true
                    action()
                }
            }
    }
}

extension View {
    /// Runs the given action only the first time this view appears.
    /// - Parameter action: The action to perform.
    /// - Returns: A view that triggers the action on its first appearance.
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        self.modifier(OnFirstAppear(action: action))
    }
}
