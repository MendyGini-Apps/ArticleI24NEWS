//
//  BringJSONDataNetworkOperation.swift
//  ArticleI24NEWS
//
//  Created by Menahem Barouk on 01/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

import Foundation
import ProcedureKit
import ProcedureKitNetwork

class BringJSONDataNetworkOperation<Output: Decodable>: GroupProcedure, OutputProcedure
{
    var output: Pending<ProcedureResult<Output>> = .pending
    
    init(urlRequest: URLRequest, outputType: Output.Type, session: URLSession = URLSession.shared)
    {
        let networkProcedure = NetworkProcedure { NetworkDataProcedure(session: session, request: urlRequest) }
        
        let transformProcedure = TransformProcedure<HTTPPayloadResponse<Data>, Output> { (httpPayloadResponse) -> Output in
            
            guard let payload = httpPayloadResponse.payload else { throw ProcedureKitError.unknown }
            
            let parsedData = try JSONDecoder().decode(outputType.self, from: payload)
            
            return parsedData
        }
        
        transformProcedure.injectResult(from: networkProcedure)
        
        super.init(operations: [networkProcedure, transformProcedure])
        
        bind(from: transformProcedure)
    }
}
