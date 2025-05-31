<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	String contextPath = request.getContextPath(); 
	Date now = new Date();	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
		//(user==null)?"":user.getEmpId();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
	String father_id = request.getParameter("father_id");
	String sub_id = request.getParameter("sub_id");
	String org_subjection_id = request.getParameter("org_subjection_id");
	String org_type = request.getParameter("org_type");
	String org_sub_id = request.getParameter("org_sub_id");
	String second_org = request.getParameter("second_org");
	String doc_main_id = request.getParameter("doc_main_id");	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript">
var isIE = (document.all) ? true : false;

var isIE6 = isIE && ([/MSIE (\d)\.0/i.exec(navigator.userAgent)][0][1] == 6);

var $ = function (id) {
	return "string" == typeof id ? document.getElementById(id) : id;
};

var Class = {
	create: function() {
		return function() { this.initialize.apply(this, arguments); }
	}
}

var Extend = function(destination, source) {
	for (var property in source) {
		destination[property] = source[property];
	}
}

var Bind = function(object, fun) {
	return function() {
		return fun.apply(object, arguments);
	}
}

var BindAsEventListener = function(object, fun) {
	var args = Array.prototype.slice.call(arguments).slice(2);
	return function(event) {
		return fun.apply(object, [event || window.event].concat(args));
	}
}

var CurrentStyle = function(element){
	return element.currentStyle || document.defaultView.getComputedStyle(element, null);
}

function addEventHandler(oTarget, sEventType, fnHandler) {
	if (oTarget.addEventListener) {
		oTarget.addEventListener(sEventType, fnHandler, false);
	} else if (oTarget.attachEvent) {
		oTarget.attachEvent("on" + sEventType, fnHandler);
	} else {
		oTarget["on" + sEventType] = fnHandler;
	}
};

function removeEventHandler(oTarget, sEventType, fnHandler) {
    if (oTarget.removeEventListener) {
        oTarget.removeEventListener(sEventType, fnHandler, false);
    } else if (oTarget.detachEvent) {
        oTarget.detachEvent("on" + sEventType, fnHandler);
    } else { 
        oTarget["on" + sEventType] = null;
    }
};

