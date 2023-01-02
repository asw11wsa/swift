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

// 주고받을 형식에 대한 프로토콜 생성
protocol WebViewHandlerDelegate {
    func receivedJsonValueFromWebView(value: [String: Any?])
    func receivedStringValueFromWebView(value: String)
}


struct WebView: UIViewRepresentable, WebViewHandlerDelegate {
    var url: String
    @ObservedObject var viewModel: WebViewModel
    @Binding var showView: Bool
 
    func receivedJsonValueFromWebView(value: [String : Any?]) {
        //print("JSON 데이터가 웹으로부터 옴: \(value)")
        if let message = value["message"] as? String{
            print("action : ", message)
            
            switch message {
            case "getToken":
                print("getToken")
            case "daumapi":
                if let roadAddress = value["roadAddress"] as? String{
                    print(roadAddress)
                    self.viewModel.bar.send("roadAddress:\(roadAddress)")
                }
                if let zonecode = value["zonecode"] as? String{
                    print(zonecode)
                    self.viewModel.bar.send("zonecode:\(zonecode)")
                }
                showView = false
            case "logout":
                showView.toggle()
                UserDefaults.standard.removeObject(forKey: "STOKEN")
            default:
                return
            }
        }
    }
    
    func sendToken(token:String) -> String {
        return token
    }
    
    func receivedStringValueFromWebView(value: String) {
        print("String 데이터가 웹으로부터 옴: \(value)")
    }
    
