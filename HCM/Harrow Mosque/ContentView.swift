//
//  ContentView.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 12/08/2022.
//

import SwiftUI
import WebKit
import UIOnboarding
import Adhan
import Combine
import CoreLocation
import UserNotifications

let now = Date()
let twoDays: TimeInterval = 2 * 24 * 60 * 60
let date = now
let coloredNavAppearance = UINavigationBarAppearance()
struct ContentView: View {
    let cal = Calendar(identifier: Calendar.Identifier.gregorian)
    let coordinates = Coordinates(latitude: 51.5806, longitude: 0.3420)
    let size = UIScreen.main.bounds
    
    @State  var sunrize : String
    @State  var fajr : String
    @State var dhuhr : String
    @State var asr : String
    @State var maghrib : String
    @State var isha : String
    
    @StateObject var feedViewModel = FeedViewModel()

    func calculateTime()->Void{
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        var params = CalculationMethod.moonsightingCommittee.params
        params.madhab = .hanafi
        params.adjustments.fajr = 5/2
        params.adjustments.sunrise = 2
        params.adjustments.dhuhr = 3
        params.adjustments.maghrib = -1
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

    @State private var showingOnboarding = false
    @State private var selected = 0
    @ObservedObject var compassHeading = CompassHeading()

    var body: some View {
        
        ZStack{
            GeometryReader{ geometry in
                VStack {
                    if self.selected == 0 {
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
                                    .listRowSeparator(.hidden)
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
                        .offset(y: -68)
                        .padding(.bottom, -50)
                        
                        
                    } else if self.selected == 1 {
                        GeometryReader { _ in
                            QuranView()
                            
                        }
                        
                    }
                    else if self.selected == 2 {
                        GeometryReader { geometry in
                            NavigationView{
                                List{
                                    Section{
                                        VStack {
                                            Capsule()
                                                .frame(width: 5, height: 30)
                                                .offset(y: -20)
                                            ZStack {
                                                ForEach(Marker.markers(), id: \.self) { marker in
                                                    CompassMarkerView(marker: marker,
                                                                      compassDegress: 0)
                                                }
                                            }
                                            
                                            .rotationEffect(Angle(degrees: self.compassHeading.degrees))
                                        }
                                        .padding(.bottom, 20)
                                        .padding(.top, 25)
                                        .offset(x: geometry.size.width/2.5)
                                    }
                                    .environment(\.defaultMinListRowHeight, 300)
                                    .navigationTitle(Text("Qibla Direction"))
                                    Section{
                                        Text("How To Use:")
                                    }
                                    Section{
                                        Text("1) Place flat on a non-metal surface.").font(.system(size: 14))
                                        Text("2) Allow a few seconds for compass to adjust.").font(.system(size: 14))
                                        Text("3) Rotate phone until the red capsule is in line.").font(.system(size: 14))
                                    }
                                    .environment(\.defaultMinListRowHeight, 10)
                                    .listStyle(InsetGroupedListStyle()) // this has been renamed in iOS 14.*, as mentioned by @Elijah Yap
                                    .environment(\.horizontalSizeClass, .regular)
                                    .listRowSeparator(.hidden)
                                }
                            }
                            .offset(y: -40)
                            .disabled(true)
                        }
                    }
                    else if self.selected == 3 {
                        GeometryReader { _ in
                            NavigationView{
                                List{
                                    Section{
                                        Button("Schedule Notification") {
                                            let content = UNMutableNotificationContent()
                                            content.title = "Fajr is at \(fajr)"
                                            content.subtitle = "Time to pray"
                                            content.sound = UNNotificationSound.default

                                            // show this notification five seconds from now
                                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                                            // choose a random identifier
                                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                                            // add our notification request
                                            UNUserNotificationCenter.current().add(request)
                                        }
                                    }
                                    .listRowSeparator(.hidden)
                                    Section{
                                        Link("\(Image(systemName: "link")) Donate to Harrow Mosque  ", destination: URL(string: "https://paypal.com/donate/?hosted_button_id=FF9AN9AKM8BXS&source=url")!)
                                            .foregroundColor(.primary)
                                        Link("\(Image(systemName: "link")) Find out more about me!  ", destination: URL(string: "https://babyyoda777.github.io")!)
                                            .foregroundColor(.primary)
                                    }.listRowSeparator(.hidden)
                                    Section{
                                        Link("\(Image(systemName: "play.rectangle.fill"))    YouTube ", destination: URL(string: "https://www.youtube.com/user/harrowmosque/videos")!)
                                            .foregroundColor(.primary)
                                    }.listRowSeparator(.hidden)
                                    Section{
                                        Link("\(Image(systemName: "camera.metering.center.weighted"))   Instagram ", destination: URL(string: "https://www.instagram.com/harrowmosque/")!)
                                            .foregroundColor(.primary)
                                    }.listRowSeparator(.hidden)
                                    Section{
                                        Link("\(Text("f").fontWeight(.bold).font(.system(size: 30)))      FaceBook ", destination: URL(string: "https://www.facebook.com/HarrowMosque")!)
                                            .foregroundColor(.primary)
                                    }.listRowSeparator(.hidden)
                                }
                                .listStyle(InsetGroupedListStyle()) // this has been renamed in iOS 14.*, as mentioned by @Elijah Yap
                                .environment(\.horizontalSizeClass, .regular)
                                .navigationTitle("Contact Us")
                            }
                        }
                    }
                    else if self.selected == 4 {
                        GeometryReader { _ in
                            if feedViewModel.isLoading {
                                LoadingView()
                            } else {
                                RSSListView(rssItems: feedViewModel.rssItems)
                            }

                        }
                        
                    }
                }
                .frame(height: geometry.size.height + 40)
                .fullScreenCover(isPresented: $showingOnboarding, content: {
                    OnboardingView.init()
                        .edgesIgnoringSafeArea(.all)
                })
                FloatingTabbar(selected: self.$selected)
            }
        }
    }
}

struct FloatingTabbar : View {
    
