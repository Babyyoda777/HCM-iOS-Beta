//
//  adhanView.swift
//  Again
//
//  Created by Muhammad Shah on 14/08/2022.
//

import SwiftUI
import Adhan
import UIKit

let now = Date()
let twoDays: TimeInterval = 2 * 24 * 60 * 60
let date = now


struct adhanView: View {
    let cal = Calendar(identifier: Calendar.Identifier.gregorian)
    let coordinates = Coordinates(latitude: 51.5806, longitude: 0.3420)
    let size = UIScreen.main.bounds
    
    @State var sunrize : String
    @State var fajr : String
    @State var dhuhr : String
    @State var asr : String
    @State var maghrib : String
    @State var isha : String
    
    
    func calculateTime()->Void{
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        var params = CalculationMethod.moonsightingCommittee.params
        params.madhab = .hanafi
        params.adjustments.fajr = 3
        params.adjustments.sunrise = 2
        params.adjustments.dhuhr = 3
        params.adjustments.asr = 3
        params.adjustments.isha = 3
        if let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone(identifier: "Europe/London")!
            
            self.sunrize = formatter.string(from: prayers.sunrise)
            self.fajr = formatter.string(from: prayers.fajr)
            self.dhuhr = formatter.string(from: prayers.dhuhr)
            self.asr = formatter.string(from: prayers.asr)
            self.maghrib = formatter.string(from: prayers.maghrib)
            self.isha = formatter.string(from: prayers.isha)
        }
    }
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    Text(date, style: .time)
                        .fontWeight(.bold)
                        .font(.system(size:40))
                        .padding(.top, 5)
                        .foregroundColor(.green)
                    Text(date, style: .date)
                        .padding(.bottom, 5)
                }
                Section{
                    Text("Fajr     \(Image(systemName: "sun.haze.fill"))")
                        .badge(fajr)
                }
                Section{
                    Text("Sunrise  \(Image(systemName: "sunrise.fill"))")
                        .badge(sunrize)
                }
                Section{
                    Text("Zuhr     \(Image(systemName: "sun.max.fill"))")
                        .badge(dhuhr)
                }
                
                Section{
                    Text("Asr      \(Image(systemName: "sun.min.fill"))")
                        .badge(asr)
                }
                Section{
                    Text("Maghrib  \(Image(systemName: "sunset.fill"))")
                        .badge(maghrib)
                }
                Section{
                    Text("Isha     \(Image(systemName: "moon.stars.fill"))")
                        .badge(isha)
                }
            }
            .navigationBarTitle(Text("السلام عليكم"))
            .padding(.bottom, -200)
        }
        
        .disabled(true)
        .onAppear(perform: {
            calculateTime()
        })
        .offset(y: -60)
        .padding(.bottom, -50)
    }
}
struct adhanView_Previews: PreviewProvider {
    static var previews: some View {
        adhanView(sunrize: "1", fajr: "0", dhuhr: "0", asr: "0", maghrib: "0", isha: "0")
    }
}
