<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String roleId = request.getParameter("roleId");
	String creatorId = user.getUserId();
	String isUser = "1";
	if(roleId!=null && !roleId.trim().equals("")){
		creatorId=roleId; 
		isUser = "0";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>dashboard</title>
	<style>
		.boardbody {
			
			overflow-y: auto;
			overflow-y: auto\9;
			overflow-y: auto\0;
			*overflow-y: hidden;
			_overflow-y: auto;
			
			overflow-x: auto; margin-left: 10px; margin-top:1px;background: white;
		}
		.operDiv { height:20px; font-family: 微软雅黑, Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; color: #0f6ab2; background: url(images/titlebg.jpg); border : 1px solid #6dabe6; border-bottom:0px; padding-left:10px;}
		.operDiv A { color: #0f6ab2; float: right ; margin-left : 2px ; margin-right : 2px;
		margin-top:0px;
		margin-top:0px\9;
		margin-top:0px\0;
		*margin-top:-16px;
		_margin-top:0px;
		}
		.contentDiv { padding: 1px; padding-top:0px; padding-bottom:0px;height:100%; margin: 0px; margin-top:-1px; border: font-family: 微软雅黑, Arial, Helvetica, sans-serif; font-size: 15px; overflow: auto;  border : 1px solid #6dabe6; border-top:0px;}
		.closeBtn { font-size:10px;position:relative;float:right; }
		#boardBar { position: fixed; right: 225px; top: 0px; width:auto; height:auto; padding: 0px; border:1px solid #8B8386; border-bottom: 0px; text-align: center; background: white; z-index: 800; font-family: 微软雅黑, Arial, Helvetica, sans-serif; font-size: 12px;}
		#boardBar div { float:top ; border-bottom: 1px solid #8B8386; padding: 3px; margin-bottom: 0px; height: 20px; cursor: pointer;  width: 70px;}
	</style>
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath %>/js/rt/rt_list.js"></script> 
	<script type="text/javascript" src="<%=contextPath %>/js/rt/rt_base.js"></script> 
	<script type="text/javascript" src="<%=contextPath %>/js/json.js"></script>
	<script type="text/javascript" src="<%=contextPath %>/js/gms_list.js"></script> 
</head>
<body class="boardbody">

<%if(isUser.equals("0")){ %>
<div id="boardBarCtrl" style="background: url(<%=contextPath %>/images/page_aside_scroll_btn_n2.png); position: fixed; top: 0x; left: 0px; width: 7px; height: 45px; z-index :100;" onmouseover='showToolbar()'></div>
<%} %>

<script type="text/javascript">
	var resizeBarColor="#FFD700";//拉伸线的颜色
	var operDivColor="#D1EEEE";//单元格标题行的颜色
	var selectedOperDivColor="#EB8149";//已选中的单元格标题行的颜色
	
	var selectedCell;
	var selectedBoard;
	var selectedCol;
	
	var flag=0;
	var id=1;

	var jianju = 6;
	
	var boardId="";
	
	var pos = [];

	var boardNum=0;

	$(function(){
		doResize();

		initBoard();
		
	});

	var saveBoardWidth = 0;
	function doResize(){
		var h = $(window).height();
		var w = $(window).width();

		$('#toolbar').css('height', 30);
		$('#toolbar').css('width', w-30);

		saveBoardWidth = w-30;
		
		initPosArray();
		

	}
	function initPosArray(){
		pos = [];
		pos["resizeboardbar_-1"] = {
				left : 5
				, top : 5
				, right : 0
				, bottom : 0
				, width : $(window).width() - 30
				, height : 0
		};
		with (pos["resizeboardbar_-1"]) {
				right = left + width;
				bottom = top + height;
		}
	}

	function initBoard(){
		cruConfig.contextPath="<%=contextPath%>";
		var ret = jcdpCallService("DashboardSrv", "readUserDashboard", "boardType=0&creatorId=<%=creatorId%>&isUser=<%=isUser%>");
		var datas = ret.datas;
		if(ret.boardId!=undefined){
			boardId = ret.boardId;
		}
		
		// 设置以前保存的board
		if(datas!=undefined){
			var tempBoardIndex=-1;
			var tempColIndex=-1;
			var tempCellIndex=-1;

			var curBoard;
			var curCol;
			var curLeft=0;;
			
			// 缩放比例
			var boardOldWidth=ret.boardOldWidth;
			var radio = 1;
			if(boardOldWidth!=""){
				radio = parseInt(pos["resizeboardbar_-1"].width)/parseInt(boardOldWidth);
			}
			
			for(var panelNum=0;panelNum<datas.length;panelNum++){

				var cell = datas[panelNum];

				var boardIndex = cell.board_index;

				if(boardIndex > tempBoardIndex){
					//var boardWidth = 
					curBoard = addRows(Math.floor(parseInt(cell.board_height)*radio), true);
					tempBoardIndex = boardIndex;
					tempColIndex = -1;
					curLeft=0;
				}

				var colIndex = cell.col_index;
				if(colIndex > tempColIndex){
					//board, newColLeft, newColWidth, menuId, menuName, menuUrl
					var curWidth = (parseInt(cell.col_width)+(jianju)+2)*radio;
					curCol = addCols(curBoard, curLeft, (curWidth), "", "", "", true);
					tempColIndex = colIndex;
					curLeft += curWidth;
				}
				// 创建单元格
				addCells(curCol, cell.menu_id, cell.portlet_name, cell.portlet_url);
			}
			
		}
		closeToolbar();
	}

	function selectCell(cell){
		if(selectedCell!=null){
			selectedCell.css("background", "url(images/titlebg.jpg)");
		}
		selectedCell = $(cell);
		selectedCell.css("background", "url(images/titlebg2.jpg)");

		selectedCol = selectedCell.parent();
		selectedBoard = selectedCol.parent();

	}

	// 添加行
	function addRows(boardHeight, initBoard){

		freshDivPos();
	
		var jwin = $(window);
		
		var newBoard = $('<div id="board_'+boardNum+'"></div>');

		var lastBarId="resizeboardbar_-1";
		
		var resizeboardbars = $("div[id^=resizeboardbar_]");
		if(resizeboardbars.size()>0){
			lastBarId=resizeboardbars.eq(resizeboardbars.size()-1).attr("id");
		}
		
		var prebar = pos[lastBarId];
		newBoard.css("float", "top");
		newBoard.css("width", prebar.width);
		newBoard.css("height", boardHeight);

		if(selectedBoard!=null){
			selectedBoard.next().after(newBoard);
		}else{
			$(document.body).append(newBoard);
		}
		
		pos['board_'+boardNum] = {
				left : newBoard.offset().left
				, top : newBoard.offset().top
				, width : newBoard.width()
				, height : newBoard.height()
				, right : 0
				, bottom : 0
		};
		
		with ( pos['board_'+boardNum] ){
			right : left + width;
			bottom : top + height;
		}

		if(!initBoard){
			addCols(newBoard, -1, -1, "", "", "");
		}
		
		var resizeBar = $('<div id="resizeboardbar_'+boardNum+'"></div>');
		resizeBar.css("float", "top");
		resizeBar.css("cursor", "n-resize");
		resizeBar.css("width", newBoard.width());
		resizeBar.css("height", jianju);
		resizeBar.css("background", "#FFD700");

		newBoard.after(resizeBar);

		boardResize(resizeBar.get(0));

		pos['resizeboardbar_'+boardNum] = {
				left : resizeBar.offset().left 
				, top : resizeBar.offset().top
				, width : resizeBar.width()
				, height : resizeBar.height()
				, right : 0
				, bottom : 0
		};
		with ( pos['resizeboardbar_'+boardNum] ) {
			right  = left + width;
			bottom = top + height;
		}
	
		boardNum++;

		return newBoard;
	}

	function boardResize(el) {

		var barId = $(el).attr("id");
		var barIndex = parseInt(barId.substring(barId.indexOf("_")+1));
		var board = $("#board_"+barIndex);
		var boardHeight = 0;

		var $el = $(el);

		// 鼠标开始拖动的位置
		var disY = 0;
		//el.top = el.offsetTop;
		
        //鼠标按下事件
        $(el).mousedown(function (e)
        {
            disY = e.clientY;
            //在支持 setCapture 做些东东
            el.setCapture ? (
                //捕捉焦点
                el.setCapture(),
                //设置事件
                el.onmousemove = function (ev)
                {
                    mouseMove(ev || event)
                },
                el.onmouseup = mouseUp
            ) : (
                //绑定事件
                $(document).bind("mousemove", mouseMove).bind("mouseup", mouseUp)
            )
            
            //防止默认事件发生
            e.preventDefault();

                freshDivPos();
        });
        //移动事件
        function mouseMove(e)
        {

            var curY = e.clientY;

            // 设置拖动条的位置
       		$el.css("top", pos[$el.attr("id")].top + curY - disY);

            // 设置当前行的高度
			board.css("height", pos[board.attr("id")].height + curY - disY);

            // 设置当前行内每列的高度
			board.children("div[id^=col_]").each(function(){
				$(this).css("height", ( pos[$(this).attr("id")].height + curY - disY ) );
			});

			board.children("div[id^=resizecolbar_]").each(function(){
				//$("#console").html( "height = " + (pos[$(this).attr("id")].height + curY - disY));
				$(this).css("height", ( pos[$(this).attr("id")].height + curY - disY ) );
			});

			board.find("div[id^=content_][id$=0]").each(function(){
				$(this).css("height", ( pos[$(this).attr("id")].height + curY - disY ) );
			});
        }
        //停止事件
        function mouseUp()
        {
            //在支持 releaseCapture 做些东东
            el.releaseCapture ? (
            //释放焦点
            el.releaseCapture(),
            //移除事件
            el.onmousemove = el.onmouseup = null
        ) : (
            //卸载事件
            $(document).unbind("mousemove", mouseMove).unbind("mouseup", mouseUp)
        )
       
       		 freshDivPos();
        }
	}

	function freshDivPos(){

		initPosArray();
        $("div").each(function(){
			var div = $(this);
			pos[div.attr("id")] = {
					left : div.offset().left
					, top : div.offset().top
					, width : div.width()
					, height : div.height()
					, bottom : 0
					, right : 0
			};
			with ( pos[div.attr("id")] ){
				bottom = top + height;
				right = left + width;
			}
		});   

	}
	// 按列拆分
	function addCols(board, newColLeft, newColWidth, menuId, menuName, menuUrl, initBoard){
		if(board==null){
			board = selectedBoard;
		}

		var boardId = board.attr("id");
		var boardIndex = boardId.substring(boardId.indexOf("_")+1);

		var curCols = board.children("div[id^=col_]");

		var lastColNum=0;
		
		if(curCols.size()>0){

			var lastCol = curCols.eq( curCols.size()-1 );

			var lastColId = lastCol.attr("id");

			lastColNum = lastColId.substring( lastColId.lastIndexOf("_") + 1 );
		}
		
		if(newColLeft==-1){
			if(curCols.size()>0){

				var lastcol = curCols.eq(curCols.size()-1);

				newColWidth = lastcol.width()/2;

				lastcol.css("width", lastcol.width() - newColWidth);

			}else{
				newColLeft = 0;
				newColWidth = board.width();
			}
		}

		var newCol = $("<div></div>");
		newCol.attr("id", "col_"+boardIndex+"_"+(parseInt(lastColNum)+1));
		
		newCol.css("float", "left");
		newCol.css("width", newColWidth-jianju-2);
		newCol.css("height", board.height()-2);
		//newCol.css("border", "1px solid #6dabe6");
		//newCol.css("filter" ,"progid:DXImageTransform.Microsoft.Shadow(color=#909090,direction=120,strength=5");
		
		board.append(newCol);

		pos[newCol.attr("id")] = {
				left : newCol.offset().left 
				, top : newCol.offset().top
				, width : newCol.width()
				, height : newCol.height()
				, right : 0
				, bottom : 0
		};
		with ( pos[newCol.attr("id")] ) {
			right  = left + width;
			bottom = top + height;
		}

		var resizeBar = $('<div id="resizecolbar_'+boardIndex+'_'+ (parseInt(lastColNum)+1) + '"></div>');
		resizeBar.css("float", "left");
		resizeBar.css("cursor", "w-resize");
		resizeBar.css("width", jianju);
		resizeBar.css("height", board.height());
		resizeBar.css("background", "#FFD700");

		board.append(resizeBar);

		pos[resizeBar.attr("id")] = {
				left : resizeBar.offset().left 
				, top : resizeBar.offset().top
				, width : resizeBar.width()
				, height : resizeBar.height()
				, right : 0
				, bottom : 0
		};
		with ( pos[resizeBar.attr("id")] ) {
			right  = left + width;
			bottom = top + height;
		}

		colResize(resizeBar.get(0));

		if(!initBoard){
			addCells(newCol, menuId, menuName, menuUrl);
		}
		
		return newCol;
	}

	function colResize(el){

		var $el = $(el);
		
		var barId = $el.attr("id");
		var tempId = barId.substring(barId.indexOf("_")+1);
		var boardIndex = parseInt( tempId.substring(0, tempId.indexOf("_")) );
		var colIndex = parseInt( tempId.substring(tempId.indexOf("_") + 1) );
		var board = $("#board_"+boardIndex);
		var boardHeight = 0;

		// 鼠标开始拖动的位置
		var disX = 0;

		//鼠标按下事件
        $(el).mousedown(function (e)
        {
			disX = e.clientX;
            //在支持 setCapture 做些东东
            el.setCapture ? (
                //捕捉焦点
                el.setCapture(),
                //设置事件
                el.onmousemove = function (ev)
                {
                    mouseMove(ev || event)
                },
                el.onmouseup = mouseUp
            ) : (
                //绑定事件
                $(document).bind("mousemove", mouseMove).bind("mouseup", mouseUp)
            )
            
            //防止默认事件发生
            e.preventDefault();

                freshDivPos();
        });

      //移动事件
        function mouseMove(e)
        {

    	  var curX = e.clientX;

    	  curX -= (jianju+3);
    	  
    	  $el.css("left", curX);
 
    	  var skipX = curX - disX;
    	  
			var leftCol = $("#col_"+boardIndex+"_"+colIndex);
	
			leftCol.css("width", pos[leftCol.attr("id")].width  + skipX);

			var rightCol = $("#col_"+boardIndex+"_"+(colIndex+1));
			if(rightCol.size()>0){
				rightCol.css("width",pos[rightCol.attr("id")].width -skipX);
			}
    
        }
      //停止事件
        function mouseUp()
        {
            //在支持 releaseCapture 做些东东
            el.releaseCapture ? (
            //释放焦点
            el.releaseCapture(),
            //移除事件
            el.onmousemove = el.onmouseup = null
        ) : (
            //卸载事件
            $(document).unbind("mousemove", mouseMove).unbind("mouseup", mouseUp)
        )
       
       		 freshDivPos();
        }

	}

	// 增加单元格
	function addCells(col, menuId, menuName, menuUrl){
	    
		var contentDivs = col.children("div[id^=content_]");
		var newIndex = 0;
		var newHeight = col.height();
		
		if(contentDivs.size()>0){
			var lastContentDiv = contentDivs.eq(contentDivs.size()-1);
			var lastContentDivId = lastContentDiv.attr("id");
			var lastContentDivIndex = lastContentDivId.substring(lastContentDivId.lastIndexOf("_")+1);
			newIndex = parseInt(lastContentDivIndex)+1;
			newHeight = Math.floor((lastContentDiv.height()+20+1-jianju)/2);
			lastContentDiv.css("height", lastContentDiv.height() - newHeight - jianju);
			// 增加拖动条

			var resizeBar = $('<div id="resizecellbar'+lastContentDivId.substring(lastContentDivId.indexOf("_")) + '"></div>');
			resizeBar.css("float", "top");
			resizeBar.css("cursor", "n-resize");
			resizeBar.css("height", jianju);
			//resizeBar.css("width", board.height());
			resizeBar.css("background", "#FFD700");

			col.append(resizeBar);	

			cellResize(resizeBar.get(0));
		}
		 
		var colId = col.attr("id");
		var tempId = colId.substring(colId.indexOf("_")+1);
		
		var operDiv = $("<div class='operDiv' id='oper_" + tempId + "_" + newIndex + "'><span>"+ menuName + "</span><a href='#' onclick='closeContent(this);return false;'>关闭</a><a href='#' onclick='selectContent(this);return false;'>设置</a></div>");
		col.append(operDiv);
		operDiv.bind("click", function(){selectCell(this)});

		var contentDiv = $("<div class='contentDiv' id='content_" + tempId + "_" + newIndex + "' menuId='" + menuId + "'></div>");
		col.append(contentDiv);
		contentDiv.css("height", newHeight -20 -1);

		if(menuUrl!=""){
			contentDiv.load("<%=contextPath%>"+menuUrl);
		}
	}

	function cellResize(el) {

		var barId = $(el).attr("id");
		var barIndex = barId.substring(barId.indexOf("_")+1);
		var cell = $("#content_"+barIndex);

		var $el = $(el);

		var nextCell = $();
		
		// 鼠标开始拖动的位置
		var disY = 0;
		//el.top = el.offsetTop;
		
        //鼠标按下事件
        $(el).mousedown(function (e)
        {
            disY = e.clientY;
            nextCell = $el.next().next();
            //在支持 setCapture 做些东东
            el.setCapture ? (
                //捕捉焦点
                el.setCapture(),
                //设置事件
                el.onmousemove = function (ev)
                {
                    mouseMove(ev || event)
                },
                el.onmouseup = mouseUp
            ) : (
                //绑定事件
                $(document).bind("mousemove", mouseMove).bind("mouseup", mouseUp)
            )
            
            //防止默认事件发生
            e.preventDefault();

                freshDivPos();
        });
        //移动事件
        function mouseMove(e)
        {

            var curY = e.clientY;

            // 设置拖动条的位置
       		$el.css("top", pos[$el.attr("id")].top + curY - disY);

            // 设置当前单元格的高度
			cell.css("height", pos[cell.attr("id")].height + curY - disY);

			// 设置下面单元格的高度
			nextCell.css("height" , (pos[nextCell.attr("id")].height - curY + disY));
        }
        //停止事件
        function mouseUp()
        {
            //在支持 releaseCapture 做些东东
            el.releaseCapture ? (
            //释放焦点
            el.releaseCapture(),
            //移除事件
            el.onmousemove = el.onmouseup = null
        ) : (
            //卸载事件
            $(document).unbind("mousemove", mouseMove).unbind("mouseup", mouseUp)
        )
       
       		 freshDivPos();
        }
	}

	var selectedOperLink;
	function selectContent(operLink){
		selectedOperLink = operLink;
	    popWindow('<%=contextPath%>/dashboard/portletSelect/portlet_menu.jsp?creatorId=<%=creatorId%>&isUser=<%=isUser%>',null,'选择仪表盘');
	}
	function setContent(info){
		if(info[0]!=""){

			var curl = info[2];
			if(curl.indexOf("?")<0) {
				curl += "?";
			} else {
				curl += "&";
			}

			var operDiv = $(selectedOperLink).parent();
			var contentDiv = operDiv.next();
			
			operDiv.children("span").html(info[1]);

			contentDiv.attr("menuId", info[0]);
			contentDiv.load("<%=contextPath%>"+curl);
	    }
	}
	/*
	function clearContent(clearLink){

		var operDiv = $(clearLink).parent();
		var contentDiv = operDiv.next();
		
		contentDiv.attr("menuId","");
		contentDiv.html("");
		operDiv.children("span").html("");
	}
*/
	function closeContent(closeLink){

		var operDiv = $(closeLink).parent();
		var contentDiv = operDiv.next();
		var contentDivResizeBar = contentDiv.next();
		
		var curCol = contentDiv.parent();

		var curBar = curCol.next();
		
		var preBar = curCol.prev();

		var curBoard = curCol.parent();

		if(curCol.children().size()>2){// 如果当前列还有单元格，调整单元格的高度
			var toResizeContentDiv = $();
			var preCellResizeBar = operDiv.prev();
			if(preCellResizeBar.size()>0){// 如果当前列上边有单元格，增加上边单元格的高度
				toResizeContentDiv = preCellResizeBar.prev();
				//preContentDiv.css("height", preContentDiv.height() + operDiv.height() + contentDiv.height() + contentDivResizeBar.height());
			}else{
				toResizeContentDiv = contentDiv.next().next().next();
				//nextContentDiv.css("height", nextContentDiv.height() + operDiv.height() + contentDiv.height() + contentDivResizeBar.height());
			}
			toResizeContentDiv.css("height", toResizeContentDiv.height() + operDiv.height() + contentDiv.height() + contentDivResizeBar.height()+1);
			operDiv.remove();
			contentDiv.remove();
			contentDivResizeBar.remove();

			// 如果被调整的内容框还有拉伸条，但是拉伸条下面已经没有单元格，删除拉伸条
			var toResizeBar = toResizeContentDiv.next();
			if(toResizeBar.size()>0 && toResizeBar.next().size()==0){
				toResizeContentDiv.css("height", toResizeContentDiv.height() + toResizeBar.height());
				toResizeBar.remove();
			}
		}else{// 当前列已经没有单元格了，删除当前列

			// 如果当前列左边有列，增加左边列的宽度
			if(preBar.size()>0){
				preBar.css("left", curBar.position().left);
	
				var preCol = preBar.prev();
	
				var newWidth = preCol.width()+curCol.width()+jianju;
				preCol.css("width", newWidth);
	
				preCol.children("div").each(function(){
					$(this).css("width", newWidth);
				});
			}else{ // 否则增加右边列的宽度
	
				var nextCol = curBar.next();
	
				var newWidth = nextCol.width()+curCol.width()+jianju;
				nextCol.css("left", curCol.position().left);
				nextCol.css("width", newWidth);
	
				nextCol.children("div").each(function(){
					$(this).css("left", curCol.position().left);
					$(this).css("width", newWidth);
				});
			}
	
			curCol.remove();
			curBar.remove();
	
			// 如果当前行没有列了，删除当前行
			if(curBoard.children().size()==0){
				var curBoardBar = curBoard.next();
				curBoardBar.remove();
				curBoard.remove();
								
			}
		}
	}

	function save(){
		closeToolbar();
		
		var datas=[];

		var boardIndex=0;
		
		$("div[id^=board]").each(function(){
			var board = $(this);
			var boardData = {};
			boardData.board_index = boardIndex++;// board.attr("id").substring(board.attr("id").lastIndexOf("_")+1);
			boardData.board_height = board.height();

			var colIndex=0;
			board.children("div[id^=col]").each(function(){
				var col = $(this);
				var colData = clone(boardData);
				colData.col_index = colIndex++;//col.attr("id").substring(col.attr("id").lastIndexOf("_")+1);
				colData.col_width = col.width();

				var cellIndex=0;
				col.children("div[id^=content]").each(function(){

					var cell = $(this);

					var cellData = clone(colData);

					cellData.cell_index = cellIndex++;//cell.attr("id").substring(cell.attr("id").lastIndexOf("_")+1);
					cellData.cell_height = cell.height();
					cellData.menu_id = cell.attr("menuId");

					 datas[datas.length] = cellData;
				});

			});

		});

		var cells = JSON.stringify(datas) ;

		//alert(cells); 

		var ret = jcdpCallService("DashboardSrv", "saveUserDashboard", "boardId="+boardId+"&boardType=0&creatorId=<%=creatorId%>&isUser=<%=isUser%>&boardName=个人仪表盘&boardWidth=" + (saveBoardWidth) + "&datas="+cells);

		if(ret.returnCode=="0") alert("保存成功");

		boardId = ret.boardId;

	}

	function config(){
		$("div[id^=resize]").css("display", "");
		$("#add_board_btn").attr("disabled", false);
		$("#add_col_btn").attr("disabled", false);
		//$("#add_cell_btn").attr("disabled", false);
		$("#save_btn").attr("disabled", false);

		var cell0 = $("#oper_0_0_0");
		if(cell0.size()>0)
		selectCell(cell0.eq(0));
	}

	function clone(myObj){  
	  if(typeof(myObj) != 'object') return myObj;  
	  if(myObj == null) return myObj;  
	    
	  var myNewObj = new Object();  
	    
	  for(var i in myObj)  
	     myNewObj[i] = clone(myObj[i]);  
	    
	  return myNewObj;  
	}

	function showToolbar(){
		var boardBar = $("#boardBar");
		if(boardBar.size()==0) {
			boardBar = $("<div id='boardBar'></div>");
			$(document.body).append(boardBar);


			var menu0 = $("<div>重新加载</div>");
			boardBar.append(menu0);
			menu0.bind("click", function(){
				window.location.reload();
			});
			
			var menu1 = $("<div>增加行</div>");
			boardBar.append(menu1);
			menu1.bind("click", function(){
				addRows(250, false);
			});
			
			var menu2 = $("<div>增加列</div>");
			boardBar.append(menu2);
			menu2.bind("click", function(){
				addCols(null, -1, -1, '', '', '', false);
			});
			
			var menu3 = $("<div>增加单元格</div>");
			boardBar.append(menu3);
			menu3.bind("click", function(){
				addCells(selectedCol, '', '', '');
			});
			
			var menu4 = $("<div>保存</div>");
			boardBar.append(menu4);
			menu4.bind("click", function(){
				save();
			});
			
			var menu5 = $("<div>关闭</div>");
			boardBar.append(menu5);
			menu5.bind("click", function(){
				closeToolbar();
			});
			
		}

		boardBar.css("display", "");
		$("div[id^=resize]").css("visibility", "visible");
		
		var cell0 = $("div[id^=oper_]");
		if(cell0.size()>0)
		selectCell(cell0.eq(0));

		$("div[id^=oper]").bind("click", function(){selectCell(this)});

		$("div[id^=oper]").children("a").css("display","");
	}

	function closeToolbar(){
		$("#boardBar").css("display", "none");
		$("div[id^=resize]").css("visibility", "hidden");
		if(selectedCell!=null && selectedCell.size()>0){
			selectedCell.css("background", "url(images/titlebg.jpg)");
		}

		$("div[id^=oper]").unbind("click");

		$("div[id^=oper]").children("a").css("display","none");
	}
</script>

</body>
</html>
