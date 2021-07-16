//
//  ViewController.swift
//  CoreCountries
//
//  Created by Ytallo on 09/07/21.
//

import UIKit
import API

class CountryViewController: DefaultViewController {
    
    private let countryViewModel: CountryViewModel
    
    lazy var searchShadow: UIView = {
        let obj = UIView()
        let const = Constants()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.clipsToBounds = true
        obj.layer.cornerRadius = 25
        obj.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return obj
    }()
    
    lazy var searchBar: UISearchBar = { [weak self] in
        
        guard let me = self else { return UISearchBar() }
        
        let obj = UISearchBar()
        let const = Constants()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.clipsToBounds = true
        obj.layer.cornerRadius = 25
        obj.placeholder = "Qual produto você procura?"
        obj.tintColor = UIColor.red
        obj.delegate = self
        obj.backgroundColor = .white
        
        obj.setPlaceholder(textColor: .gray)
        obj.setSearchImage(color: .orange)
        obj.set(textColor: .gray)
        obj.setClearButton(color: .red)
        obj.setTextField(color: UIColor.white)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.gray
        
        return obj
    }()
    
    var descSearch: String = ""{
        didSet {
            if descSearch.isEmpty{
                searchBar.resignFirstResponder()
            }
        }
    }
    
    lazy var tableView: UITableView = {
        
        let obj = UITableView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.separatorStyle = .singleLine
        obj.backgroundColor = .white
        
        return obj
    }()
    
    lazy var downView: UIView = {
        
        let constants = Constants()
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.backgroundColor = constants.MAIN_COLOR
        
        return obj
    }()
    
    init(countryViewModel: CountryViewModel = CountryViewModel()) {
        self.countryViewModel = countryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.countryViewModel = CountryViewModel()
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showActivity()
        self.view.backgroundColor = .white
        self.setupNavigation("Países")
        self.setupConstraints()
        self.countryViewModel.delegate = self
        self.updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func setupConstraints(){
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.downView)
        self.view.addSubview(self.searchShadow)
        self.view.addSubview(self.searchBar)
        
        self.searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.90).isActive = true
        self.searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.searchBar.bottomAnchor.constraint(equalTo: self.tableView.topAnchor, constant: 0).isActive = true
        
        self.searchShadow.topAnchor.constraint(equalTo: self.searchBar.topAnchor, constant: 3).isActive = true
        self.searchShadow.bottomAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 3).isActive = true
        self.searchShadow.leadingAnchor.constraint(equalTo: self.searchBar.leadingAnchor, constant: 2).isActive = true
        self.searchShadow.trailingAnchor.constraint(equalTo: self.searchBar.trailingAnchor, constant: 2).isActive = true
        
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.downView.topAnchor, constant: 0).isActive = true
        
        self.downView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.downView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.downView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CountriesTableViewCell.self, forCellReuseIdentifier: "countriesCell")
        
    }
    
    func updateData(){
        self.countryViewModel.fetchCountries()
    }
}

//MARK:-CountryViewModelDelegate
extension CountryViewController: CountryViewModelDelegate{
    
    func didFinishWithSuccess() {
        DispatchQueue.main.async {
            self.hideActivity()
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func didFinishWithError(message: String) {
        print("Erro: \(message)")
        DispatchQueue.main.async {
            self.showAlert(message: "Erro ao tentar acessar a lista de países.")
            self.hideActivity()
        }
    }
}

//MARK:- Extension TableView
extension CountryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryViewModel.tableViewCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "countriesCell") as? CountriesTableViewCell {
            
            if let countryTableViewCellViewModel = self.countryViewModel.getTableViewCellViewModel(from: indexPath){
                
                cell.setupCell(viewModel: countryTableViewCellViewModel)
            }
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        //ViewUtil.openMovieDetailsVC(from: self, movie: movies[indexPath.row])
    }
}


 //MARK: - Extension UISearchBarDelegate
 extension CountryViewController: UISearchBarDelegate {
     
     func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         descSearch = searchBar.text ?? ""
         searchBar.showsCancelButton = false
         //self.viewModel.fetch(descricaoProd: searchBar.text ?? "", offSet: self.groups.count)
     }
     
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         descSearch = searchText
     }
     
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         searchBar.endEditing(true)
     }
     
     func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         self.searchBar.showsCancelButton = true
     }
     
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         searchBar.text = ""
         descSearch = ""
         searchBar.showsCancelButton = false
         
         searchBar.resignFirstResponder()
     }
 }
