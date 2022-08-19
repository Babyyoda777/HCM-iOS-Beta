//
//  HarrowMosqueApp.swift
//  HarrowmMosque
//
//  Created by Muhammad Shah on 11/08/2022.
//

import SwiftUI

@main

struct HarrowMosque: App {
    var objEnv = ApiServices()
    var body: some Scene {
        WindowGroup {
            
            ContentView(sunrize: "1", fajr: "0", dhuhr: "0", asr: "0", maghrib: "0", isha: "0")
        }
    }
}
