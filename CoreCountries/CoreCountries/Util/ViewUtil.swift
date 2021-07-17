//
//  ViewUtil.swift
//  CoreCountries
//
//  Created by Ytallo on 11/07/21.
//

import Foundation
import UIKit

class ViewUtil {
    
    class func prepareWindow(window: UIWindow?){
       
        let viewModel = CountryViewModel(business: CountryBusinessAPI())
        let viewController = CountryViewController(countryViewModel: viewModel)
        
        let navigationVC = MainNavigationController(rootViewController: viewController)
        
        viewController.view.backgroundColor = .white
        
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }
}
