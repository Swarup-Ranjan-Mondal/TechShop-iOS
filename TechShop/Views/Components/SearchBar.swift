//
//  SearchBar.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 04/03/21.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    @State private var isSearching = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(.systemGray))
                
                TextField(
                    "Search terms here",
                    text: $searchText
                )
                .onTapGesture {
                    isSearching = true
                }
                
                if isSearching {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundColor(Color(.systemGray))
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(Color(.systemGray5))
            .cornerRadius(6)
            .transition(.move(edge: .trailing))
            .animation(.linear)
            
            if isSearching {
                Button(action: {
                    isSearching = false
                    searchText = ""
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .padding(.horizontal, 4)
                }
                .transition(.move(edge: .trailing))
                .animation(.linear)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
        }
    }
}
