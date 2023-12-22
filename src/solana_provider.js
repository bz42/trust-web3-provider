// Copyright © 2017-2020 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

"use strict";

import BaseProvider from "./base_provider";
import * as Web3 from "@solana/web3.js";
import bs58 from "bs58";
import Utils from "./utils";
import ProviderRpcError from "./error";

const { PublicKey } = Web3;

class TrustSolanaWeb3Provider extends BaseProvider {
  constructor(config) {
    super(config);

    this.providerNetwork = "solana";
    this.callbacks = new Map();
    this.publicKey = null;
    this.isConnected = false;
  }

  connect() {
    return this._request("requestAccounts").then((addresses) => {
      this.setAddress(addresses[0]);
      this.emit("connect");
    });
  }

  disconnect() {
    return new Promise((resolve) => {
      this.publicKey = null;
      this.isConnected = false;
      this.emit("disconnect");
      resolve();
    });
  }

  setAddress(address) {
    this.publicKey = new PublicKey(address);
    this.isConnected = true;
  }

  emitAccountChanged(account) {
      if (account !== null) {
          this.setAddress(account);
          this.emit("accountChanged", this.publicKey);
      } else {
          this.disconnect()
      }
  }

  signMessage(message) {
    const raw = bs58.encode(message);
    if (this.isDebug) {
      console.log(`==> signMessage ${message}, bs58: ${raw}`);
    }
    return this._request("signMessage", { data: raw }).then((data) => {
      return {
        signature: bs58.decode(data),
      };
    });
  }

  mapSignedTransaction(tx, signatureEncoded) {
    const version = typeof tx.version !== "number" ? "legacy" : tx.version;
    const signature = bs58.decode(signatureEncoded);

    tx.addSignature(this.publicKey, signature);

    // if (version === "legacy" && !tx.verifySignatures()) {
    //   throw new ProviderRpcError(4300, "Invalid signature");
    // }

    if (this.isDebug) {
      console.log(`==> signed single ${JSON.stringify(tx)}`);
    }

    return tx;
  }

  signTransaction(tx) {
    const raw = JSON.stringify(tx);
    const version = typeof tx.version !== "number" ? "legacy" : tx.version;

    const txData = function () {
      try {
        return tx.message.serialize();
      } catch (error) {
        return tx.serialize();
      }
    };

    const data = bs58.encode(txData());

    return this._request("signRawTransaction", { data, raw, version })
      .then((signatureEncoded) =>
        this.mapSignedTransaction(tx, signatureEncoded)
      )
  }

  signAllTransactions(txs) {
    return Promise.all(txs.map((tx) => this.signTransaction(tx)));
  }

  signAllTransactionsV2(txs) {
    return this._request("signRawTransactionMulti", {
      transactions: txs.map((tx) => {
        const data = JSON.stringify(tx);
        const version = typeof tx.version !== "number" ? "legacy" : tx.version;

        const txData = function () {
          try {
            if (version === "legacy") {
              return tx.serializeMessage();
            } else if (version === 0) {
              return tx.message.serialize();
            } else {
              return tx.serialize();
            }
          } catch (error) {
            if (version === 0) {
              return tx.message.serialize();
            } else {
              return tx.serialize();
            }
          }
        };
        const raw = bs58.encode(txData());
        return { data, raw, version };
      }),
    })
      .then((signaturesEncoded) =>
        signaturesEncoded.map((signature, i) =>
          this.mapSignedTransaction(txs[i], signature)
        )
      )
  }

  sendRawTransaction(signedTx, options) {
    const data = JSON.stringify(signedTx);
    const raw = bs58.encode(signedTx.serialize());
    return this._request("sendRawTransaction", { data, raw, options })
      .then((signatureEncoded) => {
        return bs58.decode(signatureEncoded);
      })
  }

  signAndSendTransaction(tx, options) {
    if (this.isDebug) {
      console.log(
        `==> signAndSendTransaction ${JSON.stringify(tx)}, options: ${options}`
      );
    }
    return this.signTransaction(tx)
      .then(this.sendRawTransaction)
      .then((signature) => {
        return { signature: signature };
      });
  }

  /**
   * @private Internal rpc handler
   */
  _request(method, payload) {
    if (this.isDebug) {
      console.log(
        `==> _request method: ${method}, payload ${JSON.stringify(payload)}`
      );
    }
    return new Promise((resolve, reject) => {
      const id = Utils.genId();
      console.log(`==> setting id ${id}`);
      this.callbacks.set(id, (error, data) => {
        if (error) {
          reject(error);
        } else {
          resolve(data);
        }
      });

      switch (method) {
        case "signMessage":
          return this.postMessage("signMessage", id, payload);
        case "signRawTransaction":
          return this.postMessage("signRawTransaction", id, payload);
        case "signRawTransactionMulti":
          return this.postMessage("signRawTransactionMulti", id, payload);
        case "requestAccounts":
          return this.postMessage("requestAccounts", id, {});
        case "sendRawTransaction":
          return this.postMessage("sendRawTransaction", id, payload);
        default:
          // throw errors for unsupported methods
          throw new ProviderRpcError(
            4200,
            `Wallet does not support calling ${payload.method} yet.`
          );
      }
    });
  }
}

module.exports = TrustSolanaWeb3Provider;
