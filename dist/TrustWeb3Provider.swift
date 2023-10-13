// Copyright © 2017-2022 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import WebKit

public struct TrustWeb3Provider {
    public struct Config: Equatable {
        public let ethereum: EthereumConfig
        public let solana: SolanaConfig
        public let aptos: AptosConfig

        public init(
            ethereum: EthereumConfig,
            solana: SolanaConfig = SolanaConfig(cluster: "mainnet-beta"),
            aptos: AptosConfig = AptosConfig(network: "Mainnet", chainId: "1")
        ) {
            self.ethereum = ethereum
            self.solana = solana
            self.aptos = aptos
        }

        public struct EthereumConfig: Equatable {
            public let address: String
            public let chainId: Int
            public let rpcUrl: String

            public init(address: String, chainId: Int, rpcUrl: String) {
                self.address = address
                self.chainId = chainId
                self.rpcUrl = rpcUrl
            }
        }

        public struct SolanaConfig: Equatable {
            public let cluster: String

            public init(cluster: String) {
                self.cluster = cluster
            }
        }

        public struct AptosConfig: Equatable {
            public let network: String
            public let chainId: String

            public init(network: String, chainId: String) {
                self.network = network
                self.chainId = chainId
            }
        }
    }

    private class dummy {}
    public static let scriptHandlerName = "_tw_"
    public let config: Config

    public var providerScript: WKUserScript {
        let providerJsUrl = {
            return Bundle.module.url(forResource: "trust-min", withExtension: "js")!
        }()
        let source = try! String(contentsOf: providerJsUrl)
        return WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    }
    
    public var walletStandardScript: WKUserScript {
        let walletStandardJsUrl = {
            return Bundle.module.url(forResource: "wssol-min", withExtension: "js")!
        }()
        let source = try! String(contentsOf: walletStandardJsUrl)
        return WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    }

    public var injectScript: WKUserScript {
        let source = """
        (function() {
            var config = {
                ethereum: {
                    address: "\(config.ethereum.address)",
                    chainId: \(config.ethereum.chainId),
                    rpcUrl: "\(config.ethereum.rpcUrl)"
                },
                solana: {
                    cluster: "\(config.solana.cluster)"
                },
                aptos: {
                    network: "\(config.aptos.network)",
                    chainId: "\(config.aptos.chainId)"
                }
            };

            trustwallet.ethereum = new trustwallet.Provider(config);
            trustwallet.solana = new trustwallet.SolanaProvider(config);
            trustwallet.cosmos = new trustwallet.CosmosProvider(config);
            trustwallet.aptos = new trustwallet.AptosProvider(config);

            trustwallet.postMessage = (jsonString) => {
                webkit.messageHandlers._tw_.postMessage(jsonString)
            };
            
            trustwallet.ethereum.isMetaMask = true;
            trustwallet.ethereum.isTrust = false;
            window.ethereum = trustwallet.ethereum;
            window.keplr = trustwallet.cosmos;
            window.aptos = trustwallet.aptos;
            trustwallet.solana.isPhantom = true;
            //window.solana = trustwallet.solana;

            wsInjections.Setup(trustwallet.solana);
            try {
                Object.defineProperty(window, 'awsWSWallet', { value: awsWSWallet });
            }
            catch (error) {
                console.error(error);
            }
            console.log("inject wallet");
        })();
        """
        return WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    }

    public init(config: Config) {
        self.config = config
    }
}
