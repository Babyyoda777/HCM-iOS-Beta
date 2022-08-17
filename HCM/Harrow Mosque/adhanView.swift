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
                    Text(date, style: .date)
                        .padding(.bottom, 5)
                }.listRowBackground(LinearGradient(gradient: Gradient(colors: [.init("c1"), .init("c2")]), startPoint: .leading, endPoint: .trailing))
                Section{
                    Text("Fajr     \(Image(systemName: "sun.haze.fill"))")
                        .badge(fajr).foregroundColor(.primary)
                }
                Section{
                    Text("Sunrise  \(Image(systemName: "sunrise.fill"))")
                        .badge(sunrize).foregroundColor(.primary)
                }
                Section{
                    Text("Zuhr     \(Image(systemName: "sun.max.fill"))")
                        .badge(dhuhr).foregroundColor(.primary)
                }
                
                Section{
                    Text("Asr      \(Image(systemName: "sun.min.fill"))")
                        .badge(asr).foregroundColor(.primary)
                }
                Section{
                    Text("Maghrib  \(Image(systemName: "sunset.fill"))")
                        .badge(maghrib).foregroundColor(.primary)
                }
                Section{
                    Text("Isha     \(Image(systemName: "moon.stars.fill"))")
                        .badge(isha).foregroundColor(.primary)
                }
            }
            
            .navigationBarTitle("السلام عليكم")
            .navigationBarTitleTextColor(Color.init("title"))
            .padding(.bottom, -200)
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
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

extension View {
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
    
        return self
    }
}
