//
//  API.swift
//  Swift News
//
//  Created by Harsh Shah on 2020-06-16.
//  Copyright © 2020 Pineapple Inc. All rights reserved.
//

import UIKit
import Alamofire
import Reachability
class API {

    static public func callAPI(ApiMethod : HTTPMethod ,forURL:String,parameters:[String:Any]?,completion: @escaping (_ success : Bool,_ responseData : Any?,_ error : String?)->Void){
        print(forURL)
        if !(rechabilityManager?.rechabilityStatus ?? true)  {
                let alertController = UIAlertController(title: "No internet connection", message: "Please connect to the network", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Retry", style: .default) { (action) in
                
                //On retry call API again
                
                    self.callAPI(ApiMethod: ApiMethod, forURL: forURL, parameters: parameters) { (success, data, error) in
                    completion(success, data, error)
                }
            }
            alertController.addAction(alertAction)
            if let vc = UIApplication.getTopViewController(){
                
                if vc.navigationController == nil{
                    completion(false,nil,"No internet connection")
                    return
                }
                vc.navigationController?.present(alertController, animated: true, completion: nil)
            }else{
                 completion(false,nil,"No internet connection")
            }
            return
        }
        
      
        if let vc = UIApplication.getTopViewController(){
            FadeInOutLoadingAnimation.createContent(superview: vc.view)
        }
     
        var headers: HTTPHeaders = [:]
            
        
        
        AF.request(forURL, method: ApiMethod,parameters: parameters, headers: headers).response { response in
            
            switch response.result {
                
            case let .success(data):
                let jsonDecoder = JSONDecoder()
                if let data = data
                {
                
                    
                    if let utf8Text = String(data: data, encoding: .utf8) {
                        
                        do {
                            let reponseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        
                            let error : String = reponseDict?["error"] as? String ?? "Something went wrong."
                            //pass complition
                        FadeInOutLoadingAnimation.removeContent()
                            completion(true,data, error=="" ? nil : error)
                            
                        }
                        
                        #if DEBUG
                        print("Data: \(utf8Text)")
                        #endif
                    }else{
                        FadeInOutLoadingAnimation.removeContent()
                        completion(false,nil,"something went wrong")
                    }
                    
                    
                }
                else {
                    print("Error")
                    FadeInOutLoadingAnimation.removeContent()
                    completion(false,nil,"something went wrong")
                }
            case let .failure(error):
                print(error)
                FadeInOutLoadingAnimation.removeContent()
                completion(false,nil,"something went wrong")
            }
        }
    }
    
    static func convertStringArrayToJsonParameter(_ StringArray:[String]?) -> String
    {
        if StringArray?.count == 0 {
            return "[]"
        }
        
        var str = "["
        for i  in StringArray ?? []
        {
            str.append("\"\(i)\",")
        }
        str.removeLast()
        str.append("]")
        return  str
    }
    
    static func convertDictionaryArrayToJsonParameter(arrayDict : [[String:Any]]?)->String{
        if arrayDict?.count == 0{
            return "[]"
        }
        var str = "["
        for dict in arrayDict ?? [[String:Any]](){
            str.append("{")
            for (key,value) in dict{
                let valueString = "\(value)".first == "[" ? "\(value)" : "\"\(value)\""
                str.append("\"\(key)\":\(valueString),")
            }
            str.removeLast()
            str.append("},")
        }
        str.removeLast()
        str.append("]")
        return str
    }
    
    static func convertArrayToParameters(with keynamePrefix: String,valuesArray : [String])->[String:Any]?{
        
        if valuesArray.count == 0{
            return nil
        }
        var dict : [String:Any] = [:]
        for (index,value) in valuesArray.enumerated(){
            dict["\(keynamePrefix)\(index)"] = value
        }
        return dict
    }
    
    
    
    

}
