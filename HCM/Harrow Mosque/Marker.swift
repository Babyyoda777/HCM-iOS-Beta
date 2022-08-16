//
//  Marker.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 12/08/2022.
//

import Foundation
import SwiftUI

struct Marker: Hashable {
    let degrees: Double
    let label: String

    
    init(degrees: Double, label: String = "") {
        self.degrees = degrees
        self.label = label
    }
    
    static func markers() -> [Marker] {
        return [
            Marker(degrees: 0, label: "S"),
            Marker(degrees: 30),
            Marker(degrees: 60),
            Marker(degrees: 90, label:"W"),
            Marker(degrees: 120),
            Marker(degrees: 150),
            Marker(degrees: 180, label: "N"),
            Marker(degrees: 210),
            Marker(degrees: 240),
            Marker(degrees: 270, label: "E"),
            Marker(degrees: 300,label: ""),
            Marker(degrees: 330)
        ]
    }
    
    func degreeText() -> String {
        return String(format: "%.0f", self.degrees)
    }
}
