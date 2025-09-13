//
//  BookmarkToggle.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import SwiftUI

struct BookmarkToggle: View {
    @Binding var isSelected: Bool
    
    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Label("", systemImage: isSelected ? "bookmark.fill" : "bookmark")
        }
    }
}

#Preview {
    @Previewable @State var isSelected: Bool = false
    
    VStack {
        BookmarkToggle(isSelected: $isSelected)
    }
}
