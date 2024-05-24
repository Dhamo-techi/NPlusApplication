//
//  ViewModel.swift
//  NPlusApplication
//
//  Created by MAC PRO on 15/05/24.
//

import Foundation

class ViewModel : NSObject{
    override init() {
        super.init()
    }
    func getdata(geturl: String, result: @escaping(Result<Model?,Error>)-> Void) {
        if let url = URL(string: geturl){
            networkManager.shared.fetchData(from: url, compilition: result)
        }
    }
}
