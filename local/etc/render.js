const SCREENSHOT_TIME = 3000;
const webpage = require('webpage')
const args = require('system').args;
const fs = require('fs');

console.log(args[1]);

var content = fs.read(args[1]);

var htmlTagRex = /<html[^>]*>/i;
if (!htmlTagRex.test(content)) {
  content = '<html>' + content + '</html>';
}

const headTagRex = /<head[^>]*>/i;
if (!headTagRex.test(content)) {
  content = content.replace(htmlTagRex, '$&<head><meta charset="UTF-8"/><style>body { background-color: #fff } \n* {font-family: TakaoPGothic; } </style></head>');
} else {
  content = content.replace(headTagRex, '$&<meta charset="UTF-8"/><style>body { background-color: #fff } \n* {font-family: TakaoPGothic; } </style></head>');
}

const page = webpage.create();

page.onAlert = function(msg) {
  console.log('ALERT: ' + msg);
};

page.onConsoleMessage = function(msg) {
  console.log(msg);
};

page.onLoadFinished = function(status) {
  console.log('Status: ' + status);
  setTimeout(function() {
    page.render('out.png');
    phantom.exit(0);
  }, SCREENSHOT_TIME);
};

page.setContent(content, 'http://example.com/');

setTimeout(function() {
  phantom.exit(0);
}, SCREENSHOT_TIME+1000);

