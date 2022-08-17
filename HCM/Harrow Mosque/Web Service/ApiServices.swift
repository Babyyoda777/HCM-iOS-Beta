//
//  ApiServices.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 12/08/2022.
//

import Foundation
import SwiftUI
import Combine

class ApiServices : ObservableObject{
    @Published var surahData : [Data] = []
    @Published var isLoading = true
     init(){
      
        guard let url = URL(string: "https://api.alquran.cloud/v1/surah") else {
            fatalError("Fatal Error URL")
        }
        
        let urlRequest = URLRequest(url: url)
        
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
         
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            if response.statusCode == 200{
                guard let data = data else{return}
              
                DispatchQueue.main.async {
                    do{
                        let decoderSurah = try JSONDecoder().decode(Surah.self, from: data)
                        self.surahData = decoderSurah.data
                        self.isLoading = false
                    }catch{
                        print("error decoding: ", error)
                    }
                }
            }

        }.resume()
    }
}
