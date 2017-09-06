var glob = require("glob");
var path = require('path');

const ExtractTextPlugin = require("extract-text-webpack-plugin");

// const extractSass = new ExtractTextPlugin({
//     filename: "[name].[contenthash].css",
//     disable: process.env.NODE_ENV === "development"
// });

module.exports = {
  entry: glob.sync("./sass/*.scss"),
  output: {
    path: path.join(__dirname, './css/'),
    filename: '[name].css' // output js file name is identical to css file name
  },
    module: {
        rules: [{
            test: /\.scss$/,
            loader: ExtractTextPlugin.extract({
                use: [{
                    loader: "css-loader"
                }, {
                    loader: "sass-loader"
                }],
                // use style-loader in development
                fallback: "style-loader"
            })
        }]
    },
    plugins: [
        // extractSass
        new ExtractTextPlugin('[name].css')
    ]
};