//图片切割
var ImgCropper = Class.create();
ImgCropper.prototype = {
  //容器对象,控制层,图片地址
  initialize: function(container, handle, url, options) {
	this._Container = $(container);//容器对象
	this._layHandle = $(handle);//控制层
	this.Url = url;//图片地址
	
	this._layBase = this._Container.appendChild(document.createElement("img"));//底层
	this._layCropper = this._Container.appendChild(document.createElement("img"));//切割层
	this._layCropper.onload = Bind(this, this.SetPos);
	//用来设置大小
	this._tempImg = document.createElement("img");
	this._tempImg.onload = Bind(this, this.SetSize);
	
	this.SetOptions(options);
	
	this.Opacity = Math.round(this.options.Opacity);
	this.Color = this.options.Color;
	this.Scale = !!this.options.Scale;
	this.Ratio = Math.max(this.options.Ratio, 0);
	this.Width = Math.round(this.options.Width);
	this.Height = Math.round(this.options.Height);
	
	//设置预览对象
 
	//设置拖放
	this._drag = new Drag(this._layHandle, { Limit: true, onMove: Bind(this, this.SetPos), Transparent: true });
	//设置缩放
	this.Resize = !!this.options.Resize;
	if(this.Resize){
		var op = this.options, _resize = new Resize(this._layHandle, { Max: true, onResize: Bind(this, this.SetPos) });
		//设置缩放触发对象
		op.RightDown && (_resize.Set(op.RightDown, "right-down"));
		op.LeftDown && (_resize.Set(op.LeftDown, "left-down"));
		op.RightUp && (_resize.Set(op.RightUp, "right-up"));
		op.LeftUp && (_resize.Set(op.LeftUp, "left-up"));
		op.Right && (_resize.Set(op.Right, "right"));
		op.Left && (_resize.Set(op.Left, "left"));
		op.Down && (_resize.Set(op.Down, "down"));
		op.Up && (_resize.Set(op.Up, "up"));
		//最小范围限制
		this.Min = !!this.options.Min;
		this.minWidth = Math.round(this.options.minWidth);
		this.minHeight = Math.round(this.options.minHeight);
		//设置缩放对象
		this._resize = _resize;
	}
	//设置样式
	this._Container.style.position = "relative";
	this._Container.style.overflow = "hidden";
	this._layHandle.style.zIndex = 200;
	this._layCropper.style.zIndex = 100;
	this._layBase.style.position = this._layCropper.style.position = "absolute";
	this._layBase.style.top = this._layBase.style.left = this._layCropper.style.top = this._layCropper.style.left = 0;//对齐
	//初始化设置
	this.Init();
  },
  //设置默认属性
  SetOptions: function(options) {
    this.options = {//默认值
		Opacity:	70,//透明度(0到100)
		Color:		"",//背景色
		Width:		0,//图片高度
		Height:		0,//图片高度
		//缩放触发对象
		Resize:		false,//是否设置缩放
		Right:		"",//右边缩放对象
		Left:		"",//左边缩放对象
		Up:			"",//上边缩放对象
		Down:		"",//下边缩放对象
		RightDown:	"",//右下缩放对象
		LeftDown:	"",//左下缩放对象
		RightUp:	"",//右上缩放对象
		LeftUp:		"",//左上缩放对象
		Min:		false,//是否最小宽高限制(为true时下面min参数有用)
		minWidth:	50,//最小宽度
		minHeight:	50,//最小高度
		Scale:		false,//是否按比例缩放
		Ratio:		0,//缩放比例(宽/高)
		//预览对象设置
        //预览对象
		viewWidth:	0,//预览宽度
		viewHeight:	0//预览高度
    };
    Extend(this.options, options || {});
  },
  //初始化对象
  Init: function() {
	//设置背景色
	this.Color && (this._Container.style.backgroundColor = this.Color);
	//设置图片
	this._tempImg.src = this._layBase.src = this._layCropper.src = this.Url;
	//设置透明
	if(isIE){
		this._layBase.style.filter = "alpha(opacity:" + this.Opacity + ")";
	} else {
		this._layBase.style.opacity = this.Opacity / 100;
	}
	//设置预览对象
	this._view && (this._view.src = this.Url);
	//设置缩放
	if(this.Resize){
		with(this._resize){
			Scale = this.Scale; Ratio = this.Ratio; Min = this.Min; minWidth = this.minWidth; minHeight = this.minHeight;
		}
	}
  },
  //设置切割样式
  SetPos: function() {
	//ie6渲染bug
	if(isIE6){ with(this._layHandle.style){ zoom = .9; zoom = 1; }; };
	//获取位置参数
	var p = this.GetPos();
	//按拖放对象的参数进行切割
	this._layCropper.style.clip = "rect(" + p.Top + "px " + (p.Left + p.Width) + "px " + (p.Top + p.Height) + "px " + p.Left + "px)";
	idPoint.value = "(" + p.Left + "," + p.Top + ")" + "("+ (p.Left + p.Width) +","+p.Top+")" + "("+p.Left+","+(p.Top + p.Height)+")" + "("+(p.Left + p.Width)+","+(p.Top + p.Height)+")";
	porintNotes.value =  p.Left + "," + p.Top + ","+(p.Left + p.Width)+","+(p.Top + p.Height);
 
	//设置预览
 
  },
  //设置预览效果
   
  //设置图片大小
  SetSize: function() {
	var s = this.GetSize(this._tempImg.width, this._tempImg.height, this.Width, this.Height);
	//设置底图和切割图
	this._layBase.style.width = this._layCropper.style.width = s.Width + "px";
	this._layBase.style.height = this._layCropper.style.height = s.Height + "px";
	//设置拖放范围
	this._drag.mxRight = s.Width; this._drag.mxBottom = s.Height;
	//设置缩放范围
	if(this.Resize){ this._resize.mxRight = s.Width; this._resize.mxBottom = s.Height; }
  },
  //获取当前样式
  GetPos: function() {
	with(this._layHandle){
		return { Top: offsetTop, Left: offsetLeft, Width: offsetWidth, Height: offsetHeight }
	}
  },
  //获取尺寸
  GetSize: function(nowWidth, nowHeight, fixWidth, fixHeight) {
	var iWidth = nowWidth, iHeight = nowHeight, scale = iWidth / iHeight;
	//按比例设置
	if(fixHeight){ iWidth = (iHeight = fixHeight) * scale; }
	if(fixWidth && (!fixHeight || iWidth > fixWidth)){ iHeight = (iWidth = fixWidth) / scale; }
	//返回尺寸对象
	return { Width: iWidth, Height: iHeight }
  }
}
</script>
<script type="text/javascript" src="<%=contextPath%>/hse/hseOptionPage/hsePicture/Drag.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/hseOptionPage/hsePicture/Resize.js"></script>
<style type="text/css">
#rRightDown,#rLeftDown,#rLeftUp,#rRightUp,#rRight,#rLeft,#rUp,#rDown{
	position:absolute;
	background:#FFFFFF;
	border: 1px solid #333;
	width: 6px;
	height: 6px;
	z-index:500;
	font-size:0;
	opacity: 0.5;
	filter:alpha(opacity=50);
}

