//
//  ContentView.swift
//  e4net
//
//  Created by e4 on 2022/12/20.
//

import SwiftUI
import AlertToast
import Alamofire

struct ContentView: View {
    
    @State private var showToast = false
    @State private var showErrorLogin = false
    
    @State var username: String = ""
    @State var password: String = ""
    @State var text: String = ""
    
    // 내용이 변경되는 경우 화면이 변경이 된다
    // 2안
    @State var isShowJoinView = false
    @State var isShowWebView = false
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Here is E4net!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                Image("userImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipped()
                    .cornerRadius(150)
                    .padding(.bottom, 30)
                TextField("", text: $username)
                    .placeholder(when: username.isEmpty) {
                        Text("Username").foregroundColor(.gray)
                    }
                    .padding()
                    .frame(width: 300, height: 60, alignment: .center)
                    .background(Color(.white))
                    .cornerRadius(15.0)
                    .foregroundColor(Color(.black))
                    .padding(.bottom, 15)
                SecureField("", text: $password)
                    .placeholder(when: password.isEmpty) {
                        Text("Password").foregroundColor(.gray)
                    }
                    .padding()
                    .frame(width: 300, height: 60, alignment: .center)
                    .background(Color(.white))
                    .cornerRadius(15.0)
                    .foregroundColor(Color(.black))
                    .padding(.bottom, 15)
                
                NavigationLink("",
                   destination: LocalWebView(isShowWebView:$isShowWebView),
                    isActive: $isShowWebView)
                
                
                Button(action: {
                    let loginModel = LoginModel(membId: username, membPwd: password)
                    HttpClient<ResLogin>().alamofireNetworkingkPost(
                        url: URLInfo.getLoginUrl(),
                        param: loginModel,
                        onSuccess: { (resData) in
                            if(resData.check == "1"){
                                showToast.toggle()
                                UserDefaults.standard.setValue(resData.token, forKey: "STOKEN")
                            }else{
                                showErrorLogin.toggle()
                            }
                        },
                        onFailure: {
                            showErrorLogin = true
                        }
                    )
                }){
                    Text("LOGIN")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.green)
                        .cornerRadius(15.0)
                }
                
                // 위에 뒤로가기 버튼이 존재하는 버전
                // 1안
//                NavigationLink {
//                    JoinView()
//                } label: {
//                    Text("this is Join")
//                }
                
                // 원하는 버튼안에 뒤로가기 버튼을 작동시키는 버전
                // 2안
                NavigationLink("",
                   destination: JoinView(isShowJoinView: $isShowJoinView),
                   isActive: $isShowJoinView)
                
                Button(action:{
                    isShowJoinView.toggle()
                }){
                    Text("join")
                }
            }
            .ignoresSafeArea()
            .padding(.top,80)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
            .toast(isPresenting: $showToast,duration: 0.9,alert: {
                AlertToast(type: .complete(Color.green), title: "로그인", subTitle: "#성공적")
            },completion: {
                username = ""
                password = ""
                isShowWebView.toggle()
            })
            .toast(isPresenting: $showErrorLogin,duration: 0.9,alert: {
                AlertToast(type: .error(Color.red), title: "일치하는 정보가 없습니다.")
            })
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
