//
//  Web3+Instance.swift
//  web3swift
//
//  Created by Alexander Vlasov on 19.12.2017.
//  Copyright © 2017 Bankex Foundation. All rights reserved.
//

import BigInt
import Foundation
import PromiseKit

/// A web3 instance bound to provider. All further functionality is provided under web.*. namespaces.
public class Web3: Web3OptionsInheritable {
    public var provider: Web3Provider
    public var options: Web3Options = .default
    public var defaultBlock = "latest"
    public var requestDispatcher: JSONRPCrequestDispatcher

    /// Add a provider request to the dispatch queue.
    public func dispatch(_ request: JSONRPCrequest) -> Promise<JSONRPCresponse> {
        return requestDispatcher.addToQueue(request: request)
    }

    /// Raw initializer using a Web3Provider protocol object, dispatch queue and request dispatcher.
    public init(provider prov: Web3Provider, queue _: OperationQueue? = nil, requestDispatcher: JSONRPCrequestDispatcher? = nil) {
        provider = prov
        if requestDispatcher == nil {
            self.requestDispatcher = JSONRPCrequestDispatcher(provider: provider, queue: DispatchQueue.global(qos: .userInteractive), policy: .Batch(32))
        } else {
            self.requestDispatcher = requestDispatcher!
        }
    }

    /// Keystore manager can be bound to Web3 instance. If some manager is bound all further account related functions, such
    /// as account listing, transaction signing, etc. are done locally using private keys and accounts found in a manager.
    public func addKeystoreManager(_ manager: KeystoreManager?) {
        provider.attachedKeystoreManager = manager
    }

    /// Public web3.eth.* namespace.
    public lazy var eth = Web3.Eth(provider: self.provider, web3: self)

    public class Eth: Web3OptionsInheritable {
        var provider: Web3Provider
//        weak var web3: web3?
        var web3: Web3
        public var options: Web3Options {
            return web3.options
        }

        public init(provider prov: Web3Provider, web3 web3instance: Web3) {
            provider = prov
            web3 = web3instance
        }
    }

    /// Public web3.personal.* namespace.
    public lazy var personal = Web3.Personal(provider: self.provider, web3: self)

    public class Personal: Web3OptionsInheritable {
        var provider: Web3Provider
        //        weak var web3: web3?
        var web3: Web3
        public var options: Web3Options {
            return web3.options
        }

        public init(provider prov: Web3Provider, web3 web3instance: Web3) {
            provider = prov
            web3 = web3instance
        }
    }

    /// Public web3.wallet.* namespace.
    public lazy var wallet = Web3.Web3Wallet(provider: self.provider, web3: self)

    public class Web3Wallet {
        var provider: Web3Provider
//        weak var web3: web3?
        var web3: Web3
        public init(provider prov: Web3Provider, web3 web3instance: Web3) {
            provider = prov
            web3 = web3instance
        }
    }

    /// Public web3.browserFunctions.* namespace.
    public lazy var browserFunctions = Web3.BrowserFunctions(provider: self.provider, web3: self)

    public class BrowserFunctions: Web3OptionsInheritable {
        var provider: Web3Provider
        //        weak var web3: web3?
        var web3: Web3
        public var options: Web3Options {
            return web3.options
        }

        public init(provider prov: Web3Provider, web3 web3instance: Web3) {
            provider = prov
            web3 = web3instance
        }
    }
}
