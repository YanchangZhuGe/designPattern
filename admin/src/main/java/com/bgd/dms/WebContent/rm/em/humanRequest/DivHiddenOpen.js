	function showQuery(){
		var queryDiv = document.getElementById("queryDiv");
		var display = queryDiv.style.display == "none" ? "block" : "none";
		queryDiv.style.display = display;
		
		var ShowQueryButton = document.getElementById("ShowQueryButton");
		var value = ShowQueryButton.value == "�߼���ѯ" ? "�رղ�ѯ":"�߼���ѯ";
		ShowQueryButton.value = value;		
	}