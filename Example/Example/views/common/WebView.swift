//
//  WebView.swift
//  Example
//
//  Created by e4 on 2022/12/20.
//

import UIKit
import SwiftUI
import Combine
import WebKit

// 브릿지 통신안하는 일반적인 웹 뷰 생성
//struct WebView: UIViewRepresentable {
//
//    var url: String
//    func makeUIView(context: Context) -> WKWebView {
//
//        guard let url = URL(string: self.url) else {
//            return WKWebView()
//        }
//
//        let webView = WKWebView()
//        webView.load(URLRequest(url: url))
//        return webView
//    }
//
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//
//    }
//}

// 'webview.coordinator'가 예상 유형인 'WKScriptMessageHandler'와 일치하지 않기때문에 extention
// WKScriptMessageHandler: 웹 페이지에서 실행되는 JavaScript 코드에서 메시지를 수신하기 위한 인터페이스입니다.
extension WebView.Coordinator: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage){
        // 수신한 메시지의 네임이 일치하는경우
        print("message name is \(message.name)")
        if message.name == "EXAMPLE" {
            // 대리자의 필수 정의인 received
            delegate?.receivedJsonValueFromWebView(value: message.body as! [String : Any?])
        }
    }
}

// javascript와 Native간의 데이터 통신을 위한 프로토콜/함수 정의
protocol WebViewHandlerDelegate {
    func receivedJsonValueFromWebView(value: [String: Any?])
}

//protocol UIViewRepresentable: 해당 뷰를 SwiftUI 뷰 계층 구조에 통합하는 데 사용하는 UIKit 보기에 대한 래퍼입니다.
struct WebView: UIViewRepresentable, WebViewHandlerDelegate {
    var url: String
    @ObservedObject var viewModel: WebViewModel = WebViewModel()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func receivedJsonValueFromWebView(value: [String : Any?]) {
        print("from javascript JSON : \n", value)
        if let action = value["action"] as? String{
            print("action : ", action)
            
            switch action {
            case "test":
                if let param = value["param"] as? [String: Any?] {
                    pong(param:param)
                }
            default:
                return
            }
        }
    }
    
    func pong(param: [String: Any?]){
        if let count = param["count"] as? String {
            print("count : " , count)
            self.viewModel.bar.send(Int(count)!)
        }
    }
    
    // 필수 정의
    func makeUIView(context: Context) -> WKWebView {
        print("makeUIView")
        // 웹 사이트에 적용할 표준 동작을 캡슐화하는 개체.
        let preferences = WKPreferences()
        
        // JavaScript가 사용자 상호 작용없이 창을 열 수 있는지 여부
        preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // 웹 보기를 초기화하는 데 사용하는 속성 모음.
        let configuration = WKWebViewConfiguration()
        
        // 웹 보기에 대한 기본 설정 관련 설정을 관리하는 개체 정의
        configuration.preferences = preferences
        
        // 앱의 기본 코드와 웹 페이지의 스크립트 및 기타 콘텐츠 간의 상호 작용을 조정하는 개체.
        configuration.userContentController.add(self.makeCoordinator(), name: "EXAMPLE")
        
        // 웹 뷰를 생성하고 지정된 프레임 및 구성 데이터로 초기화. CGRect: 직사각형의 위치와 치수를 포함하는 구조., .zero: 원점과 크기가 모두 0인 사각형.
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        
        // 웹보기의 탐색 동작을 관리하는 데 사용하는 개체
        webView.navigationDelegate = context.coordinator
        
        // 가로로 스와이프 동작이 페이지 탐색을 앞뒤로 트리거하는지 여부
        webView.allowsBackForwardNavigationGestures = true
        
        // 웹보기와 관련된 스크롤보기에서 스크롤 가능 여부
        webView.scrollView.isScrollEnabled = true
        
        if let url = URL(string: url) {
            // 지정된 URL 요청 개체에서 참조하는 웹 콘텐츠를로드하고 탐색
            webView.load(URLRequest(url: url))
        }
        return webView
    }
    
    // 필요하지 않는 이상 코드 추가하지 않아도 됨.
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    //class NSOpject: 대부분의 Objective-C 클래스 계층의 루트 클래스로, 하위 클래스가 런타임 시스템에 대한 기본 인터페이스와 Objective-C 개체로 작동하는 기능을 상속
    //protocol WKNavigationDelegate: 탐색 변경을 수락 또는 거부하고 탐색 요청의 진행 상황을 추적하는 메소드
    class Coordinator : NSObject, WKNavigationDelegate {
        var parent: WebView
        var foo: AnyCancellable? = nil
        
