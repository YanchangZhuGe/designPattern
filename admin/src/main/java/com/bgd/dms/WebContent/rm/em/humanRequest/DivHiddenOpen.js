	function showQuery(){
		var queryDiv = document.getElementById("queryDiv");
		var display = queryDiv.style.display == "none" ? "block" : "none";
		queryDiv.style.display = display;
		
		var ShowQueryButton = document.getElementById("ShowQueryButton");
		var value = ShowQueryButton.value == "高级查询" ? "关闭查询":"高级查询";
		ShowQueryButton.value = value;		
	}