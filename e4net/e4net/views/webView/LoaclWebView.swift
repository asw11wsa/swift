//
//  WebView.swift
//  e4net
//
//  Created by e4 on 2022/12/20.
//

import SwiftUI

struct LocalWebView: View {
    @State var bar: String = ""
    @ObservedObject var viewModel = WebViewModel()
    @Binding var isShowWebView: Bool
    
    var body: some View {
        VStack {
            //            WebView(url: "https://pgnt.tistory.com/", viewModel: viewModel)
            WebView(url: "http://192.168.8.56:3000", viewModel: viewModel,showView:$isShowWebView)
        }
        // RunLoop: 입력 소스를 관리하는 개체에 대한 프로그래밍 방식 인터페이스 .main: 메인 스레드의 런 루프를 반환.
        .onReceive(self.viewModel.bar.receive(on: RunLoop.main)){ value in
            self.bar = value
        }
        .navigationBarHidden(true)
    }
}

//struct LocalWebView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalWebView()
//    }
//}
