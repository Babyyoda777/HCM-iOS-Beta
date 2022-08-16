//
//  SurahDetailServices.swift
//  QuranOnline
//
//  Created by Achmad Rifqi on 05/04/22.
//

import Foundation
import SwiftUI
import Combine

class SurahDetailServices : ObservableObject{
    @Published var surahDetail : [Ayahs] = []
    
    func getSurah(surahId : Int){
    
        guard let url = URL(string: "https://api.alquran.cloud/v1/surah/\(surahId)/ar.alafasy") else{
            fatalError("Fatal Error")
        }
        
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
         
            guard let response = response as? HTTPURLResponse else{
                return
            }
          
            if response.statusCode == 200{
                guard let data = data else {
                    return
                }

                DispatchQueue.main.async {
                    do{
                        let jsonDecoder = try JSONDecoder().decode(SurahDetailModel.self, from: data)
                        
                        self.surahDetail = jsonDecoder.data.ayahs
                    }catch{
                        print("error decoding", error)
                    }
                }
            }
            
            
        }.resume()

    }
    
    
   
}
