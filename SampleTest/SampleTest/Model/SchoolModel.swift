//
//  SchoolModel.swift
//  SampleTest
//
//  Created by DEEPTHI on 30/01/24.
//

import Foundation

// MARK: - WelcomeElement
struct SchoolModel: Codable, Identifiable {
    let id = UUID()
    let dbn, schoolName, boro: String
    let paragraph: String
    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case boro
        case paragraph = "overview_paragraph"
    }
}

typealias SchoolNames = [SchoolModel]
