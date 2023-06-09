//
//  ViewController.swift
//  WebsiteFilter
//
//  Created by Vladyslav Petrenko on 05/06/2023.
//

import UIKit
import SnapKit
import WebKit

final class MainViewController: UIViewController {
    weak var delegate: ViewControllerDelegate?
    let userDefaultsManager: UserDefaultsStorage = UserDefaultsManager()
    
    let bottomView = BottomView()
    let linkTextField = UITextField()
    let webView = WKWebView()
    let errorLabel = UILabel()
    let errorSublabel = UILabel()
    let progressView = UIProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .navigationBarBackground
        navigationController?.navigationBar.backgroundColor = .navigationBarBackground
        bottomView.layout(in: view)
        setUpLinkTextField()
        setUpErrorStackView()
        setUpWebView()
        addButtonsTarget()
        setUpProgressView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc func didTapBackButton() {
        webView.goBack()
    }
    
    @objc func didTapForwardkButton() {
        webView.goForward()
    }
    
    @objc func didTapAddFilterButton() {
        let alertController = UIAlertController(title: "Add Filter", message: "Type a filter word to be blocked", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .destructive) { action in
            guard let textFieldText = alertController.textFields?.first?.text else { return }
            self.userDefaultsManager.insert(filter: textFieldText)
        }
        addAction.isEnabled = false
        
        alertController.addTextField { textField in
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.placeholder = "Type a filter word"
            textField.delegate = self
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    
    @objc func didTapShowFiltersButton() {
        delegate?.navigateToFilterListTableViewController()
    }
    
    func updateWebViewNavigationButtonsState() {
        if webView.canGoBack {
            bottomView.backButton.isEnabled = true
        } else {
            bottomView.backButton.isEnabled = false
        }
        
        if webView.canGoForward {
            bottomView.forwardButton.isEnabled = true
        } else {
            bottomView.forwardButton.isEnabled = false
        }
    }
    
    func presentOKAlertController(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func setUpLinkTextField() {
        navigationItem.titleView = linkTextField
        
        linkTextField.textColor = UIColor.black
        linkTextField.backgroundColor = UIColor.textFieldBackground
        linkTextField.placeholder = "Search or enter website"
        
        let magnifyingGlassImageView = UIImageView(image: UIImage(named: "magnifyingglass"))
        magnifyingGlassImageView.contentMode = .scaleAspectFit
        magnifyingGlassImageView.tintColor = .darkGray
        magnifyingGlassImageView.frame = CGRect(x: 8, y: -8, width: 16, height: 16)
        
        linkTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: linkTextField.frame.size.height))
        linkTextField.leftView?.addSubview(magnifyingGlassImageView)
        linkTextField.leftViewMode = .always
        linkTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: linkTextField.frame.size.height))
        linkTextField.rightViewMode = .unlessEditing
        linkTextField.layer.cornerRadius = 10
        linkTextField.borderStyle = .none
        linkTextField.autocorrectionType = .no
        linkTextField.autocapitalizationType = .none
        linkTextField.clearButtonMode = .whileEditing
        
        linkTextField.delegate = self
        
