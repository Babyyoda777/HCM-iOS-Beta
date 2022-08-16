//
//  SurahModel.swift
//  QuranOnline
//
//  Created by Achmad Rifqi on 01/04/22.
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


