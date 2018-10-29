const lambit = require('lambit')

const origin = process.env.CLOUDFRONT_ORIGIN;

exports.handler = lambit({
  cleanUrls: true,
  rewrites: [
    { source: '/favicon.ico', to: origin + '/static/favicon.ico' },
    { source: '/*', to: origin + '/index.html' }
  ]
})
