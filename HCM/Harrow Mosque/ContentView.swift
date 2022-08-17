//
//  ContentView.swift
//  Again
//
//  Created by Muhammad Shah on 11/08/2022.
//

import SwiftUI
import WebKit
import UIOnboarding
import Adhan
import Combine
import CoreLocation
import UserNotifications

let coloredNavAppearance = UINavigationBarAppearance()
struct ContentView: View {
    init() {
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().isScrollEnabled = false
        UITableView.appearance().sectionFooterHeight = 0
    }
    @State private var showingOnboarding = false
    @State private var selected = 0
    
    
    @ObservedObject var compassHeading = CompassHeading()
    
    var body: some View {
        
        ZStack{
            GeometryReader{ geometry in
                VStack {
                    if self.selected == 0 {
                        adhanView(sunrize: "1", fajr: "0", dhuhr: "0", asr: "0", maghrib: "0", isha: "0")
                        
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
                                        Text("No settings to change here! It's all built-in.")
                                    }
                                  
                                    Section{
                                        Link("Donate to Harrow Mosque  \(Image(systemName: "link"))", destination: URL(string: "https://paypal.com/donate/?hosted_button_id=FF9AN9AKM8BXS&source=url")!)
                                            .foregroundColor(.primary)
                                        Link("Find out more about me!  \(Image(systemName: "link"))", destination: URL(string: "https://babyyoda777.github.io")!)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .listStyle(InsetGroupedListStyle()) // this has been renamed in iOS 14.*, as mentioned by @Elijah Yap
                                .environment(\.horizontalSizeClass, .regular)
                                .navigationTitle("Settings")
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
                            
                            Spacer(minLength: 25)
                            
                            Button(action: {
                                self.selected = 1
                            }) {
                                Image(systemName: "book.fill").foregroundColor(self.selected == 1 ? .init("title") : .primary).padding(.horizontal).font(.system(size: 18))
                            }
                            
                            Spacer(minLength: 25)
                            
                            Button(action: {
                                self.selected = 2
                            }) {
                                Image(systemName: "location.circle.fill").foregroundColor(self.selected == 2 ? .init("title") : .primary).padding(.horizontal) .font(.system(size: 18))
                            }
                            
                            Spacer(minLength: 25)
                            
                            Button(action: {
                                self.selected = 3
                            }) {
                                Image(systemName: "gearshape.fill").foregroundColor(self.selected == 3 ? .init("title") : .primary).padding(.horizontal).font(.system(size: 18))
                            }
                        }
                    }.padding(.vertical,self.expand ? 20 : 8)
                        .padding(.horizontal,self.expand ? 27 : 8)
                        .background(.ultraThinMaterial)
                        .background(LinearGradient(gradient: Gradient(colors: [.init("c1"), .init("c2")]), startPoint: .leading, endPoint: .trailing).opacity(0.23))
                        .cornerRadius(15)
                        .padding(22)
                    
                        .onLongPressGesture {
                            
                            self.expand.toggle()
                        }

                } else {
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
                            
                            Spacer(minLength: 25)
                            
                            Button(action: {
                                self.selected = 1
                            }) {
                                Image(systemName: "book.fill").foregroundColor(self.selected == 1 ? .init("title") : .primary).padding(.horizontal).font(.system(size: 18))
                            }
                            
                            Spacer(minLength: 25)
                            
                            Button(action: {
                                self.selected = 2
                            }) {
                                Image(systemName: "location.circle.fill").foregroundColor(self.selected == 2 ? .init("title") : .primary).padding(.horizontal) .font(.system(size: 18))
                            }
                            
                            Spacer(minLength: 25)
                            
                            Button(action: {
                                self.selected = 3
                            }) {
                                Image(systemName: "gearshape.fill").foregroundColor(self.selected == 3 ? .init("title") : .primary).padding(.horizontal).font(.system(size: 18))
                            }
                        }
                    }.padding(.vertical,self.expand ? 20 : 8)
                        .padding(.horizontal,self.expand ? 27 : 8)
                        .background(LinearGradient(gradient: Gradient(colors: [.init("c1"), .init("c2")]), startPoint: .leading, endPoint: .trailing).opacity(0.23))
                        .cornerRadius(15)
                        .padding(22)
                    
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
    
    
}

 