        var delegate: WebViewHandlerDelegate?
        
        // 생성자
        init(_ uiWebView: WebView) {
            self.parent = uiWebView
            self.delegate = parent
        }
        
        // 소멸자
        deinit {
            foo?.cancel()
        }
        //탐색 요청 허용 또는 거부
        // 지정된 기본 설정 및 작업 정보를 기반으로 새 콘텐츠를 탐색할 수 있는 권한을 대리자에게 요청
        //        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        //            print("지정된 기본 설정 및 작업 정보를 기반으로 새 콘텐츠를 탐색할 수 있는 권한을 대리자에게 요청")
        //            decisionHandler(.allow, preferences)
        //        }
        
        // 지정된 작업 정보를 기반으로 새 콘텐츠를 탐색할 수 있는 권한을 대리인에게 요청합니다.
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            print("지정된 작업 정보를 기반으로 새 콘텐츠를 탐색할 수 있는 권한을 대리인에게 요청합니다.")
            //            if let host = navigationAction.request.url?.host {
            //                // 특정 도메인을 제외한 도메인을 연결하지 못하게 할 수 있다.
            //                if host != "pgnt.tistory.com" {
            //                    decisionHandler(.cancel)
            //                    return
            //               }
            //            }
            
            self.foo = self.parent.viewModel.foo.receive(on: RunLoop.main).sink(receiveValue: { value in
                webView.evaluateJavaScript("fromNative('\(value)')", completionHandler: { result, error in
                    if let anError = error {
                        print("Error \(anError.localizedDescription)")
                    }
                    print("Result: \(result ?? "")")
                })
            })
            decisionHandler(.allow)
        }
        
        // 탐색 요청에 대한 응답이 알려진 후 대리인에게 새 콘텐츠 탐색 권한을 요청
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            print("탐색 요청에 대한 응답이 알려진 후 대리인에게 새 콘텐츠 탐색 권한을 요청")
            decisionHandler(.allow)
        }
        
        //요청의 로드 진행률 추적
        // 주 프레임에서 탐색이 시작되었음을 대리자에게 알림
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("주 프레임에서 탐색이 시작되었음을 대리자에게 알림")
        }
        
        // 웹 보기가 요청에 대한 서버 리디렉션을 수신했음을 대리자에게 알림
        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            print("웹 보기가 요청에 대한 서버 리디렉션을 수신했음을 대리자에게 알림")
        }
        
        // 웹 보기가 메인 프레임에 대한 콘텐츠를 수신하기 시작했음을 대리자에게 알림
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("웹 보기가 메인 프레임에 대한 콘텐츠를 수신하기 시작했음을 대리자에게 알림")
        }
        
        // 탐색이 완료되었음을 대리자에게 알림
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("탐색이 완료되었음을 대리자에게 알림")
        }
        
        
        //인증 문제에 응답
        // 대리자에게 인증 질문에 응답하도록 요청
        //        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        //            print("대리자에게 인증 질문에 응답하도록 요청")
        //        }
        
        // 사용되지 않는 버전의 TLS를 사용하는 연결을 계속할지 여부를 대리인에게 묻음
        func webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void) {
            print("사용되지 않는 버전의 TLS를 사용하는 연결을 계속할지 여부를 대리인에게 물음")
        }
        
        //탐색 오류에 응답하기
        // 탐색 중 오류가 발생했음을 대리자에게 알림
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("탐색 중 오류가 발생했음을 대리자에게 알림")
        }
        
        //초기 탐색 프로세스 중에 오류가 발생했음을 대리자에게 알림
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("초기 탐색 프로세스 중에 오류가 발생했음을 대리자에게 알림")
        }
        
        // 웹 보기의 콘텐츠 프로세스가 종료되었음을 대리자에게 알림
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            print("웹 보기의 콘텐츠 프로세스가 종료되었음을 대리자에게 알림")
        }
        
        //        //인스턴스 메소드
        //        func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        //
        //        }
        //        func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        //
        //        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: "https://pgnt.tistory.com/112")
    }
}
