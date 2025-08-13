//
//  Alamofire+Session.swift
//  ileDeBeaute-iOS
//
//  Created by Petrovich on 21.06.2024.
//

import Alamofire
import Foundation

extension Session {
    static var defaultWithoutCache: Session?
    
    static func setup(
        configuration: URLSessionConfiguration,
        sessionDelegate: SessionDelegate,
        rootQueue: DispatchQueue,
        urlSession: URLSession?
    ) {
        defaultWithoutCache = Session(configuration: configuration, startRequestsImmediately: true)
    }
}
