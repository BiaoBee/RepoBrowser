//
//  ExploreFilterView.swift
//  RepoBrowser
//
//  Created by Biao Luo on 11/09/2025.
//

import SwiftUI

struct ExploreFilterView: View {
    @Binding var filters: [FilterCategory]
    @Environment(\.dismiss) private var dismiss
    let onComplete: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ForEach($filters) { $category in
                    HStack {
                        Text(category.name + ":")
                        Picker(category.name, selection: $category.selectedOption) {
                            ForEach(category.options) { option in
                                Text(option.name)
                                    .tag(option)
                            }
                        }
                    }
                    Divider()
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        filters.forEach { $0.resetToDefault() }
                    } label: {
                        Text("Reset")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                        onComplete()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}
