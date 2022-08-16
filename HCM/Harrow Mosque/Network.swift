//
//  Network.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 11/08/2022.
//

import Foundation
import SwiftUI
class Network: ObservableObject {
        @Published var users: [User] = []
    func getUsers() {
        guard let url = URL(string: "https://www.londonprayertimes.com/api/times/?format=json&key=2a99f189-6e3b-4015-8fb8-ff277642561d&24hours=true") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedUsers = try JSONDecoder().decode([User].self, from: data)
                        self.users = decodedUsers
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
}

