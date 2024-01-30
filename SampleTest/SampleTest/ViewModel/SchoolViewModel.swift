//
//  SchoolViewModel.swift
//  SampleTest
//
//  Created by DEEPTHI on 30/01/24.
//

import Foundation
import Combine

@MainActor class SchoolViewModel: ObservableObject {
    @Published var schoolNames = [SchoolModel]()
    let serviceManager: WebServiceProtocol

    init(serviceManager: WebServiceProtocol) {
        self.serviceManager = serviceManager
    }
    func fetchDataFromApi() async {
        let urlString = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
        guard let downloadedPosts: [SchoolModel] = await WebService().downloadData(fromURL: urlString) else {return}
        schoolNames = downloadedPosts
    }
    
}

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

protocol WebServiceProtocol {
    func downloadData<T: Codable>(fromURL: String) async -> T?
}
class WebService: WebServiceProtocol {
    func downloadData<T: Codable>(fromURL: String) async -> T? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
            
            return decodedResponse
        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
        } catch {
            print("An error occured downloading the data")
        }
        
        return nil
    }
}

class MockWebService: WebServiceProtocol{
    
    func downloadData<T: Codable>(fromURL: String) async -> T? {
        return [["dbn": "02M260",
                "school_name": "Clinton School Writers & Artists, M.S. 260",
                "boro": "M",
                 "overview_paragraph": "Students who are prepared for college must have an education that encourages them to take risks as they produce and perform. Our college preparatory curriculum develops writers and has built a tight-knit community. Our school develops students who can think analytically and write creatively. Our arts programming builds on our 25 years of experience in visual, performing arts and music on a middle school level. We partner with New Audience and the Whitney Museum as cultural partners. We are a International Baccalaureate (IB) candidate school that offers opportunities to take college courses at neighboring universities."]] as? T
    }
    
    
}
