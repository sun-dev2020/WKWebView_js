# WKWebView_js
js和native之间的传值和反射

 js -> Native -> js 回调+传值的数据通道
1.js向native层的传值和反射  
 
 step1， 新建Console.js，在里面有console 和 log函数。以及对应native层中的类Console.h, 和处理函数-log:   
 step2， 在webview显示前  注入Console.js代码    
 step3， 在safari开发调试控制器中，执行console.log('cooper')    
 step4， 通过回调函数-didReceiveScriptMessage ，解析出对应的类Console，和函数-log:    
 step5， 由native层的Console类执行-log:    
