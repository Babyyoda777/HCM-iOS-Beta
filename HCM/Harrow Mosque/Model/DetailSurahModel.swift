//
//  DetailSurahModel.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 12/08/2022.
//


import Foundation
import SwiftUI

struct SurahDetailModel : Codable{
    var data : DataDetail
}
struct DataDetail : Codable{
    var name : String
    var englishName : String
    var englishNameTranslation : String
    var revelationType : String
    var numberOfAyahs : Int
    var ayahs : [Ayahs]
}

struct Ayahs : Codable, Identifiable{
    var number : Int
    var audio : String
    var text : String
    var id : Int{number}
}
