//
//  StoresService.swift
//  Starbucks
//
//  Created by User on 4/27/19.
//  Copyright © 2019 Enea Dume. All rights reserved.
//

import UIKit

class StoresService {
    
    /**
     make request to get all stores
     - parameters:
        - url: URL, url of api
        - completion: ((Results?, Error?) -> Void)) , return the result taken from api
     
 */
    public static func getLocalStores(_ url: URL, completion: @escaping ((Results?, Error?) -> Void)) {
        
        //create the requst, set url, cachePolicy and the timeout
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        //start request
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            //check for errors,eg. No internet conection, etc
            if error != nil {
                //this must be only in main thread
                DispatchQueue.main.async {
                    //there is a error, return only the error, no reults
                    completion(nil, error)
                }
                
            }else {
                do{
                    //decode the response data to Results type
                    let decoder = JSONDecoder()
                    let results  = try decoder.decode(Results.self, from: data!)
                    //this must be only in main thread
                    DispatchQueue.main.async {
                        //there is no error, return only the results
                        completion(results, nil)
                    }
                }catch{
                    //this must be only in main thread
                    DispatchQueue.main.async {
                         //there is a error, return only the error, no reults
                        completion(nil, error)
                    }
                }
            }
            
        })
        
        dataTask.resume()
    }
    
    /**
     search a store according to it's address.
     - parameters:
        - stores : [Store] the list of all available stores
        - searchText: String, the text that will bi taken from SearchController
    - returns: [Store], the list of stores matching with the given search text
     */
    static func getFilteredStores(stores: [Store], searchText: String) -> [Store]{
       let  searchedResults = stores.filter({
            (store) in
            return store.address.lowercased().contains(searchText)
        })
        
        return searchedResults
    }
}


