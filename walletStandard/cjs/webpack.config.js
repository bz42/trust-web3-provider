const path = require('path');

module.exports = {
  resolve: {
    extensions: ['.js'],
  },
  entry: './index.js',
  output: {
    filename: 'wssol-min.js',
    path: path.resolve(__dirname, '../webpack'),
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env']
          }
        }
      }
    ]
  }
};