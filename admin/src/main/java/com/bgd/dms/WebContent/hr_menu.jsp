<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
  response.setContentType("text/html;charset=utf-8");
  response.setHeader("Pragma","No-cache"); 
  response.setHeader("Cache-Control","no-cache"); 
  response.setDateHeader("Expires", 0);
  String contextPath = request.getContextPath();
  UserToken user = OMSMVCUtil.getUserToken(request);
  /**监测系统传递页面参数添加代码 开始**/
//获得监测系统传过来的参数
  Object o = request.getSession().getAttribute("pss_param_map");
  //request.getSession().removeAttribute("pss_param_map");
  String _param_ = "{}";
  /**监测系统传递页面参数添加代码 结束**/
%>
<%@include file="/common/include/quotesresource.jsp"%>
<title>ePlanet</title>
</head>
<body>
<div id="page_aside" class="fl">
    <div class="aside_column"><a href="#">功能列表</a></div>
    <div class="aside_wrap fl" id="secondmenu_container" style="height: 518px"></div>
</div>
<script type="text/javascript">
/**监测系统传递页面参数修改代码 开始**/
var p_param = '';
var p_param_bak = '';
<%if(o!=null){
	_param_ = (String)o;
%>
p_param = eval('(<%=_param_%>)');
p_param_bak = p_param;
<%}%>
//,'多项目','设备台账管理','设备台账管理(采集站)'
function loadData(parentNodeId,menu2l,menu3l,menu4l,fl){
	clearSenondMenu();
	Ext.Ajax.request({
		url : "<%=contextPath%>/queryMenus.srq?parentNodeId="+parentNodeId,
		method : 'Post',
		success : function(resp){
			setSenondMenu(resp,menu2l,menu3l,menu4l,fl);
		},
		failure : function(){// 失败
		}		
	});
}

var clickedMenu;
var pss_3lname=null;
var pss_5l = null;
var timeoutid = '';
var removeParamFlag = false;
function setSenondMenu(resp,menu2l,menu3l,menu4l,fl){
	if(fl=='0'){
		menu2l='';
		menu3l='';
		menu4l='';
		pss_3lname=null;
		pss_5l=null;
	}
	var container = document.getElementById("secondmenu_container");

	var datas = eval('(' + resp.responseText + ')');

	if(datas.returnCode!='0'){
		top.location='<%=contextPath%>/login.jsp';
	}
	
	var secondmenu = datas.nodes;

	for(var i=0;i<secondmenu.length;i++){
		
		var ul = document.createElement("ul");
		
		var span = document.createElement("span");
		span.className="mlv1";

		var a = document.createElement("a");
		a.className = "mlv1_a_add";
		a.menuId = secondmenu[i].id;
		a.menuName = secondmenu[i].name;
		a.menuUrl = secondmenu[i].url;
		a.loaded = false;
		if(fl=='1'){
			a.menu3l = menu3l;
			a.menu4l = menu4l;
		}
		a.onclick=function(){
			page_aside_mlv1(this);
			clickedMenu = this;

			if(this.menuName=="单项目" && parent.frames["topFrame"].projectSelected==false){
				//setThirdMenu(this);
				// 选择项目
				popWindow('<%=contextPath%>/pm/project/multiProject/selectProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view','800:600');
			}else{
				setThirdMenu(this);
				if(this.className=="mlv1_a_add") return;
				if(!(this.menu3l)){
					if(this.menuName=="多项目"){
						// 判断是公司级还是物探处级
						<% if(!user.getSubOrgIDofAffordOrg().equals("C105")){%>
						parent.frames["list"].location = getUrl(this.menuUrl);
						<%}%>
					}else{
						parent.frames["list"].location = getUrl(this.menuUrl);
					}
				}
			}
		};
		a.innerHTML=secondmenu[i].name;
		span.appendChild(a);
		ul.appendChild(span);
		container.appendChild(ul);
	}

	var flg = true;
	if(menu2l){
		//$("#secondmenu_container")
		var _obj = $(".mlv1 a");
		for(var i=0;i<_obj.length;i++){
			if(_obj.get(i).menuName==menu2l){
				flg = false;
				menu2l='';
				_obj.get(i).click();
			}
		}
		
		/* $.each($(".mlv1 a"),function(i,k){
			if($(k).attr('menuName')==menu2l){
				flg = false;
				menu2l='';
				k.click();
			}
			if(!flg){
				break;
			}
		}); */
	}
	
	if(flg){
		$(".mlv1 a").get(0).click();
	}
	if(secondmenu.length==1){
		$(".mlv1").css("display", "none");
	}
}
function setProject(longName, name){
	parent.frames["topFrame"].setProject(longName, name);
	
	setThirdMenu(clickedMenu);

	parent.frames["list"].location = getUrl(clickedMenu.menuUrl);
}

