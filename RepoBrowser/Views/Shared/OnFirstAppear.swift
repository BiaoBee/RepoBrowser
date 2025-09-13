//
//  OnFirstAppear.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import SwiftUI

import SwiftUI

struct OnFirstAppear: ViewModifier {
    @State private var hasAppeared = false
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
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        self.modifier(OnFirstAppear(action: action))
    }
}
