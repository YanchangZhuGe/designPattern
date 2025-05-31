// JavaScript Document for public functions
function $(id){	//return HTML object by object id
	var obj = false;
	obj = document.getElementById(id);			

	if(obj == null){
		obj = parent.document.getElementById(id);
	}

	return obj ? obj : undefined;
}

function $V(id){	//return HTML object's value
	if($(id) != undefined){
		return $(id).value;
	}else{
		return null;
	}
}

function $Len(id){
	if($(id) != undefined){
		return $(id).options.length;
	}else{
		return null;
	}
}

function $Rows(id){
	if($(id) != undefined){
		return $(id).rows.length;
	}else{
		return null;
	}
}

//------ajax---------
var Ajax = {
  getTransport: function() {
    return Try.these(
      function() {return new XMLHttpRequest()},
      function() {return new ActiveXObject("Msxml2.XMLHTTP")},
      function() {return new ActiveXObject("Microsoft.XMLHTTP")}
    ) || false;
  },

  activeRequestCount: 0
}

var Try = {
  these: function() {
    var returnValue;

    for (var i = 0, length = arguments.length; i < length; i++) {
      var lambda = arguments[i];
      try {
        returnValue = lambda();
        break;
      } catch (e) {}
    }

    return returnValue;
  }
}

//------select options control-----
function addOptions(selectId, arrValue, arrText){
	try{
		for(i = 0, arrLen = arrValue.length; i < arrLen; i++){
			if(arrText[i] != "" && arrValue[i] != ""){
				$(selectId).options.add( new Option(arrText[i], arrValue[i]) );
			}
		}
	}catch(e){}
}

function clearOptions(selectId){
	try{
		$(selectId).options.length=0;
	}catch(e){}
}

function setSelected(selectId, index){
	try{
		$(selectId).options[index].selected = true;
	}catch(e){}
}

//-----------set values-------
function setSrc(objId, url){
	try{
		$(objId).src = url;
	}catch(e){}
}

function setInnerHTML(objId, str){
	try{
		$(objId).innerHTML = str;
	}catch(e){}
}

function addInnerHTML(objId, str, tag){
	try{
		var tempStr = $(objId).innerHTML;
		if(tempStr.indexOf(str) == -1){
			$(objId).innerHTML += tag + str;
		}
	}catch(e){}
}

function setValue(objId, value){
	try{
		$(objId).value = value;
	}catch(e){}
}

function subFrameDoc(iframeId){
	try{
		var frameDoc;

		if(document.all){
		    try{
			frameDoc = window.frames[iframeId].document;
   		    }catch(e){
		        try{
				frameDoc = parent.window.frames[iframeId].document;
		        }catch(e){alert("Your IE's version is to old!\nPlease try some new one!");}
		    }
		}else{
		    try{
			frameDoc = document.getElementById(iframeId).contentWindow.document;
		    }catch(e){
			try{
				frameDoc = parent.document.getElementById(iframeId).contentWindow.document;
			}catch(e){alert("Your Firefox's version is to old!\nPlease try some new one!");}
		    }
		}

		return frameDoc ? frameDoc : null;
	}catch(e){return false;}
}

function setSubFrameValue(iframeId, objId, str){
	var frameDoc = subFrameDoc(iframeId);
	frameDoc.getElementById(objId).value = str;
}

function resetValue(objId){
	try{
		$(objId).value = "";
	}catch(e){}
}

function setBgColor(obj, color){
	try{
		if(obj.style.backgroundColor == ""){
			obj.style.backgroundColor = color;
		}else{
			obj.style.backgroundColor = "";
		}
	}catch(e){}
}

function setWidth(objId, value){
	try{
		$(objId).style.width = value;
	}catch(e){}	
}//set style width

function setHeight(objId, value){
	try{
		$(objId).style.height = value;
	}catch(e){}	
}//set style height

function setTop(objId, value){
	try{
		$(objId).style.top = value;
	}catch(e){}	
}//set style top

function setLeft(objId, value){
	try{
		$(objId).style.left = value;
	}catch(e){}	
}//set style left

function setRight(objId, value){
	try{
		$(objId).style.right = value;
	}catch(e){}	
}//set style right

function setBottom(objId, value){
	try{
		$(objId).style.bottom = value;
	}catch(e){}	
}//set style bottom

//--------check value-----
function isNull(objId){
	if($(objId) != undefined && $(objId).value != ""){
		return false;
	}else{
		return true;
	}
}

//--------disable object------
function disable(objId){
	try{
		$(objId).disabled = true;
	}catch(e){}	
}

function release(objId){
	try{
		$(objId).disabled = false;
	}catch(e){}
}

//--------show or hide div window----
function show(objId){
	try{
		if($(objId).style.display != "block"){
			$(objId).style.display = "block";
		}else{
			$(objId).style.display = "none";
		}
	}catch(e){}		
}

//---------calculate--------
function addExpression(objId){
	var value = 0.0;
	try{
		var arr = new Array();
		arr = ($(objId).value).split("+");

		var i = 0;
		for(i=0; i<arr.length; i++){
			value += parseFloat(arr[i]);
		}
	}catch(e){alert("add error");}
	return parseFloat(value);
}

//----------string decode-----
function trim(str){
	var re = / /g;
	str = str.replace(re, "");
	return str;
}

function trin(str){
	var re = /\n/g;
	str = str.replace(re, "");
	re = /\r/g;
	str = str.replace(re, "");
	return str;
}

//----location redirect----
function ifDel(url){
	if(confirm("确定删除？")){
		window.location.href=url;
	}
}

//----div drag----
function drag(div){
	div.onmousedown=function(a){
		//change div background color
		div.style.backgroundColor = "#0080C0";
	
		var d=document;
		if(!a)a=window.event;
		var x=a.layerX?a.layerX:a.offsetX,y=a.layerY?a.layerY:a.offsetY;
		if(div.setCapture){
			div.setCapture();
		}
		else if(window.captureEvents){
			window.captureEvents(Event.MOUSEMOVE|Event.MOUSEUP);
		}

		d.onmousemove=function(a){
			if(!a)a=window.event;
			if(!a.pageX)a.pageX=a.clientX;
			if(!a.pageY)a.pageY=a.clientY;
			var tx=a.pageX-x,ty=a.pageY-y;
			div.style.left=tx;
			div.style.top=ty;
		};

		d.onmouseup=function(){
			//change back div background color
			div.style.backgroundColor = "#00A3F0";

			if(div.releaseCapture)
				div.releaseCapture();
			else if(window.captureEvents)
				window.captureEvents(Event.MOUSEMOVE|Event.MOUSEUP);
			d.onmousemove=null;
			d.onmouseup=null;
		};
	};
}

//----disable some key or button---
function disCtrlAnd(evt, keycode){
	if(evt.ctrlKey && evt.keyCode == keycode){
		evt.keyCode=0;
		return false;
	}else{
		return true;
	}
}

function disAltAnd(evt, keycode){
	if(evt.altKey && evt.keyCode == keycode){
		evt.keyCode=0;
		return false;
	}else{
		return true;
	}
}

//------MD5 call nums-------
/*function MD5_S(num, str){
	var i=0;
	for(i=0; i<num; i++){
		str = MD5(str);
	}
	
	return str;
}*/