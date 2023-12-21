// Copyright © 2017-2022 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

public enum ProviderNetwork: String, Decodable {
    case ethereum
    case solana
}

public enum SolWalletError {
    case rpc_invalidInput
    case rpc_resourceUnavailable
    case rpc_transactionRejected
    case rpc_methodNotFound
    case rpc_internal
    case provider_userRejectedRequest
    case provider_unauthorized
    case provider_disconnected

    var code: Int {
        switch self {
        case .rpc_invalidInput:
            return -32000
        case .rpc_resourceUnavailable:
            return -32002
        case .rpc_transactionRejected:
            return -32003
        case .rpc_methodNotFound:
            return -32601
        case .rpc_internal:
            return -32603
        case .provider_userRejectedRequest:
            return 4001
        case .provider_unauthorized:
            return 4100
        case .provider_disconnected:
            return 4900
        }
    }

    var message: String {
        switch self {
        case .rpc_invalidInput:
            return "Invalid input."
        case .rpc_resourceUnavailable:
            return "Resource unavailable."
        case .rpc_transactionRejected:
            return "Transaction rejected."
        case .rpc_methodNotFound:
            return "The method does not exist / is not available."
        case .rpc_internal:
            return "Internal JSON-RPC error."
        case .provider_userRejectedRequest:
            return "User rejected the request."
        case .provider_unauthorized:
            return "The requested account and/or method has not been authorized by the user."
        case .provider_disconnected:
            return "The provider is disconnected from all chains."
        }
    }
}

public enum EthWalletError {
    case rpc_invalidInput
    case rpc_resourceNotFound
    case rpc_resourceUnavailable
    case rpc_transactionRejected
    case rpc_methodNotSupported
    case rpc_limitExceeded
    case rpc_parse
    case rpc_invalidRequest
    case rpc_methodNotFound
    case rpc_invalidParams
    case rpc_internal
    case provider_userRejectedRequest
    case provider_unauthorized
    case provider_unsupportedMethod
    case provider_disconnected
    case provider_chainDisconnected

    var code: Int {
        switch self {
        case .rpc_invalidInput:
            return -32000
        case .rpc_resourceNotFound:
            return -32001
        case .rpc_resourceUnavailable:
            return -32002
        case .rpc_transactionRejected:
            return -32003
        case .rpc_methodNotSupported:
            return -32004
        case .rpc_limitExceeded:
            return -32005
        case .rpc_parse:
            return -32700
        case .rpc_invalidRequest:
            return -32600
        case .rpc_methodNotFound:
            return -32601
        case .rpc_invalidParams:
            return -32602
        case .rpc_internal:
            return -32603
        case .provider_userRejectedRequest:
            return 4001
        case .provider_unauthorized:
            return 4100
        case .provider_unsupportedMethod:
            return 4200
        case .provider_disconnected:
            return 4900
        case .provider_chainDisconnected:
            return 4901
        }
    }

    var message: String {
        switch self {
        case .rpc_invalidInput:
            return "Invalid input."
        case .rpc_resourceNotFound:
            return "Resource not found."
        case .rpc_resourceUnavailable:
            return "Resource unavailable."
        case .rpc_transactionRejected:
            return "Transaction rejected."
        case .rpc_methodNotSupported:
            return "Method not supported."
        case .rpc_limitExceeded:
            return "Request limit exceeded."
        case .rpc_parse:
            return "Invalid JSON was received by the server. An error occurred on the server while parsing the JSON text."
        case .rpc_invalidRequest:
            return "The JSON sent is not a valid Request object."
        case .rpc_methodNotFound:
            return "The method does not exist / is not available."
        case .rpc_invalidParams:
            return "Invalid method parameter(s)."
        case .rpc_internal:
            return "Internal JSON-RPC error."
        case .provider_userRejectedRequest:
            return "User rejected the request."
        case .provider_unauthorized:
            return "The requested account and/or method has not been authorized by the user."
        case .provider_unsupportedMethod:
            return "The requested method is not supported by this Ethereum provider."
        case .provider_disconnected:
            return "The provider is disconnected from all chains."
        case .provider_chainDisconnected:
            return "The provider is disconnected from the specified chain."
        }
    }
}
