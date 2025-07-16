//
//  ReportWebViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/17/25.
//
import UIKit
import WebKit
import SnapKit

final class ReportWebViewController: UIViewController {
    
    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
        loadWebPage()
    }

    private func setupWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func loadWebPage() {
        let urlString = "https://hilingual.notion.site/230829677ebf801c965be24b0ef444e9"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
