/*
 Quantcast measurement tag
 Copyright (c) 2008-2017, Quantcast Corp.
*/
(function(e,g,f){try{__qc("defaults",e,{labels:"_fp.event.Default"})}catch(k){}var h=function(a,b,c){return a?"nc"===a?!b||!c||0>b.indexOf(c):"eq"===a?b===c:"sw"===a?0===b.indexOf(c):"ew"===a?(a=b.length-c.length,b=b.lastIndexOf(c,a),-1!==b&&b===a):"c"===a?0<=b.indexOf(c):!1:!1};__qc("rules",[e,null,[[function(a){return"array"==={}.toString.call(a).match(/\s([a-zA-Z]+)/)[1].toLowerCase()?{labels:a.join(",")}:{labels:""+a}},"_fp.event.Homepage"]],[[function(a,b,c){var d;if(g.top===g.self)d=f.location.pathname;
else{d=f.referrer;var e=f.createElement("a");e.href=d;d=e.pathname}h(b,d,c)?a(d):a(!1)},"eq","/"]]])})("p-Z4bfNLnN8psjN",window,document);