//
//  RSSListItemView.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 12/08/2022.
//


import SwiftUI

struct RSSListItemView: View {
    let rssItem: RSSItem
    

    var body: some View {
       
            List{
                Text(rssItem.title)
                    .font(.headline)
                Text(rssItem.pubDate)
                    .font(.footnote)
                Section{
                HTMLView(text: rssItem.description)
                        .frame(height:450)
                }
            }
        
    }
        
    }

