//
//  HomeView.swift
//  QuranOnline
//
//  Created by Achmad Rifqi on 04/04/22.
//

import SwiftUI
import AVKit
struct QuranView: View {
    @ObservedObject var dataSurah = ApiServices()
    var body: some View {
        NavigationView{
            List{
                
                    ForEach(dataSurah.surahData){
                        surah in
                        Section{
                        NavigationLink(destination : SurahDetail(number: surah.number,title: surah.englishName)){
                            HStack(spacing : 14){
                                Text("\(surah.number)")
                                    .foregroundColor(Color.primary)
                                    .frame(width : 45, height: 45)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                VStack(alignment : .leading, spacing: 4){
                                    Text("\(surah.name)")
                                        .font(.headline)
                                    Text("Surah \(surah.englishName)・\(surah.revelationType)")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    }
                    .padding([.leading, .trailing], 15)
                    if (dataSurah.isLoading){
                        VStack{
                            Indicator()
                            Text("Loading...")
                        }
                        .shadow(color: Color.secondary.opacity(0.3), radius: 20)
                    }
                
            }
            .navigationBarTitle("Qur'an")
            .environment(\.defaultMinListRowHeight, 110)
        }
        .offset(y: -60)
        .padding(.bottom, -20)
        .padding(.top, 26)
        
    }
}


struct QuranView_Previews: PreviewProvider {
    static var previews: some View {
        QuranView()
    }
}

class SoundManager : ObservableObject{
    @Published var audioPlayer : AVPlayer?
    @Published var isPlaying : Bool = false
    
    func playAudio(sound : String){
        if let urlAudio = URL(string: sound){
            self.audioPlayer = AVPlayer(url: urlAudio)
            self.audioPlayer?.play()
            self.isPlaying = true
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            
        }
        
    }
    
    func pauseAudio(){
        self.audioPlayer?.pause()
        self.isPlaying = false
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.isPlaying = false
    }
    
}



struct SurahDetail : View{
    var number : Int
    var title : String
    @State var playButtonId : Int = 0
    @ObservedObject var surahFetch = SurahDetailServices()
    @ObservedObject private var soundManager = SoundManager()
    
    var body: some View{
        ZStack{
            VStack{
                ScrollView(showsIndicators : false){
                    
                    ForEach(surahFetch.surahDetail){data in
                        VStack{
                            VStack(alignment : .trailing){
                                HStack{
                                    Spacer()
                                    Text("\(data.text)")
                                        .multilineTextAlignment(.trailing)
                                }
                                Button(action : {
                                    
                                    
                                    if (soundManager.isPlaying == true){
                                        soundManager.pauseAudio()
                                        
                                        if (playButtonId != data.id){
                                            soundManager.playAudio(sound: data.audio)
                                            self.playButtonId = data.id
                                        }
                                        
                                    }else{
                                        soundManager.playAudio(sound: data.audio)
                                        self.playButtonId = data.id
                                    }
                                    
                                    
                                }){
                                    
                                    if (data.id == playButtonId &&
                                        soundManager.isPlaying == true){
                                        HStack{
                                            Image(systemName: "pause.fill")
                                            Text("Audio")
                                        }
                                        .padding([.top, .bottom], 5)
                                        .padding([.leading, .trailing], 14)
                                        .background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 7))
                                    }else{
                                        HStack{
                                            Image(systemName: "play.fill")
                                            Text("Audio")
                                        }
                                        .padding([.top, .bottom], 5)
                                        .padding([.leading, .trailing], 14)
                                        .background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 7))
                                    }
                                    
                                    
                                }
                            }
                        }
                        .padding(.bottom, 80)
                    }
                    
                }
                .padding([.leading, .trailing], 14)
                
            }
            .padding(.bottom, 60)
            .padding(.top, 60)
        }
        .onAppear{
            self.surahFetch.getSurah(surahId: self.number)
        }
        .navigationTitle(Text("\(self.title)"))
    }
}

struct Indicator : UIViewRepresentable{
    
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = UIColor.lightGray
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}
