function getTab(url,flag) {  
    document.all.tabIframe.src=url;
    var elList, i;
    elList = document.getElementsByTagName("li");

    for (i = 0; i < elList.length; i++){
	   elList[i].className ="";
    }
    elList[flag].className ="selectTag";
    elList[flag].blur();
}