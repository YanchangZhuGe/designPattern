<%@ page contentType="text/html;charset=GBk" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�������CRMϵͳ</title>
<meta content="MSHTML 5.00.3103.1000" name="GENERATOR" />
<link rel="stylesheet" href="src/skin-longhorn.css" title="Windows XP" />
<style>
body {
	margin:0 auto;
	text-align:center;
	background-color:#3366FF;
}
#Content {

	text-align:center;
	background-color:#FFFFFF;
	height:100%;
	overflow:hidden;

}
#head {
	height:76px;
	width:1002px;
	overflow:hidden;
}
#dh {
	background:url(images/MenuBG.gif) repeat-x;
	height:26px;
}
#mainContent {
	height:100%;
	max-height:480px;
	overflow:auto;
	overflow-x:hidden;

}

#copyRight {
	position:absolute;
	width:100%;
	left:0;
	bottom:0;
	font-size:12px;
	background-image:url(images/footer.gif);
	background-repeat:repeat-x;
	height:23px;
	color:#FFFFFF;
	padding-top:5px;
	line-height:0;
	line-height:0\9;
 *line-height:18px;
	_line-height:18px; 
}
.copystyle {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
}
div.dynarch-horiz-menu table tr td {
	height: 25px;
	vertical-align:center;
}
html, body {
	margin: 0px;
	padding: 0px;
	font: 12px "����";
}
#div-content {
	padding: 0px 1em;
	background-color: #fff;
}
</style>
</head>
<script language="JavaScript" type="text/JavaScript"> 
var autoclick_ok=false; 
var cishu = 1 
function mClk() 
{ 
if(!autoclick_ok && cishu==1) 
{ 
var source=event.srcElement;source.click(); 
cishu+=1; 
} 
} 
</script>
<script type="text/javascript">
      _dynarch_menu_url = "./src/";
    </script>
<script type="text/javascript" src="src/hmenu.js"></script>
<SCRIPT LANGUAGE="JavaScript">
	<!--
		 function initPage() {
        mainmenu = DynarchMenu.setup('page-menu', { shadows: [-1, 0, 5, 5] });
        
      }
	  function showSection(url) {
        document.getElementById("frame-content").src = url ;
        
      }
	  
	//-->
	</SCRIPT>
<body style="overflow: auto" onLoad="initPage()" id="document">

<div id="Content">
  <div id="head">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="1002"><img src="images/header.jpg" alt="" width="1002" height="76" /></td>
      </tr>
    </table>
  </div>
  <div id="dh">
    <div align="left">
      <ul id="page-menu" style="display: none;">
        <li> <img src="icons/b087.gif" width="14" height="16" alt="" /> <a><span class="downarrow">�ճ̰���</span></a> </li>
        <li> <img src="icons/b087.gif" width="14" height="16" alt="" /> <a><span class="downarrow">ͨѶ¼</span></a> </li>
        <li> <img src="icons/b087.gif" width="14" height="16" alt="" /> <a><span class="downarrow">Ӧ����ϵ</span></a>
          <ul>
            <li><img src="icons/interface_dialog.gif" alt="" /><a href="">Ӧ��Ԥ��</a></li>
            <li><img src="icons/interface_dialog.gif" alt="" />Ӧ����֯����</li>
          </ul>
        </li>
        <li> <img src="icons/b087.gif" width="14" height="16" alt="" /> <a><span class="downarrow">�ص��ע</span></a>
          <ul>
            <li><img src="icons/interface_dialog.gif" alt="" /><a href="http://www.sohu.com">ʵʱ����</a></li>
            <li><img src="icons/interface_dialog.gif" alt="" />���鶯̬</li>
            <li><img src="icons/interface_dialog.gif" alt="" />��׼�淶</li>
            <li><img src="icons/interface_dialog.gif" alt="" />������̳</li>
            <li><img src="icons/interface_dialog.gif" alt="" />ר�ҿ�</li>
            <li><img src="icons/interface_dialog.gif" alt="" />�ĵ���</li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
  <div>
	<%@ include file="xyz.jsp" %>

    </div> 
 
  </div>


<script type="text/javascript" src="src/PieNG.js"></script>
<script type="text/javascript">DynarchMenu.preloadImages()</script>
  <div id="copyRight">
    <p align="right">��Ȩ���� <span class="copystyle">&copy;</span> �������������Ϣ�����������ι�˾&nbsp;&nbsp;</p>
  </div>
  
</body>
</html>