function clearSenondMenu(){
	document.getElementById("secondmenu_container").innerHTML="";
}

function setThirdMenu(secondMenu){
	
	if(!secondMenu.loaded){

		var ul = secondMenu.parentNode.parentNode;
		
		// 加载2级菜单
		Ext.Ajax.request({
			url : "<%=contextPath%>/queryMenus.srq?parentNodeId="+secondMenu.menuId,
			method : 'Post',
			success : function(resp3){

				var datas = eval('(' + resp3.responseText + ')');

				if(datas.returnCode!='0'){
					top.location='<%=contextPath%>/login.jsp';
				}
				
				var thirdmenu = datas.nodes;
	
				for(var j=0;j<thirdmenu.length;j++){
					
					var li = document.createElement("li");
					li.className = "mlv2";
	
					var a3 = document.createElement("a");
					a3.className = "mlv2_a_add";
					a3.target = "list";
					/*if(thirdmenu[j].url!=null && thirdmenu[j].url!="undefined" && thirdmenu[j].url!=""){
						a3.href = "<%=contextPath%>/"+thirdmenu[j].url;
					}else{
						a3.href = "about:blank";
					}*/
					a3.innerHTML = thirdmenu[j].name;
					a3.menuId = thirdmenu[j].id;
					a3.menuName = thirdmenu[j].name;
					a3.menuUrl = thirdmenu[j].url;
					a3.loaded=false;
					a3.hasChild=true;
					if(secondMenu.menu3l==thirdmenu[j].name){
						a3.menu4l = secondMenu.menu4l;
					}else{
						a3.menu4l = '';
					}
					a3.onclick=function(){
						page_aside_mlv2(this);
						setForthMenu(this);
					};
					if(secondMenu.menu3l==thirdmenu[j].name){
						pss_3lname=a3;
						secondMenu.menu3l='';
					}
					
					li.appendChild(a3);
					ul.appendChild(li);
				}
				if(thirdmenu.length==0){
					setForthMenu(secondMenu);
				}else{
					//触发菜单自动点击
					if(!!pss_3lname){
						page_aside_mlv2(pss_3lname);
						setForthMenu(pss_3lname);
					}
				}
				secondMenu.loaded = true;
			},
			failure : function(){// 失败
			}		
		});
	}
}

