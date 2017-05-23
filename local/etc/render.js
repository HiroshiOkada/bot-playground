var page = require('webpage').create();
var args = require('system').args;

page.onAlert = function(msg) {
  console.log('ALERT: ' + msg);
};

page.onConsoleMessage = function(msg) {
  console.log('CONSOLE: ' + msg);
};

page.viewportSize = { width: 800, height: 400 };

page.open('file:///home/bot/' + args[1], function() {
  page.evaluate(function() {
    const styleElement = document.createElement('style'),
          cssText = document.createTextNode('body { background: white; }'),
          head = document.head;
     styleElement.setAttribute('type', 'text/css');
     styleElement.appendChild(cssText);
     head.insertBefore(styleElement, head.firstChild);
  });
  page.render('out.png');
  phantom.exit(0);
});
