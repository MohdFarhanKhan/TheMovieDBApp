//
//  HTTPUtility.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 02/12/1444 AH.
//

import Foundation
let apiKey = "API Key"
final class HttpUtility {

    static let shared: HttpUtility = HttpUtility()
    private init() {}
    var totalPage = 0
    var currentPage = 1
    var movieArray : [[String: String]] = [[String: String]]()
    var errorString = ""
    func callMovieUrl(completion: @escaping () -> Void){
        if totalPage == currentPage{
            completion()
            return
        }
       let headers = [
          "accept": "application/json",
          "Authorization": "Bearer \(apiKey)"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=\(currentPage)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
           
              do{
                  let json = try JSONSerialization.jsonObject(with: data!, options: [])
                  if let object = json as? [String: Any] {
                      
                      // json is a dictionary
                      
                      self.totalPage = object["total_pages"] as! Int
                      for dict in object["results"] as! [[String: Any]]{
                          var dictElement : [String: String] = [String: String]()
                         
                          dictElement["overview"] =  dict["overview"] as? String
                          dictElement["backdrop_path"] =  dict["backdrop_path"] as? String
                          dictElement["original_language"] =  dict["original_language"] as? String
                          dictElement["original_title"] =  dict["original_title"] as? String
                          dictElement["popularity"] =  dict["popularity"] as? String
                          dictElement["poster_path"] =  dict["poster_path"] as? String
                          dictElement["release_date"] =  dict["release_date"] as? String
                          dictElement["title"] =  dict["title"] as? String
                          dictElement["vote_average"] =  dict["vote_average"] as? String
                          dictElement["vote_count"] = "\(dict["vote_count"] as? Int)"
                          self.movieArray.append(dictElement)
                      }
                     
                      self.currentPage += 1
                  } else if let object = json as? [Any] {
                      // json is an array
                      
                  } else {
                      print("JSON is invalid")
                  }
                  completion()
              }
              catch{
                  print(error.localizedDescription)
                  completion()
              }
          }
        })

        dataTask.resume()
    }
}
