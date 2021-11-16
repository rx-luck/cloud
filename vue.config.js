module.exports = {
    productionSourceMap: false,
    publicPath: './',
    outputDir: 'dist',
    assetsDir: 'assets',
    devServer: {
        port: 8080,
        host: '192.168.2.102',
        https: false,
        open: true,
    },
    configureWebpack: {
        plugins: []
    },
};