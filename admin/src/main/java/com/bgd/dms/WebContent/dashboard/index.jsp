<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Portal - jQuery EasyUI</title>
	<link rel="stylesheet" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
	<style>
		#sortable { list-style-type: none; margin: 0; padding: 0; }
		#sortable li { margin: 3px 3px 3px 0; padding: 1px; float: left; width: 300px; height: 200px; font-size: 4em; text-align: center; }
		#accordion h4 { height:35px;padding:0px; }
		#accordion h4 a { font-family: 微软雅黑, Arial, Helvetica, sans-serif; height:25px; line-height:25px; padding:5px;padding-left:30px; }
		.acco2Div { padding-top: 5px; padding-bottom: 5px; padding-left:30px; padding-right:10px; border: 1px solid #aaaaaa; }
		.operDiv { height:20px; border-bottom: 1px solid #d3d3d3; font-family: 微软雅黑, Arial, Helvetica, sans-serif; font-size: 15px; }
		.panelDiv { height:180px; overflow: auto; }
		.closeBtn { font-size:10px;position:relative;float:right; }
		.dragDiv { width: 180px; height: auto; padding: 5px; margin: 2px; border: 1px solid #aaaaaa; cursor: move; background: rgb(243, 243, 243)}
	</style>
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath %>/js/rt/rt_list.js"></script> 
	<script type="text/javascript" src="<%=contextPath %>/js/rt/rt_base.js"></script> 
	<script src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
	<script src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
	<script src="<%=contextPath %>/js/ui/jquery.ui.accordion.js"></script>
	<script src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
	<script src="<%=contextPath %>/js/ui/jquery.ui.sortable.js"></script>
	<script src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
	<script src="<%=contextPath %>/js/ui/jquery.ui.droppable.js"></script>
	<script src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
	
	<script>

		cruConfig.contextPath="<%=contextPath%>";
		var boardId="";
		var leftDataLoaded=false;
		
		$(function(){

			// 添加仪表盘
			addPanel();

			// 初始化排序
			$( "#sortable" ).sortable( { disabled: true } );
			$( "#sortable" ).disableSelection();


			$("#accordion").css("width",0);
			$("#accordion").css("height",$(window).height()-10);

			$("#btn_div").css("left",280);
			$("#btn_div").css("width",$(window).width()-280);
			$("#btn_div").css("height",30);
			
			$("#sortable").css("width",$(window).width()-280);
			$("#sortable").css("height",$(window).height()-30-10);
			$("#sortable").css("left",140);
			$("#sortable").css("top",35);
		});

		
		function addPanel(){
			var ret = jcdpCallService("DashboardSrv", "readUserDashboard", "boardType=0");
			var datas = ret.datas;

			// 设置以前保存的panel
			if(datas!=undefined){
				for(var panelNum=0;panelNum<datas.length;panelNum++){
					boardId = datas[panelNum].board_id;
					var li = $('<li id="dropPanel_'+datas[panelNum].menu_id+'" class="ui-state-default" menuId="'+datas[panelNum].menu_id+'"></li>');

					li.css('width',datas[panelNum].width);
					li.css('height',parseInt(datas[panelNum].height)+20);
					
					var operDiv = $('<div class="operDiv">'+datas[panelNum].menu_name+'</div>');
					li.append(operDiv);
					var div = $('<div class="panelDiv"></div>');
					div.attr('menuId',datas[panelNum].menu_id);
					div.css('height',datas[panelNum].height);
					li.append(div);
					$( "#sortable" ).append(li);
					//alert("<%=contextPath%>/"+datas[panelNum].menu_url);
					div.load("<%=contextPath%>"+datas[panelNum].menu_url);

					// 设置为可拖动改变大小
					li.resizable({ 
						disabled: true,
						autoHide: true, 
						containment: 'parent',
						stop: function(event, ui){
							var liHeight = parseInt(ui.size.height);
							var panelHeight = liHeight - 21;
							var offsetTop = $(this).offset().top;
							
							$(this).parent().children().each(function(){
								if($(this).offset().top==offsetTop){
									$(this).css("height", liHeight);
									$(this).children(".panelDiv").css("height", panelHeight);
								}
							});
						}
					});
				}
			}

			// 设置为可以从左侧列表里拖放panel
			$( "#sortable" ).droppable({
				drop: function( event, ui ) {
					if(ui.draggable.attr('id').substring(0,4)=='drop') return;
					var li = $('<li id="dropPanel_'+ui.draggable.attr('menuId')+'" class="ui-state-default" menuId="'+ui.draggable.attr('menuId')+'"></li>');
					var operDiv = $('<div class="operDiv">'+ui.draggable.attr('title')+'</div>');
					operDiv.append($("<a id='close_btn"+ui.draggable.attr('menuId')+"' href='#' class='closeBtn' onclick='closePanel(this)'>关闭</a>"));
					li.append(operDiv);
					
					var div = $('<div class="panelDiv"></div>');
					div.attr('menuId',ui.draggable.attr('menuId'));
					li.append(div);
					$( "#sortable" ).append(li);
					div.load("<%=contextPath%>/"+ui.draggable.attr('url'));

					// disable draggable
					ui.draggable.draggable({ disabled: true });

					// 设置为可拖动改变大小
					li.resizable({ 
						autoHide: true, 
						containment: 'parent',
						stop: function(event, ui){
							var liHeight = parseInt(ui.size.height);
							var panelHeight = liHeight - 21;
							var offsetTop = $(this).offset().top;
							
							$(this).parent().children().each(function(){
								if($(this).offset().top==offsetTop){
									$(this).css("height", liHeight);
									$(this).children(".panelDiv").css("height", panelHeight);
								}
							});
						}
					});
				}
			});
		}
		
		function loadLeftData(){
			$.post("<%=contextPath%>/queryMenus.srq?parentNodeId=40288a8138dfbe030138dfc0159a0002"
					,{}
					,function(data, textStatus){
						setSenondMenu(data);
						leftDataLoaded = true;
					}
					,"json"
			);
		}	

		function setSenondMenu(data){
			
			var secondmenu = eval(data).nodes;

			for(var i=0;i<secondmenu.length;i++){
				var h3 = $('<h4><a href="#" onclick=setThirdMenu("'+secondmenu[i].id+'",this)>'+secondmenu[i].name+'</a></h4>');
				var div = $('<div id="div'+secondmenu[i].id+'" class="acco2Div"></div>');
				
				$( "#accordion" ).append(h3);
				$( "#accordion" ).append(div);
				
				//setThirdMenu(secondmenu[i].id);

			}
			$( "#accordion" ).accordion({
				collapsible: true,
				autoHeight: false,
				active: false
			});
		}

		function setThirdMenu(parentNodeId,a){
				if($(a).attr('dataLoaded')) return;
				// 加载三级菜单
				$.post("<%=contextPath%>/queryMenus.srq?parentNodeId="+parentNodeId
					,{}
					,function(data, textStatus){
						var thirdmenu = eval(data).nodes;
						
						for(var j=0;j<thirdmenu.length;j++){

							if(thirdmenu[j].isLeaf=="1"){
								/*var div= $("<div class='dragDiv' id='dragPanel_"+thirdmenu[j].id+"' menuId='" + thirdmenu[j].id + "' title='"+thirdmenu[j].name+"' url='"+thirdmenu[j].url+"'><span style='font-family: 微软雅黑, Arial, Helvetica, sans-serif;'>"+thirdmenu[j].name+"</span></div>");
								$('#div'+parentNodeId).append(div);
	
								div.draggable(
										{
											appendTo: "body",
											helper: "clone"
										}
								);
								
								// 判断是否已经配置到仪表盘
								if($("#dropPanel_"+thirdmenu[j].id).get(0)){
									div.draggable(
											{
												 disabled: true 
											}
									);
								}*/
								addThirdMenu(thirdmenu[j], parentNodeId);
								
							}else{

								var div = $("<div style='width:120%'></div>");

								$('#div'+parentNodeId).append(div);
								
								var h = $("<h4><a href='#' menuId='"+thirdmenu[j].id+"' onclick='setEndMenu(this)'>"+thirdmenu[j].name+"</a></h4>");
								div.append(h);

								var div0 = $("<div id='div"+thirdmenu[j].id+"' class='acco2Div' style='padding-left:0px;padding-right:1px;'></div>");
								div.append(div0);
								
								/*var div1 = $("<div class='dragDiv'>456</div>");
								div.append(div1);
								
								div1.draggable(
										{
											appendTo: "body",
											helper: "clone"
										}
								);
								*/
								div.accordion({
									collapsible: true,
									autoHeight: false,
									active: false
								});
							}
						}

						$(a).attr('dataLoaded',true);
					}
					,"json"
				);
		}

		function setEndMenu(aaa){
			if($(aaa).attr('dataLoaded')) return;
			$.post("<%=contextPath%>/queryMenus.srq?parentNodeId="+aaa.menuId
					,{}
					,function(data, textStatus){
						var endmenu = eval(data).nodes;
						for(var j=0;j<endmenu.length;j++){
							addThirdMenu(endmenu[j], aaa.menuId);
						}
					}
					,"json"
			);

			$(aaa).attr('dataLoaded',true);

			//$(aaa).children('div').css('width',140);
		}

		function addThirdMenu(thirdmenu, parentNodeId){
			var div= $("<div class='dragDiv' id='dragPanel_"+thirdmenu.id+"' menuId='" + thirdmenu.id + "' title='"+thirdmenu.name+"' url='"+thirdmenu.url+"'><span style='font-family: 微软雅黑, Arial, Helvetica, sans-serif;'>"+thirdmenu.name+"</span></div>");
			$('#div'+parentNodeId).append(div);

			div.draggable(
					{
						appendTo: "body",
						helper: "clone"
					}
			);
			
			// 判断是否已经配置到仪表盘
			if($("#dropPanel_"+thirdmenu.id).get(0)){
				div.draggable(
						{
							 disabled: true 
						}
				);
			}
		}
		
		function save(){
			//alert($("#sortable > li > div").length);
			var params = "boardId="+boardId+"&boardType=0&boardName=个人仪表盘";
			var i=0;
			$("#sortable > li > div").each(function(){
				if($(this).attr('menuId')==undefined) return;
				
				params += "&menuId"+i+"="+$(this).attr('menuId');
				params += "&height"+i+"="+$(this).css('height').substring(0,$(this).css('height').length-2);
				params += "&width"+i+"="+$(this).css('width').substring(0,$(this).css('width').length-2);

				i++;
			});

			params += "&panelNum="+i;

			var ret = jcdpCallService("DashboardSrv", "saveUserDashboard", params);
			if(ret.returnCode=="0") alert("保存成功");

			boardId = ret.boardId;
			
			cancel();
		}
		function config(){
			$("#save_btn").show();
			$("#cancel_btn").show();
			$("#config_btn").hide();
			$("#accordion").css("width",260);
			$("#accordion").css("display","");
			//$("#sortable").css("width",$(window).width()-280);
			$("#sortable").css("left",280);
			// 加载左侧选择数据
			if(!leftDataLoaded){
				loadLeftData();
			}
			var i=0;
			// 每个panel添加关闭按钮
			$("#sortable > li > .operDiv").each(function(){
				$(this).append($("<a id='close_btn"+i+"' href='#' class='closeBtn' onclick='closePanel(this)'>关闭</a>"));
				i++;
			});
			// 每个panel可以拖动改变大小
			$("#sortable > li").each(function(){
				$(this).resizable( "option", "disabled", false );
			});
			// 可以拖动来设置panel的位置
			$( "#sortable" ).sortable( "option", "disabled", false );
		}
		function cancel(){
			$("#save_btn").hide();
			$("#cancel_btn").hide();
			$("#config_btn").show();
			$("#accordion").css("width",0);
			$("#accordion").css("display","none");
			//$("#sortable").css("width",$(window).width());
			$("#sortable").css("left",140);
			// 移除关闭按钮
			$("#sortable > li > div > a[id^=close_btn").remove();
			// 取消拖动改变大小
			/*$("#sortable > li").each(function(){
				$(this).resizable( "option", "disabled", true );
			});*/
			// 取消拖动改变位置
			$( "#sortable" ).sortable( "option", "disabled", true );
		}
		function closePanel(close_btn){
			var li = $(close_btn).parent().parent();
			li.remove();

			$("#dragPanel_"+li.attr("menuId")).draggable( "option", "disabled", false );
		}
	</script>
</head>
<body style="overflow:hidden;">

	<div id="accordion" style="overflow:auto; width:0px; float: left;">
		
	</div>

	<div id="btn_div" style="float: right; text-align: right;">
		<input type="button" value="保存" onclick="save()" id="save_btn" style="display:none;"/>
		<input type="button" value="取消" onclick="cancel()" id="cancel_btn" style="display:none;"/>
		<input type="button" value="设置" onclick="config()" id="config_btn"/>
	</div>
	
	<ul id="sortable" style="position:absolute; overflow: auto;">
	</ul>

</body>
</html>
