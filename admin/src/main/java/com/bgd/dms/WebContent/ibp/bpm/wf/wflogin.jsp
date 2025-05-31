<%@ taglib uri="oms" prefix="oms"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
String path=request.getContextPath();
 %>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>Welcome to RF-SOAF!</title>
<link href="styles/table.css" rel="stylesheet" type="text/css"/>
</head>
<body style="FILTER: progid:DXImageTransform.Microsoft.Gradient(gradientType=0,startColorStr=#119ac3,endColorStr=#ffffff)">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="left"><img src="images/main/head.jpg" width="1003" height="99" /></td>
  </tr>
    <tr>
    <td align="left" height="25" background="images/main/infor_main_13.jpg"></td>
  </tr>
</table>




<table width="100%" height="400" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" valign=bottom><table width="451" height="303" border="0" cellpadding="0" cellspacing="0" >
      <tr>
        <td valign="top" background="images/main/back.jpg"><form id="form1" name="form1" method="post" action="<%=path %>/wf/login.srq"><table width="451" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="96">&nbsp;</td>
            <td height="96">&nbsp;</td>
            <td height="96">&nbsp;</td>
          </tr>
          <tr>
            <td width="138" height="40" align="right">Username:</td>
            <td width="184" height="40" align="center"><label>
                                                          <input name="loginId" type="text" value="U001" class="input-border"/>
            </label></td>
            <td width="129" height="40">&nbsp;</td>
          </tr>
          <tr>
            <td width="138" height="40" align="right">Password:</td>
            <td width="184" height="40" align="center"><input name="userPwd" type="password" value="123" class="input-border"/></td>
            <td width="129" height="40" align="left"><a href="#" class="a1"></a></td>
          </tr>
          <tr>
            <td width="138" height="40" align="right">&nbsp;</td>
            <td width="184" height="40" align="center"><input type="submit" name="Submit" value="Submit" class="button1" />
              <input type="reset" name="Submit2" value="Reset" class="button1" /></td>
            <td width="129" height="40"></td>
          </tr>
          <tr>
            <td height="40" colspan="3" align="center"><font color="red"><oms:msg msgTag="ReturnCodeMsg" key="retMsg"/></font></td>
          </tr>          
        </table></form></td>
      </tr>
    </table></td>
  </tr>
</table>

</body>
</html>