    // 변경 사항을 전달하는 데 사용하는 사용자 지정 인스턴스를 만듭니다.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // 뷰 객체를 생성하고 초기 상태를 구성합니다. 딱 한 번만 호출됩니다.
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false  // JavaScript가 사용자 상호 작용없이 창을 열 수 있는지 여부
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController.add(self.makeCoordinator(), name: "EXAMPLE")
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator    // 웹보기의 탐색 동작을 관리하는 데 사용하는 개체
        webView.uiDelegate = context.coordinator           // 알럿창을 실행 시키기 위해서 추가 코드
        webView.allowsBackForwardNavigationGestures = true    // 가로로 스와이프 동작이 페이지 탐색을 앞뒤로 트리거하는지 여부
        webView.scrollView.isScrollEnabled = true    // 웹보기와 관련된 스크롤보기에서 스크롤 가능 여부
        
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))    // 지정된 URL 요청 개체에서 참조하는 웹 콘텐츠를로드하고 탐색
        }
        
        return webView
    }
    
    // 지정된 뷰의 상태를 다음의 새 정보로 업데이트합니다.
    func updateUIView(_ webView: WKWebView, context: Context) {
        
    }
    
    // 탐색 변경을 수락 또는 거부하고 탐색 요청의 진행 상황을 추적
    class Coordinator : NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebView
        var foo: AnyCancellable? = nil
        var delegate: WebViewHandlerDelegate?
        var first: Int = 0
        
        // 생성자
        init(_ uiWebView: WebView) {
            self.parent = uiWebView
            self.delegate = parent
        }

        // 소멸자
        deinit {
            foo?.cancel()
        }
        
        // Alert 처리
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            if(first == 0){
                if let token = UserDefaults.standard.string(forKey: "STOKEN"){
                    webView.evaluateJavaScript("saveTokens('\(token)')", completionHandler: { result, error in
                        if let anError = error {
                            print("Error \(anError.localizedDescription)")
                        }
                                        
                        print("Result \(result ?? "")")
                    })
                }
            }
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in completionHandler() })
            showAlert(alert: alert)
        }

        // Confirm 처리
        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in completionHandler(true) })
            alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in completionHandler(false) })
            showAlert(alert: alert)
        }

        // Prompt 처리
        func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> ()) {
            let alert = UIAlertController(title: "알림", message: prompt, preferredStyle: .alert)

            var inputTextField: UITextField?
            alert.addTextField() { textField in
                textField.placeholder = defaultText
                inputTextField = textField
            }

            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in completionHandler(inputTextField?.text) })
            alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in completionHandler(nil) })
            showAlert(alert: alert)
        }

        // 알림창 출력
        func showAlert(alert: UIAlertController) {
            if let controller = topMostViewController() {
                controller.present(alert, animated: true)
            }
        }

        // keyWindow 획득
        private func keyWindow() -> UIWindow? {
            return UIApplication.shared.connectedScenes
                    .filter {$0.activationState == .foregroundActive}
                    .compactMap {$0 as? UIWindowScene}
                    .first?.windows.filter {$0.isKeyWindow}.first
        }

        // 최상위 VC 획득
        private func topMostViewController() -> UIViewController? {
            guard let rootController = keyWindow()?.rootViewController else {
                return nil
            }
            return topMostViewController(for: rootController)
        }

        private func topMostViewController(for controller: UIViewController) -> UIViewController {
            if let presentedController = controller.presentedViewController {
                return topMostViewController(for: presentedController)
            } else if let navigationController = controller as? UINavigationController {
                guard let topController = navigationController.topViewController else {
                    return navigationController
                }
                return topMostViewController(for: topController)
            } else if let tabController = controller as? UITabBarController {
                guard let topController = tabController.selectedViewController else {
                    return tabController
                }
                return topMostViewController(for: topController)
            }
            return controller
        }
        
        // 지정된 기본 설정 및 작업 정보를 기반으로 새 콘텐츠를 탐색 할 수있는 권한을 대리인에게 요청
        func webView(_ webView: WKWebView,
                       decidePolicyFor navigationAction: WKNavigationAction,
                       decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            if let host = navigationAction.request.url?.host {
//                // 특정 도메인을 제외한 도메인을 연결하지 못하게 할 수 있다.
//                if host != "velog.io" {
//                   return decisionHandler(.cancel)
//               }
//            }
            
            // bar에 값을 send 해보자!
            //parent.viewModel.bar.send("test")
            
            // foo로 값이 receive 되면 출력해보자!
//            self.foo = self.parent.viewModel.foo.receive(on: RunLoop.main)
//                                                .sink(receiveValue: { value in
//                // 여기서 webView란 WKWebview 객체이다.
//                if let token = UserDefaults.standard.string(forKey: "STOKEN"){
//                    webView.evaluateJavaScript("saveTokens('\(token)')", completionHandler: { result, error in
//                        if let anError = error {
//                            print("Error \(anError.localizedDescription)")
//                        }
//
//                        print("Result \(result ?? "")")
//                    })
//                }
//            })
            
            return decisionHandler(.allow)
        }
         
        // 기본 프레임에서 탐색이 시작되었음
        func webView(_ webView: WKWebView,
                       didStartProvisionalNavigation navigation: WKNavigation!) {
            print("기본 프레임에서 탐색이 시작되었음")
        }
        
        // 웹보기가 기본 프레임에 대한 내용을 수신하기 시작했음
        func webView(_ webView: WKWebView,
                       didCommit navigation: WKNavigation!) {
            print("내용을 수신하기 시작");
        }
        
        // 탐색이 완료 되었음
        func webView(_ webView: WKWebView,
                       didFinish: WKNavigation!) {
            print("탐색이 완료되었음을 대리자에게 알림")
        }
        
        // 초기 탐색 프로세스 중에 오류가 발생했음 - Error Handler
        func webView(_ webView: WKWebView,
                       didFailProvisionalNavigation: WKNavigation!,
                       withError: Error) {
            print("초기 탐색 프로세스 중에 오류가 발생했음")
        }
        
        // 탐색 중에 오류가 발생했음 - Error Handler
        func webView(_ webView: WKWebView,
                       didFail navigation: WKNavigation!,
                       withError error: Error) {
            print("탐색 중에 오류가 발생했음")
        }
    }
}

// Coordinator 클래스에 WKScriptMessageHandler 프로토콜 추가 적용
extension WebView.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                                 didReceive message: WKScriptMessage) {
        if message.name == "EXAMPLE" {
            delegate?.receivedJsonValueFromWebView(value: message.body as! [String : Any?])
        } else if let body = message.body as? String {
            delegate?.receivedStringValueFromWebView(value: body)
        }
    }
}
