//
//  JoinView.swift
//  e4net
//
//  Created by e4 on 2022/12/20.
//

import SwiftUI
import AlertToast

struct JoinView: View {
    @Binding var isShowJoinView: Bool
    @State var isShowApiView: Bool = false
    @State private var joinSuccesToast = false
    @State private var successMessage: String = ""
    @State private var joinFailureToast = false
    @State private var failureMessage: String = ""
    
    @State var id: String = ""
    @State var password: String = ""
    @State var check_password: String = ""
    @State var name: String = ""
    @State var phone: String = ""
    @State var email: String = ""
    @State var zip_code: String = ""
    @State var zip_addr: String = ""
    @State var detail_addr: String = ""
    
    var body: some View {
        VStack{
            ZStack{
                TextField("", text: $id)
                    .placeholder(when: id.isEmpty) {
                        Text("Username").foregroundColor(.gray)
                    }
                    .padding()
                    .frame(width: 300, height: 40, alignment: .center)
                    .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
                    .cornerRadius(15.0)
                    .foregroundColor(Color(.black))
                    .padding(.bottom, 15)
                Button(action: {
                    HttpClient<ResIdcheck>().alamofireNetworkingGet(
                        url: "\(URLInfo.getIdcheckUrl())?membId=\(id)",
                        onSuccess: { (resData) in
                            print(resData.response)
                            if(resData.response == 0){
                                joinSuccesToast.toggle()
                                successMessage = "사용가능한 아이디 입니다."
                            }else{
                                joinFailureToast.toggle()
                                failureMessage = "사용할수 없는 아이디 입니다."
                            }
                        },
                        onFailure: {
                            joinFailureToast.toggle()
                        }
                    )
                }){
                    Text("id check")
                }
            }
            SecureField("", text: $password)
                .placeholder(when: password.isEmpty) {
                    Text("Password").foregroundColor(.gray)
                }
                .padding()
                .frame(width: 300, height: 40, alignment: .center)
                .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
                .cornerRadius(15.0)
                .foregroundColor(Color(.black))
                .padding(.bottom, 15)
            SecureField("", text: $check_password)
                .placeholder(when: check_password.isEmpty) {
                    Text("Password Check").foregroundColor(.gray)
                }
                .padding()
                .frame(width: 300, height: 40, alignment: .center)
                .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
                .cornerRadius(15.0)
                .foregroundColor(Color(.black))
                .padding(.bottom, 15)
            TextField("", text: $name)
                .placeholder(when: name.isEmpty) {
                    Text("Name").foregroundColor(.gray)
                }
                .padding()
                .frame(width: 300, height: 40, alignment: .center)
                .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
                .cornerRadius(15.0)
                .foregroundColor(Color(.black))
                .padding(.bottom, 15)
            TextField("", text: $phone)
                .placeholder(when: phone.isEmpty) {
                    Text("Phone").foregroundColor(.gray)
                }
                .padding()
                .frame(width: 300, height: 40, alignment: .center)
                .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
                .cornerRadius(15.0)
                .foregroundColor(Color(.black))
                .padding(.bottom, 15)
            TextField("", text: $email)
                .placeholder(when: email.isEmpty) {
                    Text("Email").foregroundColor(.gray)
                }
                .padding()
                .frame(width: 300, height: 40, alignment: .center)
                .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
                .cornerRadius(15.0)
                .foregroundColor(Color(.black))
                .padding(.bottom, 15)
            TextField("", text: $zip_code)
                .placeholder(when: zip_code.isEmpty) {
                    Text("Zip Code").foregroundColor(.gray)
                }
                .padding()
                .frame(width: 300, height: 40, alignment: .center)
                .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
                .cornerRadius(15.0)
                .foregroundColor(Color(.black))
                .padding(.bottom, 15)
            TextField("", text: $zip_addr)
                .placeholder(when: zip_addr.isEmpty) {
                    Text("Zip Address").foregroundColor(.gray)
                }
                .padding()
                .frame(width: 300, height: 40, alignment: .center)
                .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
                .cornerRadius(15.0)
                .foregroundColor(Color(.black))
                .padding(.bottom, 15)
            TextField("", text: $detail_addr)
                .placeholder(when: detail_addr.isEmpty) {
                    Text("Detail Address").foregroundColor(.gray)
                }
                .padding()
                .frame(width: 300, height: 40, alignment: .center)
                .background(Color(red: 211 / 255, green: 211 / 255, blue: 211 / 255))
                .cornerRadius(15.0)
                .foregroundColor(Color(.black))
                .padding(.bottom, 15)
            Group{
                Button {
                    let joinModel = JoinModel(
                        membId: id,
                        membPwd: password,
                        membNm: name,
                        mobileNo: phone,
                        emailAddr: email,
                        zipCd: zip_code,
                        zipAddr: zip_addr,
                        detailAddr: detail_addr
                    )
                    HttpClient<ResJoin>().alamofireNetworkingkPostJoin(
                        url: URLInfo.getJoinUrl(),
                        param: joinModel,
                        onSuccess: { (resData) in
                            print(resData.result)
                            joinSuccesToast.toggle()
                        },
                        onFailure: {
                            joinFailureToast.toggle()
                        }
                    )
                    
                } label: {
                    Text("join")
                        .frame(width: 200, height: 40, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                        .foregroundColor(Color(.white))
                        .padding(.bottom, 5)
                }
                Button {
                    isShowJoinView.toggle()
                } label: {
                    Text("back")
                        .frame(width: 200, height: 40, alignment: .center)
                        .background(Color.red)
                        .cornerRadius(15.0)
                        .foregroundColor(Color(.white))
                        .padding(.bottom, 5)
                }
                
                NavigationLink("",
                               destination: DaumApiView(isShowApiView: $isShowApiView,zip_code:$zip_code,zip_addr:$zip_addr),
                   isActive: $isShowApiView)
                
                Button(action:{
                    isShowApiView.toggle()
                }){
                    Text("주소 찾기")
                }
            }
            
        }
        .toast(isPresenting: $joinSuccesToast,duration: 0.9,alert:{
            AlertToast(type: .complete(Color.green), title: successMessage)
        },completion: {
            isShowJoinView.toggle()
        })
        .toast(isPresenting: $joinFailureToast,duration: 0.9,alert:{
            AlertToast(type: .error(Color.red), title: failureMessage)
        })
        .navigationBarHidden(true)
    }
}

//struct JoinView_Previews: PreviewProvider {
//    static var previews: some View {
//        JoinView()
//    }
//}
