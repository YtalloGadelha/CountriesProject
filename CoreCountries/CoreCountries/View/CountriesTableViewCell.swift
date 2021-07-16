//
//  CountriesTableViewCell.swift
//  CoreCountries
//
//  Created by Ytallo on 11/07/21.
//

import Foundation
import UIKit
import WebKit

class CountriesTableViewCell: UITableViewCell{
    
    var viewModel: CountryTableViewCellViewModel?

    @available(iOS 13.0, *)
    lazy var loading: UIActivityIndicatorView = {
        
        let obj = UIActivityIndicatorView()
        obj.style = UIActivityIndicatorView.Style.large
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.startAnimating()
        
        return obj
    }()
    
    lazy var flag: WKWebView = {
        
        let config = WKWebViewConfiguration()
        
        let obj = WKWebView(frame: .zero, configuration: config)
        obj.translatesAutoresizingMaskIntoConstraints = false
        //obj.navigationDelegate = self
        
        return obj
    }()
    
    lazy var name: UILabel = {
        
        let obj = UILabel()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.numberOfLines = 3
        obj.adjustsFontSizeToFitWidth = true
        obj.minimumScaleFactor = 0.5
        obj.textAlignment = .left
        obj.textColor = .darkGray
        obj.font = .boldSystemFont(ofSize: 18)
        
        return obj
    }()
    
    lazy var language: UILabel = {
        
        let obj = UILabel()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.numberOfLines = 3
        obj.adjustsFontSizeToFitWidth = true
        obj.minimumScaleFactor = 0.5
        obj.textAlignment = .left
        obj.textColor = .darkGray
        obj.font = .boldSystemFont(ofSize: 18)
        
        return obj
    }()
    
    lazy var buttonFavorite: UIButton = { [weak self] in
        
        let constants = Constants()
        let obj = UIButton()
        obj.tintColor = constants.MAIN_COLOR
        obj.translatesAutoresizingMaskIntoConstraints = false
        
        if let me = self {
            obj.addTarget(me, action: #selector(favoriteAction), for: .touchUpInside)
        }
        
        return obj
    }()
    
    override func didMoveToSuperview() {
        self.setupCell()
    }
    
    @objc func favoriteAction(){
        
        self.viewModel?.toggleFavorite(completion: { [weak self] success in
            DispatchQueue.main.async {
                if success{                    
                    guard let viewModel = self?.viewModel else { return }
                    self?.setupCell(viewModel: viewModel)
                }
            }
        })
    }
    
    private func setupCell(){
        
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.flag)
        self.contentView.addSubview(self.name)
        self.contentView.addSubview(self.language)
        self.contentView.addSubview(self.buttonFavorite)
        if #available(iOS 13.0, *) {
            self.flag.addSubview(self.loading)
            self.loading.centerYAnchor.constraint(equalTo: self.flag.centerYAnchor).isActive = true
            self.loading.centerXAnchor.constraint(equalTo: self.flag.centerXAnchor).isActive = true
            self.loading.heightAnchor.constraint(equalToConstant: 40).isActive = true
            self.loading.widthAnchor.constraint(equalTo: self.loading.heightAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        self.flag.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        self.flag.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.flag.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.60).isActive = true
        self.flag.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.35).isActive = true
        
        self.name.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -20).isActive = true
        self.name.leadingAnchor.constraint(equalTo: self.flag.trailingAnchor, constant: 20).isActive = true
        self.name.trailingAnchor.constraint(equalTo: self.buttonFavorite.leadingAnchor, constant: -20).isActive = true
        
        self.language.topAnchor.constraint(equalTo: self.name.bottomAnchor, constant: 20).isActive = true
        self.language.leadingAnchor.constraint(equalTo: self.flag.trailingAnchor, constant: 20).isActive = true
        self.language.trailingAnchor.constraint(equalTo: self.buttonFavorite.leadingAnchor, constant: -20).isActive = true
        self.language.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //self.language.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15).isActive = true
        
        self.buttonFavorite.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.buttonFavorite.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        self.buttonFavorite.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.buttonFavorite.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.layoutIfNeeded()
        self.updateConstraints()
    }
    
    func setupCell(viewModel: CountryTableViewCellViewModel){
        
        DispatchQueue.main.async { [weak self] in
            if #available(iOS 13.0, *) {
                self?.loading.isHidden = false
            } else {
                // Fallback on earlier versions
            }
        }
    
        viewModel.downloaded(completion: { [weak self] image in
            DispatchQueue.main.async {
                
                self?.loadingFlag(url: image)
                
                if #available(iOS 13.0, *) {
                    self?.loading.isHidden = true
                } else {
                    // Fallback on earlier versions
                }
            }
        })
        self.name.text = "País: \(viewModel.name)"
        self.language.text = "Idioma: \(viewModel.language)"
        self.viewModel = viewModel
        
        if viewModel.isFavorite{
            self.buttonFavorite.setImage(UIImage(named: "ic_favoritado")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.buttonFavorite.tintColor = Constants().MAIN_COLOR
        }else{
            self.buttonFavorite.setImage(UIImage(named: "ic_favoritos")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.buttonFavorite.tintColor = Constants().MAIN_COLOR
        }
    }
    
    func loadingFlag(url: URL?){
        guard let url = url else { return }
        
        let request = URLRequest(url: url)
        
        self.flag.load(request)
    }
}

//extension CountriesTableViewCell: WKNavigationDelegate{
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.flag.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
//                if complete != nil {
//                    self.flag.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
//                        let heightWebView = height as! CGFloat
//                        //heightWebView is the height of the web view
//                    })
//                }
//            })
//        }
//    }
//}
