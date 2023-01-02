//
//  any1.swift
//  example
//
//  Created by net e4 on 2022/12/19.
//

import SwiftUI

struct Any1View: View {
    
    @ObservedObject var pageModel = PageModel()
    @State var any1ItemList :[Any1Model] = []
    @State var showingAlert = false
    //위의 Bool은 false가 default라서 안 써도 되고, 써도 된다.
    
    
    var body: some View {
        GeometryReader { geometry in
            let columns: [GridItem] = [GridItem()]
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(Array(any1ItemList.enumerated()), id:\.offset){ i, item in
                        Any1ItemView(item: item)
                            .onAppear(){
                                if(pageModel.maxCnt < i + 1){
                                    pageModel.maxCnt = i + 1
                                    if(pageModel.maxCnt % 10 == 0){
                                        tryLoadItem()
                                    }
                                }
                            }
                    }
                }
            }.onAppear(){
                print("onAppear")
                tryLoadItem()
            }
        }
        .alert("네트워크 통신 오류", isPresented: $showingAlert){
            Button("재시도", role: .cancel){
                loadItems()
            }
            Button("취소", role: .destructive){
                pageModel.current -= 1
            }
        }message : {
            Text("네트워크가 원활하지 않습니다. 재요청 하시겠습니까?")
        }
    }
    
    func tryLoadItem(){
        if(pageModel.hasMorePages){
            pageModel.current += 1
            loadItems()
        }
    }
    
    func loadItems(){
        print("loadItems")
        HttpClient<ResAny1>().alamofireNetworking(
            url: URLInfo.getAny1ListUrl(currentPage: pageModel.current),
            onSuccess: { (resData) in
                print("resData : \(resData)")
                pageModel.hasMorePages = resData.hasMorePages
                let loadItems = resData.items
                loadItems.forEach{ loadItem in
                    print("loadItem : \(loadItem)")
                    any1ItemList.append(loadItem)
                }
            },
            onFailure: {
                showingAlert = true
            }
        )
    }
}
struct Any1View_Previews: PreviewProvider {
    static var previews: some View {
        //위에 초기화가 되어있으므로 안에 비어져있어도 된다.
        Any1View()
    }
}
