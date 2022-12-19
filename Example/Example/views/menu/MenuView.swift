//
//  MenuView.swift
//  Example
//
//  Created by e4 on 2022/12/19.
//

import SwiftUI

struct MenuView: View {
    
    @ObservedObject var navModel : NavModel
    
    var body: some View {
        NavigationView {
            ZStack{
                ScrollView(.vertical, showsIndicators: false){
                    VStack(alignment: .leading){
                        Divider().background(Color(.white))
                            .padding(.top, 100)
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.white)
                                .imageScale(.large)
                            Text("Profile")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding(.leading, 10)
                        Divider().background(Color(.white))
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.white)
                                .imageScale(.large)
                            Text("Messages")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding(.leading, 10)
                        Divider().background(Color(.white))
                        HStack {
                            Image(systemName: "gear")
                                .foregroundColor(.white)
                                .imageScale(.large)
                            Text("Profile")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding(.leading, 10)
                        Divider().background(Color(.white))
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity,alignment: .leading)
            }
            .background(Color.blue)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Menu", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action : {
                        withAnimation {
                            navModel.isShowMenu.toggle()
                        }
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.white)
                            .imageScale(.large)
                    }
            )
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(navModel:NavModel())
    }
}