function setForthMenu(thirdMenu){

	if(!thirdMenu.loaded){

		//thirdMenu.loaded = true;
		
		var ul = document.createElement("ul");

		thirdMenu.parentNode.appendChild(ul);
		
		// 加载三级菜单
		Ext.Ajax.request({
			url : "<%=contextPath%>/queryMenus.srq?parentNodeId="+thirdMenu.menuId,
			method : 'Post',
			success : function(resp3){

				var datas = eval('(' + resp3.responseText + ')');

				if(datas.returnCode!='0'){
					top.location='<%=contextPath%>/login.jsp';
				}
				
				var fourthmenu = datas.nodes;

				for(var j=0;j<fourthmenu.length;j++){
					
					var li = document.createElement("li");
					li.className = "mlv3";
	
					var a3 = document.createElement("a");
					a3.target = "list";
					/*if(fourthmenu[j].url!=null && fourthmenu[j].url!="undefined" && fourthmenu[j].url!=""){
						a3.href = "<%=contextPath%>/"+fourthmenu[j].url;
					}else{
						a3.href = "about:blank";
					}*/
					a3.innerHTML = fourthmenu[j].name;
					a3.menuId = fourthmenu[j].id;
					a3.menuName = fourthmenu[j].name;
					/*if(fourthmenu[j].name.replace(/[^\x00-\xff]/g,"**").length>22) {
						a3.style.height="56";
					}*/
					var _u = fourthmenu[j].url;
					if(thirdMenu.menu4l!='' && thirdMenu.menu4l==fourthmenu[j].name){
						if(!!p_param){
							var f_ = true;
							if(_u.indexOf('?')!=-1){
								f_ = false;
							}
							var f___ = true;
							for(var key in p_param){
								if(f___){
									if(f_){
										_u = _u + "?" + key + "=" + p_param[key];
									}else{
										_u = _u + "&" + key + "=" + p_param[key];
									}
								}else{
									_u = _u + "&" + key + "=" + p_param[key];
								}
								f___ = false;
							}
							p_param='';
							removeParamFlag = true;
						}
					}
					a3.menuUrl = _u;
					a3.onclick=function(){
						setFiveMenu(this,null);
					};
					if(thirdMenu.menu4l!='' && thirdMenu.menu4l==fourthmenu[j].name){
						pss_5l = a3;
						thirdMenu.menu4l='';
					}
					li.appendChild(a3);
	
					ul.appendChild(li);
	
				}
				if(fourthmenu.length==0){
					thirdMenu.hasChild=false;
					var _u = thirdMenu.menuUrl;
					if(!!p_param){
						var f_ = true;
						if(_u.indexOf('?')!=-1){
							f_ = false;
						}
						var f___ = true;
						for(var key in p_param){
							if(f___){
								if(f_){
									_u = _u + "?" + key + "=" + p_param[key];
								}else{
									_u = _u + "&" + key + "=" + p_param[key];
								}
							}else{
								_u = _u + "&" + key + "=" + p_param[key];
							}
							f___ = false;
						}
						p_param='';
						removeParamFlag = true;
					}
					thirdMenu.menuUrl = _u;
					setFiveMenu(thirdMenu,'1');
				}else{
					if(!!pss_5l){
						setFiveMenu(pss_5l,'1');
						pss_5l=null;
					}
				}
				thirdMenu.loaded = true;
			},
			failure : function(){// 失败
			}		
		});
	}else{
		if(!thirdMenu.hasChild){
			setFiveMenu(thirdMenu,null);
		}
	}
}

function setFiveMenu(thirdMenu,flg){
	var url_ = thirdMenu.menuUrl;
	if(!flg){
		for(var key in p_param_bak){
			url_ = url_.replace('&'+key+'='+p_param_bak[key],'');
			url_ = url_.replace('?'+key+'='+p_param_bak[key],'');
		}
	}
	/**监测系统传递页面参数修改代码 结束**/
	parent.frames["fourthMenuFrame"].loadData(thirdMenu.menuId,thirdMenu.menuName,url_);

	$(thirdMenu).parent().parent().children("li").children("a").css("backgroundColor","");
	/* $(thirdMenu).css("backgroundColor","#F5DEB3"); */
	$(thirdMenu).css("backgroundColor","#ddeaf6");
}

function getUrl(menuUrl){
	var newUrl;
	if(menuUrl!=null && menuUrl!="undefined" && menuUrl!=""){

		if(menuUrl.indexOf("http://")==0 || menuUrl.indexOf("https://")==0){
			newUrl = menuUrl;
		}else if(menuUrl.indexOf("/")==0){
			newUrl = "<%=contextPath%>"+menuUrl;
		}else{
			newUrl = "<%=contextPath%>/"+menuUrl;
		}
	}else{
		newUrl = "about:blank";
	}

	return newUrl;
}

function popWindow(url,size){
	var sFeature = 'status=yes,toolbar=no,menubar=no,location=no';
	if(size==undefined) size = appConfig.popSize;
	if(size!=undefined){
		var strs = size.split(":");
		sFeature += ",width="+strs[0];
		if(strs.length==2) sFeature += ",height="+strs[1];		
	}
	if(url.indexOf('?')<=0) url += '?';
	else url += '&';
	url += 'popSize='+size;
	window.open(url,null,sFeature);
}
</script>   
 </body>
</html>
