Element.prototype.jwAddClass=function(className){if(this.classList){this.classList.add(className);}else{this.className+=" "+className;}};Element.prototype.jwRemoveClass=function(className){if(this.classList){this.classList.remove(className);}else{this.className=this.className.replace(new RegExp("(^|\\b)"+
className.split(" ").join("|")+
"(\\b|$)","gi")," ");}};Element.prototype.jwToggleClass=function(className){if(this.classList){this.classList.toggle(className);}else{var classes=this.className.split(" ");var existingIndex=classes.indexOf(className);if(existingIndex>=0){classes.splice(existingIndex,1);}else{classes.push(className);}
this.className=classes.join(" ");}};Element.prototype.jwHasClass=function(className){if(this.classList){return this.classList.contains(className);}else{return new RegExp("(^| )"+className+
"( |$)","gi").test(this.className);}};Element.prototype.jwOn=function(eventName,callback,useCapture){this.addEventListener(eventName,callback,useCapture||false);};;if(!window.JAWS){var JAWS={};}
function Ajax(settings,callback){var jsonpScript=document.createElement("script"),jsonpCallbackFunction,XHR;var createXhrObject=function(){if(typeof XMLHttpRequest!=="undefined"){return new XMLHttpRequest();}
var versions=["MSXML2.XmlHttp.5.0","MSXML2.XmlHttp.4.0","MSXML2.XmlHttp.3.0","MSXML2.XmlHttp.2.0","Microsoft.XmlHttp"],versionsLength=versions.length,xhr,i;for(i=0;i<versionsLength;i++){try{xhr=new ActiveXObject(versions[i]);break;}catch(e){}}
return xhr;},getRequestData=function(data){var query=[];if(data){for(var i=0;i<Object.keys(data).length;i++){key=Object.keys(data)[i];query.push(encodeURIComponent(key)+"="+
encodeURIComponent(data[key]));}}
return query.join("&");},xhrError=function(){console.error(this.statusText);},send=function(url,callback,method,data,sync){XHR.open(method,url,sync);XHR.onreadystatechange=function(){if(XHR.readyState===4){if(XHR.status===200){callback(XHR.responseText);}}};XHR.onerror=this.xhrError;if(method==="POST"){this.XHR.setRequestHeader("Content-type","application/x-www-form-urlencoded");}
XHR.send(data);},evalJSONP=function(callback){return function(data){var validJSON=false;delete window[jsonpCallbackFunction];try{document.body.removeChild(jsonpScript);}catch(err){document.head.removeChild(jsonpScript);}
var responseJSON;if(typeof data=="string"){try{validJSON=JSON.parse(console.log(validJSON));responseJSON=validJSON;}catch(e){}}else{validJSON=JSON.parse(JSON.stringify(data));responseJSON=data;}
if(validJSON){callback(responseJSON);}else{throw("JSONP call returned invalid or empty JSON");}};},jsonp=function(url,callback){jsonpCallbackFunction="callbackfunction"+
Math.round(100000*Math.random());url+=(url.indexOf("?")!==-1?"&":"?")+"callback="+
jsonpCallbackFunction;window[jsonpCallbackFunction]=evalJSONP(callback);jsonpScript.type="text/javascript";jsonpScript.async=true;jsonpScript.src=url;if(!document.body){document.head.appendChild(jsonpScript);}else{document.body.appendChild(jsonpScript);}},init=function(settings,callback){var sync=settings.async||true,data=settings.data,query=getRequestData(data),url=settings.url;XHR=createXhrObject();if(settings.hasOwnProperty("xhrFields")){if(settings.xhrFields.hasOwnProperty("withCredentials")){XHR.withCredentials=true;}}
switch(settings.type){case"POST":send(url,callback,"POST",query,sync);break;case"JSON":send(url,callback,"GET",query,sync);break;case"JSONP":jsonp(url,callback);break;default:send(url+"?"+query,callback,"GET",null,sync);break;}};if(!settings.url){throw"No URL was specified";}
init(settings,callback);};if(!window.JAWS){var JAWS={};}
JAWS.main=(function(){var key=JAWS.api_key||PBS_CHROME_CONFIG.api_key,apiDomain='//jaws.pbs.org/'+"getwidgets/",overrides=PBS_CHROME_CONFIG.widgets,widgetData={};if(window.apiDomain){apiDomain=window.apiDomain;}
function loadStylesheets(urls){if(!(urls instanceof Array)){throw("Failed to load JAWS stylesheets due to erronous urls parameter. Expected Array.");}
var key,link;for(var i=0;i<urls.length;i++){link=document.createElement("link");link.rel="stylesheet";link.type="text/css";link.href=urls[i];document.head.appendChild(link);}}
function exists(url){scripts=document.getElementsByTagName("script");for(var i=0;i<scripts.length;i++){scr=scripts[i];if(scr.src==url&&url=="//d2ok2u3bz752mp.cloudfront.net/prod/1.11.1/"+"js/localization.js")
return true;}
return false;}
function loadScripts(urls,callback){if(!(urls instanceof Array)){throw("Failed to load JAWS stylesheets due to erronous urls parameter. Expected Array.");}
var key;for(var i=0;i<urls.length;i++){if(!exists(urls[i])){var script=document.createElement("script");script.src=urls[i];script.async=false;document.head.appendChild(script);if(callback){script.onload=callback;script.onreadystatechange=function(){if(script.readyState==="loaded"||script.readyState==="complete"){callback();}};}}}}
function insertContent(type,selector,html){var container,location,inLineScripts,inLineScript;if(typeof html==="undefined"){throw"No html has specified";}
if(type==="body"){container=document.createElement("div");container.className="pbs-cleanslate";if(selector!==""){container.id=selector;}
container.innerHTML=html;document.body.insertBefore(container,document.body.firstChild);}
if(type==="iframe"){location=document.querySelector(selector);if(location){location.innerHTML=html;}else{console.error("Could not find the element with the id of '"+
selector+"'");}}
if(type==="inline"){location=document.querySelector(selector);if(location){location.innerHTML=html;inLineScripts=location.getElementsByTagName("script");if(inLineScripts.length>0){for(index=0;index<inLineScripts.length;index++){if(!inLineScripts[index].hasAttribute("src")){eval(inLineScripts[index].innerHTML);}
else{var src=inLineScripts[index].getAttribute("src");var elem=inLineScripts[index];elem.parentNode.removeChild(elem);index--;JAWS.main.loadScripts([src]);}}}}else{console.error("Could not find the element with the id of '"+
selector+"'");}}}
function loadWidgets(widgets){var selector,key;for(key in widgets){if(overrides&&overrides.hasOwnProperty(key)){selector=overrides[key].placeholder;}else{selector="jaws_"+key;}
if(widgets.hasOwnProperty(key)){if(widgets[key].hasOwnProperty("data")){widgetData[key]=widgets[key].data;}
switch(widgets[key].type){case"body":if(widgets[key].hasOwnProperty("html")){insertContent("body",selector,widgets[key].html);}
if(widgets[key].hasOwnProperty("css")){loadStylesheets(widgets[key].css);}
if(widgets[key].hasOwnProperty("js")&&widgets[key].js!==""){loadScripts(widgets[key].js);}
break;case"iframe":if(selector&&widgets[key].hasOwnProperty("html")){insertContent("iframe",selector,widgets[key].html);}
break;case"inline":if(selector&&widgets[key].hasOwnProperty("html")){insertContent("inline",selector,widgets[key].html);}
break;case"script":if(widgets[key].hasOwnProperty("js")&&widgets[key].js!==""){loadScripts(widgets[key].js);}
break;}}}}
function getWidgetData(widget){var data;if(widgetData.hasOwnProperty(widget)){data=widgetData[widget];}
return data;}
function receiveMessage(event){if(event.origin.indexOf("jaws")>=0){var selector=event.data.selector,iframe=document.getElementById(selector),height=event.data.height||null;if(navigator.userAgent.match(/MSIE 9/i)){height=event.data.split("|")[0];iframe=document.getElementsByClassName(event.data.split("|")[1])[0];}
if(!iframe){iframe=document.getElementById("whatson_frame");}
if(!iframe){iframe=document.getElementById("whatsonkids_frame");}
if(!iframe){iframe=document.getElementById("airdates_frame");}
iframe.style.height=height+"px";}}
function postWidthToWindow(){var frame=document.getElementById('tvss_frame');if(!frame){frame=document.getElementById('whatson_frame');}
if(!frame){frame=document.getElementById('whatsonkids_frame');}
if(!frame){frame=document.getElementById('airdates_frame');}
if(!frame){return;}else{setInterval(function(){var frameParent=frame.parentNode;var win=frame.contentWindow;win.postMessage({'width':frameParent.offsetWidth},"*");},100);}}
function init(){if(!document.location.origin){document.location.origin=document.location.protocol+"//"+document.location.hostname+(document.location.port?':'+document.location.port:'');}
var ajax=new Ajax({url:apiDomain+key+"/?referrer="+document.location.origin+document.location.pathname,type:"JSONP",},function(data){if(Object.keys(data.widgets).length>0){loadWidgets(data.widgets);if(navigator.userAgent.match(/iPad/i)!=null){postWidthToWindow();}}});}
if(document.addEventListener){document.addEventListener("DOMContentLoaded",init);window.addEventListener("message",receiveMessage,false);}else{document.attachEvent("onreadystatechange",init);window.attachEvent('onmessage',receiveMessage);}
return{loadScripts:loadScripts,loadStylesheets:loadStylesheets,insertContent:insertContent,getWidgetData:getWidgetData};}());