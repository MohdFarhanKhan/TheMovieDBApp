//
//  APIResults.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 06/05/1445 AH.
//

import Foundation

class APIResults:Decodable {
 let page: Int
 let totalResults: Int
 let totalPages: Int
 let results: [Movie]
    init(page: Int, totalResults: Int, totalPages: Int, results: [Movie]) {
        self.page = page
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.results = results
    }
    enum CodingKeys:String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages =  "total_pages"
        case results = "results"
    }
}
struct Regions:Codable {
 let iso_3166_1: String
 let english_name: String
 let native_name: String

}
