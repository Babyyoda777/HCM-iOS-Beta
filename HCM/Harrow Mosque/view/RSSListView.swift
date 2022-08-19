//
//  RSSListView.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 12/08/2022.
//


import SwiftUI

struct RSSListView: View {
    let rssItems: [RSSItem]
    
    @State private var searchText: String = ""
    
    var filteredItems: [RSSItem] {
        if searchText.count == 0 {
            return rssItems
        } else  {
            return rssItems.filter { $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredItems) { item in
                    Section{
                    NavigationLink {
                        RSSListItemView(rssItem: item)
                    } label: {
                        Text(item.title)
                    }
                }
                }
            }
            .environment(\.defaultMinListRowHeight, 110)
            .listStyle(InsetGroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationTitle("HCM Updates")
            .searchable(text: $searchText)
        }
    }
}

