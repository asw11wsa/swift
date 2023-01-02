//
//  SecondView.swift
//  example
//
//  Created by e4 on 2022/12/20.
//
import SwiftUI

struct Any2View: View {
    
    @ObservedObject var viewModel = WebViewModel()
    
    
    var body: some View {
        VStack{
            NavigationLink(
                destination: WebView(url: "https://pgnt.tistory.com/112", viewModel: viewModel)){
                Text("TISTORY")
            }.padding()
            NavigationLink(
                destination: WebView(url: "https://www.google.com", viewModel: viewModel)){
                Text("GOOGLE")
            }.padding()
            NavigationLink(
                destination: WebView(url: "https://www.naver.com", viewModel: viewModel)){
                Text("NAVER")
            }.padding()
            NavigationLink(
                destination: WebView(url: "https://www.facebook.com", viewModel: viewModel)){
                Text("FACEBOOK")
            }.padding()
            NavigationLink(
                destination: TWebView()){
                Text("WebTextView")
            }.padding()
            Spacer()
        }
        .padding(.top, 40)
    }
}

struct Any2View_Previews: PreviewProvider {
    static var previews: some View {
        Any2View()
    }
}
