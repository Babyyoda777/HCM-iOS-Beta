//
//  SurahModel.swift
//  Again
//
//  Created by Muhammad Shah on 10/08/22.
//

import Foundation
import SwiftUI

struct Surah : Codable{
    var data : [Data]
}


struct Data : Codable, Identifiable{
    var number : Int
    var name : String
    var englishName : String
    var englishNameTranslation : String
    var numberOfAyahs : Int
    var revelationType : String
    var id :Int {number}
    
}


