//
//  LoadingView.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 12/08/2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20)  {
            ProgressView()
            Text("Fetching the articles ...")
                .foregroundColor(.gray)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
