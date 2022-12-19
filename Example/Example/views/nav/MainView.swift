//
//  MainView.swift
//  Example
//
//  Created by e4 on 2022/12/19.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var navModel: NavModel
    
    var body: some View {
        TabView {
            Any1View()
                .tabItem {
                    Label("Any1", systemImage: "house")
                }
            Any2View()
                .tabItem{
                    Label("Any2", systemImage: "bag")
                }
        }
        .navigationBarTitle("EXAMPLE", displayMode: .inline)
        .navigationBarItems(
            leading:
                Button(action: {
                    withAnimation{
                        navModel.isShowMenu.toggle()
                    }
                }){
                    Image(systemName:"line.horizontal.3")
                        .foregroundColor(Color.blue)
                        .imageScale(.large)
                },
            trailing:
                Button(action: {
                    withAnimation{
                        print("click trailing")
                    }
                }){
                    Image(systemName:"gearshape")
                        .foregroundColor(Color.blue)
                        .imageScale(.large)
                }
            
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(navModel: NavModel())
    }
}
