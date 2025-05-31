 
<HTML>
<%
String path = request.getContextPath();
%>
<HEAD>
	<TITLE> ZTREE DEMO - getNodeByParam / getNodesByParam / getNodesByParamFuzzy</TITLE>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<%=path %>/css/zTreeStyle/demo.css" type="text/css">
	<link rel="stylesheet" href="<%=path %>/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="<%=path %>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=path %>/js/jquery.ztree.core-3.5.js"></script>
	<!--  <script type="text/javascript" src="../../../js/jquery.ztree.excheck-3.5.js"></script>
	  <script type="text/javascript" src="../../../js/jquery.ztree.exedit-3.5.js"></script>-->
	<SCRIPT type="text/javascript">
	var zNodes;
	var treeID = "50000674";
	var root = "<%=path%>";
/*   	function loadNodes(){
	      $.ajax({
	      async : false,
	      cache:false,
	      type: 'POST',
	      data:{id:treeID},
	      dataType : "json",
	      url: root+"/test/TestServlet",
	      error: function () { 
	        alert("fail");
	      },
	     success:function(data){    
	        zNodes = data;  
	      }
	      });
	    }
	   */
		<!--
		var setting = { 
			data: {
				key: {
					title: "t" 
				},
				simpleData: {
					enable: true
				}				
			},
			async: {  
		                enable: true,  
		                url:"<%=path%>/test/TestServlet",  
		                autoParam:["id", "name"],  
		                otherParam:{"otherParam":"zTreeAsyncTest"},  
		      },
			view: {
				fontCss: getFontCss
			},
			callback: {
			    beforeExpand: beforeExpand
			}
			
		};
	

		function beforeExpand(treeId, treeNode) {
		    treeID = treeNode.id;
		    alert(treeID); 
			if (treeNode.isParent) {
				return true;
			} else {
				return false;
			}
		}

		
		function focusKey(e) {
			if (key.hasClass("empty")) {
				key.removeClass("empty");
			}
		}
		function blurKey(e) {
			if (key.get(0).value === "") {
				key.addClass("empty");
			}
		}
		var lastValue = "", nodeList = [], fontCss = {};
		function clickRadio(e) {
			lastValue = "";
			searchNode(e);
		}
		function searchNode(e) {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			if (!$("#getNodesByFilter").attr("checked")) {
				var value = $.trim(key.get(0).value);
				var keyType = "";
				if ($("#name").attr("checked")) {
					keyType = "name";
				} else if ($("#level").attr("checked")) {
					keyType = "level";
					value = parseInt(value);
				} else if ($("#id").attr("checked")) {
					keyType = "id";
					value = parseInt(value);
				}
				if (key.hasClass("empty")) {
					value = "";
				}
				if (lastValue === value) return;
				lastValue = value;
				if (value === "") return;
				updateNodes(false);

				if ($("#getNodeByParam").attr("checked")) {
					var node = zTree.getNodeByParam(keyType, value);
					if (node === null) {
						nodeList = [];
					} else {
						nodeList = [node];
					}
				} else if ($("#getNodesByParam").attr("checked")) {
					nodeList = zTree.getNodesByParam(keyType, value);
				} else if ($("#getNodesByParamFuzzy").attr("checked")) {
					nodeList = zTree.getNodesByParamFuzzy(keyType, value);
				}
			} else {
				updateNodes(false);
				nodeList = zTree.getNodesByFilter(filter);
			}
			updateNodes(true);

		}
		function updateNodes(highlight) {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			for( var i=0, l=nodeList.length; i<l; i++) {
				nodeList[i].highlight = highlight;
				zTree.updateNode(nodeList[i]);
			}
		}
		function getFontCss(treeId, treeNode) {
			return (!!treeNode.highlight) ? {color:"#A60000", "font-weight":"bold"} : {color:"#333", "font-weight":"normal"};
		}
		function filter(node) {
			return !node.isParent && node.isFirstNode;
		}
 
		var key;
		$(document).ready(function(){ 
			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
			key = $("#key");
			key.bind("focus", focusKey)
			.bind("blur", blurKey)
			.bind("propertychange", searchNode)
			.bind("input", searchNode);
			$("#name").bind("change", clickRadio);
			$("#level").bind("change", clickRadio);
			$("#id").bind("change", clickRadio);
			$("#getNodeByParam").bind("change", clickRadio);
			$("#getNodesByParam").bind("change", clickRadio);
			$("#getNodesByParamFuzzy").bind("change", clickRadio);
			$("#getNodesByFilter").bind("change", clickRadio); 
		});
		//-->
	</SCRIPT>
</HEAD>

<BODY>
 
<div class="content_wrap">

	<div class="zTreeDemoBackground left">
		<ul id="treeDemo" class="ztree"></ul>
	</div>
	<div class="right">
	 <p><br/>
				<input type="checkbox" id="callbackTrigger" checked /> expandNode callback<br/>
			        
						field_value( value ) <input type="text" id="key" value="" class="empty" /><br/>
						field( key )<input type="radio" id="name" name="keyType" class="radio first" checked /><span>name (string)</span><br/>
						<input type="radio" id="level" name="keyType" class="radio" style="margin-left:68px;" /><span>level (number) ...  level = 0</span><br/>
						<input type="radio" id="id" name="keyType" class="radio" style="margin-left:68px;" /><span>id (number)</span><br/>
						method:<input type="radio" id="getNodeByParam" name="funType" class="radio first" /><span>getNodeByParam</span><br/>
						<input type="radio" id="getNodesByParam" name="funType" class="radio" style="margin-left:36px;" /><span>getNodesByParam</span><br/>
						<input type="radio" id="getNodesByParamFuzzy" name="funType" class="radio" style="margin-left:36px;" checked /><span>getNodesByParamFuzzy (only string)</span><br/>
						<input type="radio" id="getNodesByFilter" name="funType" class="radio" style="margin-left:36px;" /><span>getNodesByFilter ( function filter)</span><br/>
					</p>
		 
	</div>
</div>
</BODY>
</HTML>