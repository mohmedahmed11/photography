
import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


/*
 func uploadFile()
 use to uploade file
 with parameters:
 - endurl: where data will be send
 - fileData: specific data representation of file to be send
 - withName: file name
 - parameters: othr parameters need to send with
 
 + onCompletion: when upload is success
 + onError: when upload is failure
 */

func uploadFile(endUrl: String, fileData: Data?,withName: String, parameters: [String : Any], onCompletion: ((Any?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
    
    let headers: HTTPHeaders = [
        "Content-type": "multipart/form-data"
    ]
    
    Alamofire.upload(multipartFormData: { (multipartFormData) in
        for (key, value) in parameters {
            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
        }
        if let data = fileData{
            multipartFormData.append(data, withName: withName,fileName: "image.png", mimeType: "image/png")
        }
        
    }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: endUrl, method: .post, headers: headers) { (result) in
        switch result{
        case .success(let upload, _, _):
            upload.responseJSON { response in
                if let err = response.error{
                    onError?(err)
                    return
                }
                onCompletion?(response.value)
            }
        case .failure(let error):
            print("Error in upload: \(error.localizedDescription)")
            onError?(error)
        }
    }
}

/*
 func getAll()
 use to get all data from server
 with parameters:
 - endurl: where data will be send
 
 + onCompletion: when get is success
 + onError: when get is failure
 */
func getAll(endUrl: String, onCompletion: ((Any?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
    
    Alamofire.request(endUrl, method: .get).responseJSON { response in
        switch response.result {
        case .success(let result):
            onCompletion?(result)
        case .failure(let err):
            print("\(err.localizedDescription)")
            onError?(err)
        }
    }
}

/*
 func dwonloadImage()
 use to dwonload images
 with parameters:
 - endurl: where data will be send
 
 + onCompletion: when dwonload is success
 + onError: when dwonload is failure
 */

func dwonloadImage(endUrl: String, onCompletion: ((Any?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
    let utilityQueue = DispatchQueue.global(qos: .utility)
    
    Alamofire.request(endUrl)
        .responseImage { response in
        switch response.result {
        case .success:
            if let image = response.result.value {
                onCompletion?(image)
            }
        case .failure(let err):
            print("\(err.localizedDescription)")
            onError?(err)
        }
    }
}