        linkTextField.snp.makeConstraints({ make in
            make.width.equalTo(view.frame.width - 32)
            make.height.equalTo(40)
        })
    }
    
    private func setUpWebView() {
        webView.navigationDelegate = self
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview { constraintView in
                constraintView.safeAreaLayoutGuide
            }
            make.bottom.equalTo(bottomView.snp_firstBaseline)
        }
        
        guard let url = URL(string: "https://www.google.com/") else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    private func setUpErrorStackView() {
        guard let safeAreaBottomInset = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom else { return }
        let stackView = UIStackView(arrangedSubviews: [errorLabel,
                                                       errorSublabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        errorLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        [errorLabel, errorSublabel].forEach { label in
            label.numberOfLines = 0
            label.textColor = .errorLabel
            label.textAlignment = .center
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(safeAreaBottomInset - bottomView.frame.height)
            
        }
    }
    
    private func addButtonsTarget() {
        bottomView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        bottomView.forwardButton.addTarget(self, action: #selector(didTapForwardkButton), for: .touchUpInside)
        bottomView.addFilterButton.addTarget(self, action: #selector(didTapAddFilterButton), for: .touchUpInside)
        bottomView.showFiltersButton.addTarget(self, action: #selector(didTapShowFiltersButton), for: .touchUpInside)
    }
    
    private func setUpProgressView() {
        linkTextField.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(linkTextField.snp_bottomMargin).offset(5)
            make.leading.equalTo(linkTextField.snp_leadingMargin).offset(-2.5)
            make.trailing.equalTo(linkTextField.snp_trailingMargin).offset(2.5)
            make.height.equalTo(2)
        }
    }
    
    private func showProgressView() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
            self.progressView.alpha = 1
        }
    }
    
    private func hideProgressView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.progressView.alpha = 0
        }
    }
}

// MARK: UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        enum RestrictedCharacters: String {
            case whitespace = " "
        }
        
        guard let newTextFieldText = (textField.text as? NSString)?.replacingCharacters(in: range, with: string),
              let alertAddAction = (presentedViewController as? UIAlertController)?.actions.first(where: { action in
                  action.title == "Add"
              })
        else { return true }
        
        if newTextFieldText.contains(RestrictedCharacters.whitespace.rawValue) || newTextFieldText.count < 2 || userDefaultsManager.filtersArray.contains(newTextFieldText) {
            alertAddAction.isEnabled = false
        } else {
            alertAddAction.isEnabled = true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textFieldText = textField.text,
              !textFieldText.isEmpty
        else { return true }
        let urlString: String
        
        if textFieldText.contains("://") {
            // if user pasted a link cantaining http or https
            urlString = textFieldText
        } else if textFieldText.contains(".") {
            // if user types a website link without protocol
            urlString = "https://\(textFieldText)"
        } else {
            // if user wants to search
            urlString = "https://www.google.com/search?q=\(textFieldText.replacingOccurrences(of: " ", with: "+"))"
        }
        
        guard let url = URL(string: urlString) else { return true }
        let urlRequest = URLRequest(url: url)
        
        textField.resignFirstResponder()
        webView.load(urlRequest)
        return true
    }
}

// MARK: WKNavigationDelegate
extension MainViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let urlString = navigationAction.request.url?.absoluteString else {
            decisionHandler(.cancel)
            hideProgressView()
            return
        }
        for filterString in userDefaultsManager.filtersArray {
            if urlString.lowercased().contains(filterString.lowercased()) {
                presentOKAlertController(withTitle: "This page is blocked", message: "Current URL didn't pass filters list requirements")
                decisionHandler(.cancel)
                hideProgressView()
                return
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        linkTextField.text = webView.url?.absoluteString
        showProgressView()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        updateWebViewNavigationButtonsState()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        hideProgressView()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webView.isHidden = true
        updateWebViewNavigationButtonsState()
        hideProgressView()
        guard let failingURLString = (error as NSError).userInfo["NSErrorFailingURLStringKey"] as? String else { return }
        let hostname: String
        
        if #available(iOS 16.0, *) {
            if let urlHost = URL(string: failingURLString)?.host() {
                hostname = urlHost
            } else {
                hostname = ""
            }
        } else {
            let separatedStringsArray = failingURLString.components(separatedBy: "//")
            let protocolSeparatedURLString = separatedStringsArray.count >= 2 ? separatedStringsArray[1] : separatedStringsArray[0]
            hostname = protocolSeparatedURLString.components(separatedBy: "/")[0]
        }
        
        if (error as NSError).code == -1003 {
            errorLabel.text = "Can't Find The Server"
            errorSublabel.text = #"A server with "\#(hostname)" hostname could not be found."#
        } else {
            errorLabel.text = "Something went wrong"
            errorSublabel.text = "Unable to open the page"
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressView()
        updateWebViewNavigationButtonsState()
    }
}