    @Binding var selected : Int
    @State var expand = true
    
    
    var body : some View{
        GeometryReader { geometry in
            HStack{
                Spacer(minLength: 0)
                if #available(iOS 15.0, *) {
                    HStack{
                        if !self.expand{
                            
                            Button(action: {
                                self.expand.toggle()
                            }) {
                                Image(systemName: "arrow.left").foregroundColor(.green).padding()
                            }
                        }
                        else{
                            Button(action: {
                                self.selected = 0
                            }) {
                                Image(systemName: "clock.fill").foregroundColor(self.selected == 0 ? .init("title") : .primary).padding(.horizontal).font(.system(size: 18))
                            }
                            
                            Spacer(minLength: 10)
                            
                            Button(action: {
                                self.selected = 1
                            }) {
                                Image(systemName: "book.fill").foregroundColor(self.selected == 1 ? .init("title") : .primary).padding(.horizontal).font(.system(size: 18))
                            }
                            
                            Spacer(minLength: 10)
                            
                            Button(action: {
                                self.selected = 2
                            }) {
                                Image(systemName: "location.circle.fill").foregroundColor(self.selected == 2 ? .init("title") : .primary).padding(.horizontal) .font(.system(size: 18))
                            }
                            Spacer(minLength: 10)
                            
                            Button(action: {
                                self.selected = 4
                            }) {
                                Image(systemName: "rectangle.3.offgrid.fill").foregroundColor(self.selected == 4 ? .init("title") : .primary).padding(.horizontal).font(.system(size: 18))
                            }

                            Spacer(minLength: 10)
                            
                            Button(action: {
                                self.selected = 3
                            }) {
                                Image(systemName: "gearshape.fill").foregroundColor(self.selected == 3 ? .init("title") : .primary).padding(.horizontal).font(.system(size: 18))
                            }
                        }
                    }.padding(.vertical,self.expand ? 20 : 8)
                        .padding(.horizontal,self.expand ? 15 : 8)
                        .background(.ultraThinMaterial)
                        .background(LinearGradient(gradient: Gradient(colors: [.init("c1"), .init("c2")]), startPoint: .leading, endPoint: .trailing).opacity(0.23))
                        .cornerRadius(15)
                        .padding(22)
                        .offset(y: 3)
                        .onLongPressGesture {
                            
                            self.expand.toggle()
                        }

                }
                
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 1.075 )
        }
        
    }
}


struct Webview: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
        let webview = WKWebView()
        
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
        
        return webview
    }
    
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<Webview>) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
    }
}


class CompassHeading: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var objectWillChange = PassthroughSubject<Void, Never>()
    var degrees: Double = .zero {
        didSet{
            objectWillChange.send()
        }
    }
    
    private var bearingOfKabah = Double()
    private let locationManager = CLLocationManager()
    private let locationOfKabah = CLLocation(latitude: 21.4225, longitude: 39.8262)
    
    override init() {
        super.init()
        self.setup()
    }
    
    private func setup() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.headingAvailable() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let north = -1 * newHeading.magneticHeading * Double.pi / 180
        let directionOfKabah = bearingOfKabah * Double.pi / 180 + north
        self.degrees = radiansToDegrees(directionOfKabah)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            bearingOfKabah = getBearingOfKabah(currentLocation: location, locationOfKabah: locationOfKabah)
        }
    }
    
    private func degreesToRadians(_ deg: Double) -> Double {
        return deg * Double.pi / 180
    }
    
    private func radiansToDegrees(_ rad: Double) -> Double {
        return rad * 180 / Double.pi
    }
    
    private func getBearingOfKabah(currentLocation: CLLocation, locationOfKabah: CLLocation) -> Double {
        let currentLatitude = degreesToRadians(currentLocation.coordinate.latitude)
        let currentLongitude = degreesToRadians(currentLocation.coordinate.longitude)
        
        let latitudeOfKabah = degreesToRadians(locationOfKabah.coordinate.latitude)
        let longitudeOfKabah = degreesToRadians(locationOfKabah.coordinate.longitude)
        
        let dLongitude = longitudeOfKabah - currentLongitude
        
        let y = sin(dLongitude) * cos(latitudeOfKabah)
        let x = cos(currentLatitude) - sin(latitudeOfKabah) - sin(currentLatitude) * cos(latitudeOfKabah) - cos(dLongitude)
        
        var radiansBearing = atan2(y, x)
        
        if radiansBearing < 0.0 {
            radiansBearing += 2 * Double.pi
        }
        
        return radiansToDegrees(radiansBearing)
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
        UITableView.appearance().sectionHeaderHeight = .zero
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}
