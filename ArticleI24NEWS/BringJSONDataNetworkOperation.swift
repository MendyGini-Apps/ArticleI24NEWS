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

class BringJSONDataLocaleFileOperation<Output: Decodable>: GroupProcedure, OutputProcedure
{
    var output: Pending<ProcedureResult<Output>> = .pending

    init(url: URL, outputType: Output.Type)
    {
        let localeDataProcedure = LocaleDataProcedure(url: url)
        
        let transformProcedure = TransformProcedure<Data, Output> { (data) -> Output in
            
            let parsedData = try JSONDecoder().decode(outputType.self, from: data)
            
            return parsedData
        }
        
        transformProcedure.injectResult(from: localeDataProcedure)
        
        super.init(operations: [localeDataProcedure, transformProcedure])
        
        bind(from: transformProcedure)
    }
}

class LocaleDataProcedure: Procedure, InputProcedure, OutputProcedure
{
    public typealias LocaleResult = ProcedureResult<Data>
    public typealias CompletionBlock = (LocaleResult) -> Void

    public var input: Pending<URL> {
        get { return stateLock.withCriticalScope { _input } }
        set {
            stateLock.withCriticalScope {
                _input = newValue
            }
        }
    }

    public var output: Pending<LocaleResult> {
        get { return stateLock.withCriticalScope { _output } }
        set {
            stateLock.withCriticalScope {
                _output = newValue
            }
        }
    }

    public let completion: CompletionBlock

    private let stateLock = NSLock()
    internal private(set) var task: NetworkDataTask? // internal for testing
    private var _input: Pending<URL> = .pending
    private var _output: Pending<LocaleResult> = .pending

    public init(url: URL? = nil, completionHandler: @escaping CompletionBlock = { _ in })
    {
        self.completion = completionHandler
        super.init()
        self.input = url.flatMap { .ready($0) } ?? .pending

        addDidCancelBlockObserver { procedure, _ in
            procedure.task?.cancel()
        }
    }
    
    override func execute()
    {
        guard let url = input.value else {
            finish(withResult: .failure(ProcedureKitError.requirementNotSatisfied()))
            return
        }
        guard !isCancelled else {
            finish()
            return
        }
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            
            completion(.success(data))
            finish(withResult: .success(data))
        }
        catch let error {
            finish(withResult: .failure(error))
        }
    }
}
