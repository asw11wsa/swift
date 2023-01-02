//
//  DaumApiView.swift
//  e4net
//
//  Created by e4 on 2022/12/20.
//

import SwiftUI

struct DaumApiView: View {
    @State var bar: String = ""
    @ObservedObject var viewModel = WebViewModel()
    @Binding var isShowApiView: Bool
    @Binding var zip_code: String
    @Binding var zip_addr: String
    
    var body: some View {
        VStack {
            //            WebView(url: "https://pgnt.tistory.com/", viewModel: viewModel)
            WebView(url: "https://asw11wsa.github.io/DaumApi/", viewModel: viewModel,showView:$isShowApiView)
        }
        // RunLoop: 입력 소스를 관리하는 개체에 대한 프로그래밍 방식 인터페이스 .main: 메인 스레드의 런 루프를 반환.
        .onReceive(self.viewModel.bar.receive(on: RunLoop.main)){ value in
            self.bar = value
            print("value = \(value)")
            if(value.contains("roadAddress")){
                zip_addr = String(value.split(separator: ":")[1])
            }else if(value.contains("zonecode")){
                zip_code = String(value.split(separator: ":")[1])
                isShowApiView.toggle()
            }
        }
        .navigationBarHidden(false)
    }
}

//struct DaumApiView_Previews: PreviewProvider {
//    static var previews: some View {
//        DaumApiView()
//    }
//}
