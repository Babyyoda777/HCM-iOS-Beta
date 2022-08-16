//
//  User.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 11/08/2022.
//

import Foundation

struct User: Identifiable, Decodable {
    var id: Int
    var fajr_jamat: String
    var dhuhr_jamat: String
    var magrib_jamat: String
    var asr_jamat: String
    var isha_jamat: String
}
