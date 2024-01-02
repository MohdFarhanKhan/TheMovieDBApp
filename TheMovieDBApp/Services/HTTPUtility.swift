//
//  HTTPUtility.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 06/05/1445 AH.
//

import Foundation


private let apiKey = "0335b83bfdcbae88ac19e9f738808017"
private let apiKey1 = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMzM1YjgzYmZkY2JhZTg4YWMxOWU5ZjczODgwODAxNyIsInN1YiI6IjVhOGRkNDRkYzNhMzY4MjY2NzAwM2Q5MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.kWSZs5e_AtKjeWdJj5hmkC8MQ2CjBqHiID0vsXXgkWc"
private let baseAPIURL = "https://api.themoviedb.org/3"

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    case emptyString
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        case .emptyString: return "Search string is empty"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}

final class HttpUtility {

    static let shared: HttpUtility = HttpUtility()
    private let urlSession = URLSession.shared
    var region = "SE"
  
    private init() {
       
    }
    func setRegion(){
        let defaults = UserDefaults.standard
        if let savedRgn = defaults.object(forKey: "SavedRegion") as? Data {
            let decoder = JSONDecoder()
            if let loadedRegion = try? decoder.decode(Regions.self, from: savedRgn) {
                region = loadedRegion.iso_3166_1
            }
        }
    }
    func getRegions( completion: @escaping ([Regions]?) -> ()) {
      
       
       
       //https://api.themoviedb.org/3/watch/providers/regions?api_key=0335b83bfdcbae88ac19e9f738808017
        guard let url = URL(string: "\(baseAPIURL)/watch/providers/regions?api_key=\(apiKey)") else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { (responseData, httpUrlResponse, error) in
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any] {
                           // try to read out a string array
                        if let results = json["results"] as? [[String: Any]], results.count > 0 {
                            var items = [Regions]()
                            for item in results{
                                items.append(Regions(iso_3166_1: item["iso_3166_1"] as! String, english_name: item["english_name"] as! String, native_name: item["native_name"] as! String))
                            }
                            completion(items)
                           }
                       }
                    else{
                        completion(nil)
                    }
                    
                }
                catch let error{
                    debugPrint("error occured while decoding = \(error)")
                    completion(nil)
                }
            }

        }.resume()
       
    }
    func PopulardMovie( completion: @escaping (Result<APIResults, MovieError>) -> ()) {
        setRegion()
        guard let url = URL(string: "\(baseAPIURL)/movie/popular") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "true",
            "append_to_response": "videos",
            "region": region,
            
        ], completion: completion)
    }
    func TopRatedMovies( completion: @escaping (Result<APIResults, MovieError>) -> ()) {
        setRegion()
        guard let url = URL(string: "\(baseAPIURL)/movie/top_rated") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "true",
            "append_to_response": "videos",
            "region": region,
            
        ], completion: completion)
    }
    func UpcomingMovie( completion: @escaping (Result<APIResults, MovieError>) -> ()) {
        setRegion()
        guard let url = URL(string: "\(baseAPIURL)/movie/upcoming") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "true",
            "append_to_response": "videos",
            "region": region,
            
        ], completion: completion)
    }
    func nowPlayingMovie( completion: @escaping (Result<APIResults, MovieError>) -> ()) {
        setRegion()
        guard let url = URL(string: "\(baseAPIURL)/movie/now_playing") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "true",
            "append_to_response": "videos",
            "region": region,
            
        ], completion: completion)
    }
    func searchMovie(query: String, completion: @escaping (Result<APIResults, MovieError>) -> ()) {
        setRegion()
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "true",
            "append_to_response": "videos",
            "region": region,
            "query": query
        ], completion: completion)
    }
    func recentMovies( completion: @escaping (Result<APIResults, MovieError>) -> ()) {
        setRegion()
        guard let url = URL(string: "\(baseAPIURL)/trending/movie/day") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "true",
            "append_to_response": "videos",
            "region": region
        ], completion: completion)
    }
    func giveARandomNumber(number:Int64)->Int64{
      
        return Int64.random(in: 0...number)
    }
    func RandomMovie( completion: @escaping (Result<APIResults, MovieError>) -> ()) {
        setRegion()
        latestMovieId() { [self] (result) in
            switch result{
            case -1:
                completion(.failure(.invalidEndpoint))
            case -2:
                completion(.failure(.serializationError))
            case 0:
                completion(.failure(.noData))
            default:
              
                    ///movie/movie_id
                    let latestMovieId = giveARandomNumber(number: result)
                getMovie(byID: latestMovieId) { result1 in
                    switch result1{
                    case .success(let response):
                       
                        completion(.success(response))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
       
       
       
    }
    func getMovie(byID:Int64, completion: @escaping (Result<APIResults, MovieError>) -> ()) {
        setRegion()
        guard let url = URL(string: "\(baseAPIURL)/movie/\(byID)?api_key=\(apiKey)&language=\(region)&include_adult=true& append_to_response=videos&region=US") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        URLSession.shared.dataTask(with: url) { (responseData, httpUrlResponse, error) in
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any] , json.contains { $0.key == "success" } == false{
                        
                        var genres = [Int]()
                        let genreArray = json["genres"] as! [[String:Any]]
                        for dict in genreArray {
                            genres.append((dict["id"] as? Int)!)
                        }
                        let movie = Movie(id: (json["id"] as! Int), isAdult: json["adult"] as! Bool , posterPath: json["poster_path"] as? String, title: json["title"] as! String, releaseDate:   json["release_date"] as? String, voteAverage:  json["vote_average"] as! Double, overview:  json["overview"] as! String, voteCount:  (json["vote_count"] as! Int), backdropPath: json["backdrop_path"] as? String, genreIDS: genres, originalLanguage:   json["original_language"] as! String, originalTitle:  json["original_title"] as! String, popularity:  json["popularity"] as! Double, isVideo: json["video"] as! Bool)
                        
                        let apiResult = APIResults(page: 1, totalResults: 1, totalPages: 1, results: [movie])
                        completion(.success(apiResult))
                       }
                    else{
                        completion(.failure(.noData))
                    }
                   
                }
                catch let error{
                    debugPrint("error occured while decoding = \(error)")
                    completion(.failure(.serializationError))
                }
            }
            else{
                completion(.failure(.apiError))
            }

        }.resume()
       
    }
    func latestMovieId( completion: @escaping (Int64) -> ()) {
        setRegion()
        guard let url = URL(string: "\(baseAPIURL)/movie/latest?api_key=\(apiKey)&language=en-US&include_adult=true&region=\(region)") else {
            completion(-1)
            return
        }
        URLSession.shared.dataTask(with: url) { (responseData, httpUrlResponse, error) in
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any] {
                           // try to read out a string array
                           if let idInt = json["id"] as? Int64 {
                               print(idInt)
                               _=completion(idInt)
                           }
                       }
                    else{
                        completion(0)
                    }
                    
                }
                catch let error{
                    debugPrint("error occured while decoding = \(error)")
                    completion(-2)
                }
            }

        }.resume()
       
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
              
                let decodedResponse =  try JSONDecoder().decode(D.self, from: data)
               
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    func fetchMovieVideos(id: Int, completion: @escaping ([String]) -> ()) {
        var youtubeKeyArrayDict : [String] = [String]()
       
        let headers = [
           "accept": "application/json"
         ]

         let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&append_to_response=videos")! as URL,
                                                 cachePolicy: .useProtocolCachePolicy,
                                             timeoutInterval: 10.0)
         request.httpMethod = "GET"
         request.allHTTPHeaderFields = headers
    

         let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
           if (error != nil) {
             print(error as Any)
           } else {
             let httpResponse = response as? HTTPURLResponse
            
               do{
                   let json = try JSONSerialization.jsonObject(with: data!, options: [])
                   if let object = json as? [String: Any] {
                       
                      //videos
                       if let videoDict = object["videos"]  as? [String: Any]{
                           var tralerArray = [String]()
                       for dict in videoDict["results"] as! [[String: Any]]{
                           if let site = dict["site"] as? String , site == "YouTube"{
                               tralerArray.append(dict["key"] as! String)
                              
                           }
                          
                       }
                           youtubeKeyArrayDict.append(contentsOf: tralerArray)
                          
                           }
                     
                   } else if let object = json as? [Any] {
                       // json is an array
                       
                   } else {
                       print("JSON is invalid")
                   }
                   completion(youtubeKeyArrayDict)
               }
               catch{
                   print(error.localizedDescription)
                   completion(youtubeKeyArrayDict)
               }
           }
         })

         dataTask.resume()
}
}
