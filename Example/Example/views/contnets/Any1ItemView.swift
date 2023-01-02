//
//  Any1ItmeView.swift
//  Example
//
//  Created by e4 on 2022/12/19.
//

import SwiftUI

struct Any1ItemView: View {
    
    var item: Any1Model
    
    var body: some View {
        ZStack(alignment: .center) {
            Button(action: {
                print("item.lable : \(item.label) item.id \(item.id)")
            }){
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        VStack{
                            Text(item.id)
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                                .padding(.bottom, 10)
                            Text(item.label)
                                .foregroundColor(.black)
                        }
                    )
                    .shadow(color: .gray, radius: 2, x: CGFloat(2), y: CGFloat(2))
            }
        }
        .frame(height: 72)
    }
}

struct Any1ItemView_Previews: PreviewProvider {
    static var previews: some View {
        Any1ItemView(item: Any1Model(id:"",label:""))
    }
}
