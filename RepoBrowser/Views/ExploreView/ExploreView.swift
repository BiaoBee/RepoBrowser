//
//  ExploreView.swift
//  RepoBrowser
//
//  Created by Biao Luo on 11/09/2025.
//

import SwiftUI

struct ExploreView: View {
    @State private var viewModel = ExploreViewModel(service: RepositoryService())
    @State private var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        VStack  {
            // The header: display current page, error message and loading spinner.
            Group {
                Text("page: \(viewModel.currentPage)")
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                    Spacer()
                        .frame(height: 5)
                }
                
                VStack(alignment: .center) {
                    if viewModel.isReloading {
                        ProgressView()
                            .frame(height: 40, alignment: .center)
                    }
                }
            }
            .font(.caption)

            ScrollViewReader { scrollProxy in
                List {
                    ForEach($viewModel.repositories) { $repo in
                        NavigationLink(destination: RepoDetailView(repository: repo)) {
                            ExploreListItem(repository: $repo)
                                .onAppear {
                                    if let last = viewModel.repositories.last,
                                       last.id == repo.id {
                                        viewModel.loadMore()
                                    }
                                }
                        }
                    }
                    if !viewModel.isReloading && !viewModel.repositories.isEmpty {
                        VStack(alignment: .center) {
                            if viewModel.isLoadingMore {
                                ProgressView()
                                    .frame(height: 40, alignment: .center)
                            } else {
                                Button {
                                    viewModel.loadMore()
                                } label: {
                                    Label("Load More", systemImage: "arrow.down.circle")
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .onAppear {
                    self.scrollProxy = scrollProxy
                }
            }

        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.showFilterView = true
                } label: {
                    if viewModel.isFilterApplied {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    } else {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.reload()
                } label: {
                    Image(systemName: "arrow.trianglehead.2.clockwise")
                }
                .disabled(viewModel.isReloading)
            }
        }
        .navigationTitle("Explore")
        .sheet(isPresented: $viewModel.showFilterView) {
            ExploreFilterView(filters: $viewModel.filters) {
                scrollProxy?.scrollTo(0, anchor: .top)
                viewModel.reload()
            }
        }
        .onFirstAppear {
            scrollProxy?.scrollTo(0, anchor: .top)
            viewModel.reload()
        }
    }
}

#Preview {
    ExploreView()
}
