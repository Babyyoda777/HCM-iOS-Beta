//
//  ViewModel.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 12/08/2022.
//

import Foundation

class FeedViewModel: ObservableObject {
    @Published var rssItems = [RSSItem]()
    @Published var isLoading = false
    
    init() {
        self.fetchData()
    }

    func fetchData() {
        self.isLoading = true
        let feedParser = FeedParserService()
        feedParser.parseFeed(url: "https://rss.app/feeds/gXqCbgAZMykAZE7J.xml") { rssItems in
            DispatchQueue.main.async {
                self.isLoading = false
                self.rssItems = rssItems
            }
        }
    }
}
