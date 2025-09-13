//
//  ExploreListItem.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import SwiftUI

struct ExploreListItem: View {
    @Binding var repository: Repository
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AvatarView(url: repository.owner.avatarUrl, size: 25)
                Text(repository.owner.login)
            }
            .font(.subheadline)
            
            Text(repository.name)
                .font(.headline)
            
            Spacer().frame(height: 10)
            
            if let description = repository.description {
                Text(description)
                    .foregroundStyle(.secondary)
            }
            
            Spacer().frame(height: 20)
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "star")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.yellow)
                    Text("\(repository.stargazersCount)")
                }
                
                if let license = repository.license {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "text.document")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.gray)
                        Text(license.spdxId)
                    }
                }
                if let language = repository.language {
                    Spacer()
                    Text(language)
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
}

//#Preview {
//    ExploreListItem()
//}