#rLeftDown,#rRightUp{cursor:ne-resize;}
#rRightDown,#rLeftUp{cursor:nw-resize;}
#rRight,#rLeft{cursor:e-resize;}
#rUp,#rDown{cursor:n-resize;}

#rLeftDown{left:-4px;bottom:-4px;}
#rRightUp{right:-4px;top:-4px;}
#rRightDown{right:-4px;bottom:-4px;background-color:#00F;}
#rLeftUp{left:-4px;top:-4px;}
#rRight{right:-4px;top:50%;margin-top:-4px;}
#rLeft{left:-4px;top:50%;margin-top:-4px;}
#rUp{top:-4px;left:50%;margin-left:-4px;}
#rDown{bottom:-4px;left:50%;margin-left:-4px;}

#bgDiv{width:920px; height:500px; border:0px solid #FFFFFF; position:relative;}
#dragDiv{border:1px dashed #fff; width:100px; height:60px; top:50px; left:50px; cursor:move; }
</style>


<title>图像信息：</title>
</head>
 
<body class="bgColor_f3f3f3"   onload="page_init();" >       
<div id="list_table" >
	<div id="inq_tool_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png">
		    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td>&nbsp;</td>
				    <auth:ListButton functionId="" id="bc" css="bc" event="onclick='toAdd()'" title="保存"></auth:ListButton>
				  </tr>
				</table>
			</td>
		    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
		</table>
   </div>
	   <div id="table_box"  style="height:480px;" >
	   <table width="100%" height="480" border="0" cellpadding="0" cellspacing="0" class="tab_info" id="queryRetTable">
	   <tr class="bt_info" > 
	       <td colspan="5" align="center" > 
			        <div id="bgDiv" >
				        <div id="dragDiv"   >
				          <div id="rRightDown"> </div>
				          <div id="rLeftDown"> </div>
				          <div id="rRightUp"> </div>
				          <div id="rLeftUp"> </div>
				          <div id="rRight"> </div>
				          <div id="rLeft"> </div>
				          <div id="rUp"> </div>
				          <div id="rDown"></div>
				        </div>
			      </div> 
 
				  	</td>
		</tr>
		 <tr class="bt_info" style="display:none" >
			  	<td colspan="5" >  
			  	<input id="idPoint" type="text" style="width:400px;"/>
				<input id="porintNotes" type="text" style="width:400px;"/>
			  	</td>
		  </tr>
 </table>
 </div>
 </div> 
 <div id="bireportDiv" style="display:block;height:800px;" >
 <iframe id ="bireport" src="" marginheight="0" marginwidth="0" style="height:100%;width:100%;"></iframe>	
 </div >
