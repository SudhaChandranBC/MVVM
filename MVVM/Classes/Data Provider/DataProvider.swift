//
//  DataProvider.swift
//  MVVM
//
//  Created by Chandran, Sudha | SDTD on 27/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Foundation

open class DataProvider {
    public var timeoutInterval: Int = 30
    public let apiClient: APIClient
    
    public init(client: APIClient) {
        apiClient = client
    }
}
