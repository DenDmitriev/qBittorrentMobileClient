//
//  ErrorModel.swift
//  barcelona-ios
//
//  Created by Victor Kostin on 13.01.2025.
//

import Foundation

struct ErrorModel: Decodable {
    let errors: ErrorDescriptionModel
}

extension ErrorModel {
    struct ErrorDescriptionModel: Decodable {
        let title: String
        let status: Int
        let detail: String
        let source: ErrorSourceModel?
        let modelName: String?
    }
    
    struct ErrorSourceModel: Decodable {
        let pointer: String
    }
}
