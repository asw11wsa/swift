//
//  ContentView.swift
//  Example
//
//  Created by e4 on 2022/12/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                NavView()
                    .frame(width: width, height: height)
            }
        }
        
        VStack {
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
