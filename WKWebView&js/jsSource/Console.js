



console = {
log: function(string){
    window.webkit.messageHandlers.observe.postMessage({className:"Console",functionName:"log2",data:string})
}
}