module.exports = {
  "transpileDependencies": [
    "vuetify"
  ],
  devServer: {
    host: 'localhost',
    proxy: {
      '/api': {
        target: 'http://localhost:5000/api', 
        changeOrigin: true,
        pathRewrite: {
            '^/api': ''
        }
      }
    }
  }
}