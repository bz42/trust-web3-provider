# Solana Wallet InjectJS

[help more](https://github.com/solana-labs/wallet-standard/blob/master/WALLET.md)

## Build the package

```shell
npm install
npm run build
```

This outputs .js files to the lib directory.

## webpack cjs

```shell
cp cjs/package.json cjs/webpack.config.js lib/cjs/
cd lib/cjs
npm install
npm run build
```
add to package.json
```json
    "build": "webpack --mode production",
```

## Debug cjs

```sh
cp lib/cjs/package.json lib/cjs/webpack.config.js cjs/
npm install webpack webpack-cli babel-loader @babel/preset-env --save-dev
npm install --save-dev webpack-dev-server
```