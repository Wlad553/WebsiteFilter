//
//  ViewController.swift
//  WebsiteFilter
//
//  Created by Vladyslav Petrenko on 05/06/2023.
//

import UIKit
import SnapKit
import WebKit

class ViewController: UIViewController {
    let bottomView = BottomView()
    let inputTextField = UITextField()
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .navigationBarColor
        navigationController?.navigationBar.backgroundColor = .navigationBarColor
        bottomView.layout(in: self.view)
        setUpInputTextField()
        setUpWebView()
    }
    
    private func setUpInputTextField() {
        navigationItem.titleView = inputTextField
        
        inputTextField.textColor = UIColor.black
        inputTextField.backgroundColor = UIColor.textFieldBackground
        inputTextField.placeholder = "Search or enter website"
        
        let magnifyingGlassImageView = UIImageView(image: UIImage(named: "magnifyingglass"))
        magnifyingGlassImageView.contentMode = .scaleAspectFit
        magnifyingGlassImageView.tintColor = .darkGray
        magnifyingGlassImageView.frame = CGRect(x: 8, y: -8, width: 16, height: 16)
        
        inputTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: inputTextField.frame.size.height))
        inputTextField.leftView?.addSubview(magnifyingGlassImageView)
        inputTextField.leftViewMode = .always
        inputTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: inputTextField.frame.size.height))
        inputTextField.rightViewMode = .unlessEditing
        inputTextField.layer.cornerRadius = 10
        inputTextField.borderStyle = .none
        inputTextField.autocorrectionType = .no
        inputTextField.autocapitalizationType = .none
        inputTextField.clearButtonMode = .whileEditing
        
        inputTextField.delegate = self
        
        inputTextField.snp.makeConstraints({ make in
            make.width.equalTo(view.frame.width - 32)
            make.height.equalTo(40)
        })
    }
    
    private func setUpWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview { constraintView in
                constraintView.safeAreaLayoutGuide
            }
            make.bottom.equalTo(bottomView.snp_firstBaseline)
        }
        guard let url = URL(string: "https://www.google.com") else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textFieldText = textField.text,
              let url = URL(string: textFieldText)
        else { return false }
        let request = URLRequest(url: url)
        textField.resignFirstResponder()
        webView.load(request)
        return true
    }
}

