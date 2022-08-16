//
//  CompassMarkerView.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 12/08/2022.
//

import SwiftUI

struct CompassMarkerView: View {
    let marker: Marker
    let compassDegress: Double
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: self.capsuleWidth(), height: self.capsuleHeight())
                .foregroundColor(self.capsuleColor())
                .padding(.bottom, 120)
            
           Text(marker.label)
                .fontWeight(.bold)
                .rotationEffect(self.textAngle())
                .padding(.bottom, -130)
                .padding(.bottom, -10)
        }.rotationEffect(Angle(degrees: marker.degrees))
    }
    
    private func capsuleWidth() -> CGFloat {
        return self.marker.degrees == 120 ? 7 : 3
    }
    
    private func capsuleHeight() -> CGFloat {
        return self.marker.degrees == 120 ? 40 : 30
    }
    
    private func capsuleColor() -> Color {
        return self.marker.degrees == 120 ? .red : .gray
    }
    
    private func textAngle() -> Angle {
        return Angle(degrees: -self.compassDegress - self.marker.degrees)
    }
}
