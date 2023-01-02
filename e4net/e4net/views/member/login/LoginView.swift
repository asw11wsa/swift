//
//  LoginView.swift
//  e4net
//
//  Created by e4 on 2022/12/20.
//

import SwiftUI
import AlertToast

struct LoginView: View {
    
    @State private var showToast = false
    
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
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
            Button(action: {
                showToast.toggle()
            }){
                Text("LOGIN")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
            Spacer()
        }
        .ignoresSafeArea()
        .padding(.top,80)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
        .toast(isPresenting: $showToast){
            AlertToast(type: .complete(Color.green), title: "로그인", subTitle: "#성공적")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