</body>
 
<script type="text/javascript"> 
	// $("#bireport").css("height",$(window).height());
	cruConfig.contextPath =  "<%=contextPath%>";	 
	cruConfig.cdtType = 'form';	 
	var  org_id="<%=father_id%>";
	var  org_subjection_id="<%=org_subjection_id%>";
	var  org_type="<%=org_type%>";
	var  doc_main_id="<%=doc_main_id%>";
	var  org_sub_id="<%=org_sub_id%>";
	
	function page_init(){	
		if(org_type=='2'){	
			//根据查询（基层单位）登陆用户的所属单位，在BGP_HSE_PICTURE_MAIN表中查询出单位图片
			var querySql = " select t.pmain_id, t.ucm_id, t.creator_id, e.employee_name from BGP_HSE_PICTURE_MAIN t left join comm_human_employee e on t.creator_id = e.employee_id  and e.bsflag = '0'   where  t.bsflag='0' and t.spare1='1'  and  t.org_id='"+org_sub_id+"'  ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			var datas = queryRet.datas;		
			if(queryRet.returnCode=='0'){
				if(datas != null && datas != ''  ){	
		              var ic = new ImgCropper("bgDiv", "dragDiv","<%=contextPath%>/doc/downloadDocByUcmId.srq?emflag=0&docId="+datas[0].ucm_id, {
				 	//	Width: 750, Height: 500, 
		            	//Color: "#000",
				 		Resize: true,
				 		Right: "rRight", Left: "rLeft", Up:	"rUp", Down: "rDown",
				 		RightDown: "rRightDown", LeftDown: "rLeftDown", RightUp: "rRightUp", LeftUp: "rLeftUp",
				 	})  
					
				}
			} 
			
		}else if(org_type=='1'){
			//是单位用户，在BGP_HSE_PICTURE_MAIN表中查询出机关图片
			var querySql = " select t.pmain_id, t.ucm_id, t.creator_id, e.employee_name from BGP_HSE_PICTURE_MAIN t left join comm_human_employee e on t.creator_id = e.employee_id  and e.bsflag = '0'   where  t.bsflag='0' and t.spare1='0'  ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			var datas = queryRet.datas;		
			if(queryRet.returnCode=='0'){
				if(datas != null && datas != ''  ){	
		              var ic = new ImgCropper("bgDiv", "dragDiv","<%=contextPath%>/doc/downloadDocByUcmId.srq?emflag=0&docId="+datas[0].ucm_id, {
				 	//	Width: 750, Height: 500, 
		            //	Color: "#000",
				 		Resize: true,
				 		Right: "rRight", Left: "rLeft", Up:	"rUp", Down: "rDown",
				 		RightDown: "rRightDown", LeftDown: "rLeftDown", RightUp: "rRightUp", LeftUp: "rLeftUp",
				 	})  
					
				}
			}
		}else if(org_type=='0'){
			//查询机关用户图片
			var querySql = " select t.pmain_id, t.ucm_id, t.creator_id, e.employee_name from BGP_HSE_PICTURE_MAIN t left join comm_human_employee e on t.creator_id = e.employee_id  and e.bsflag = '0'   where  t.bsflag='0' and t.spare1='0'  and  t.org_id like '%"+org_id+"%' and t.org_subjection_id like '%"+org_subjection_id+"%' ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			var datas = queryRet.datas;		
			if(queryRet.returnCode=='0'){
				if(datas != null && datas != ''  ){	
				    //<img src="http://www.dreamdu.com/images/html_table.png" id="human_image"    />
				    //document.getElementById("bgDiv").src = "<%=contextPath%>/doc/downloadDocByUcmId.srq?emflag=0&docId="+datas[0].ucm_id;
					//document.getElementById("idContainer").style.backgroundImage = "url(<%=contextPath%>/doc/downloadDocByUcmId.srq?emflag=0&docId="+datas[0].ucm_id+")";
					//document.getElementById("human_image").src = "http://10.88.2.241/hr_photo/"+employee_cd.substr(0,5)+"/"+employee_cd+".JPG";
				
					var ic = new ImgCropper("bgDiv", "dragDiv","<%=contextPath%>/doc/downloadDocByUcmId.srq?emflag=0&docId="+datas[0].ucm_id, {
				 		//Color: "#000",
				 		Resize: true,
				 		Right: "rRight", Left: "rLeft", Up:	"rUp", Down: "rDown",
				 		RightDown: "rRightDown", LeftDown: "rLeftDown", RightUp: "rRightUp", LeftUp: "rLeftUp",
				 	})  
					
				}
			}
		}
		
	}
	
	function toAdd(){	
	    var porintNotes= document.getElementById("porintNotes").value;
	//tree页面保存单位图片后，跳转到此页面，根据orgid和orgSubId查询的到id	
	    if(org_type=='1'){	//判断是单位用户	    	
	    	if (doc_main_id != 'null' && doc_main_id != '' ){			
				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
				var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_PICTURE_MAIN&JCDP_TABLE_ID='+doc_main_id+'&notes='+porintNotes
				+'&updator_id=<%=userName%>&modifi_date=<%=curDate%>';		  
				var retObject = syncRequest('Post',path,encodeURI(encodeURI(submitStr)));   
				var ids=retObject.entity_id;
	 
				if(ids != null && ids!=''){
					alert("设置成功");
					  document.getElementById("inq_tool_box").style.display="none"; 
					  document.getElementById("table_box").style.display="none"; 
					 document.getElementById("bireport").src="<%=contextPath %>/hse/hseOptionPage/hsePicture/oldOne.jsp?father_id=<%=father_id %>&sub_id=<%=sub_id %>&org_subjection_id=<%=org_subjection_id%>&org_type=<%=org_type%>&org_sub_id=<%=org_sub_id%>&second_org=<%=second_org%>";
					// parent.mainRightframe.page_init();
				}else {
					alert("设置失败");
				}		
				
			}else{
				alert("请先上传单位图片,后维护信息!");
			} 
			
	    	
	    }else if (org_type=='2'){ //判断是基层单位用户
	    	
	    	if (doc_main_id != 'null' && doc_main_id != '' ){			
				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
				var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_PICTURE_MDETAIL&JCDP_TABLE_ID='+doc_main_id+'&notes='+porintNotes
				+'&updator_id=<%=userName%>&modifi_date=<%=curDate%>';		  
				var retObject = syncRequest('Post',path,encodeURI(encodeURI(submitStr)));   
				var ids=retObject.entity_id;
	 
				if(ids != null && ids!=''){
					alert("设置成功");
					  document.getElementById("inq_tool_box").style.display="none"; 
					  document.getElementById("table_box").style.display="none"; 
					 document.getElementById("bireport").src="<%=contextPath %>/hse/hseOptionPage/hsePicture/oldOne.jsp?father_id=<%=father_id %>&sub_id=<%=sub_id %>&org_subjection_id=<%=org_subjection_id%>&org_type=<%=org_type%>&org_sub_id=<%=org_sub_id%>&second_org=<%=second_org%>";
					// parent.mainRightframe.page_init();
				}else {
					alert("设置失败");
				}		
				
			}else{
				alert("请先上传基层单位图片,后维护信息!");
			} 
	    	
	    	
	    }
	    
		
	}
  //	$("#table_box").css("height",$(window).height()-40);
	// $("#idContainer").css("height",$(window).height()-$("#inq_tool_box").height()-10);
</script>
 

</html>

