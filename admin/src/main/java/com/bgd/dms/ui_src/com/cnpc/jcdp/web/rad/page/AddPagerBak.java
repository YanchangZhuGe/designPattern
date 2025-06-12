/**
 * 
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspFactory;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.SkipPageException;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.PMDRequest;

/**
 * @author rechete
 *
 */
public class AddPagerBak extends BasePager{
	protected void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception{	
		
	}
  public void process(HttpServletRequest request, HttpServletResponse response)
  	throws java.io.IOException, ServletException {
  try {
	  
	  response.setContentType("text/html;charset=GBK");

      print("<html>\r\n");
      print("<head>\r\n");
      print("<title>����ҳ��</title>\r\n");
      print("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\">\r\n");
      if("toJsp".equals(action)){
    	  print("<%@ include file=\"/common/pmd_add.jsp\"%>\r\n");
      }
      else{
          print("<link rel=\"stylesheet\" type=\"text/css\" media=\"all\" href=\"");
          print(contextPath);
          print("/css/calendar-blue.css\"  />\r\n");
          print("<script type=\"text/javascript\" src=\"");
          print(contextPath);
          print("/js/calendar.js\"></script>\r\n");
          print("<script type=\"text/JavaScript\" src=\"");
          print(contextPath);
          print("/js/calendar-en.js\"></script>\r\n");
          print("<script type=\"text/javascript\" src=\"");
          print(contextPath);
          print("/js/calendar-setup.js\"></script>\r\n");
          print("<script type=\"text/javascript\" src=\"");
          print(contextPath);
          print("/js/rt/rt_base.js\"></script>\r\n");
          print("<script type=\"text/javascript\" src=\"");
          print(contextPath);
          print("/js/rt/rt_cru.js\"></script>\r\n");          
          print("<script type=\"text/javascript\" src=\"");
          print(contextPath);
          print("/js/rt/rt_validate.js\"></script>\r\n");
          print("<script type=\"text/javascript\" src=\"");
          print(contextPath);
          print("/js/rt/rt_add.js\"></script> \r\n");
          print("<script type=\"text/javascript\" src=\"");
          print(contextPath);
          print("/js/json.js\"></script> \r\n");          
          print("<link rel=\"stylesheet\" href=\"");
          print(contextPath);
          print("/css/common.css\" type=\"text/css\" />\r\n");
          print("<link rel=\"stylesheet\" href=\"");
          print(contextPath);
          print("/css/main.css\" type=\"text/css\" />\r\n");
          print("<link rel=\"stylesheet\" href=\"");
          print(contextPath);
          print("/css/rt_cru.css\" type=\"text/css\" />\r\n");
      }
      print("\r\n"); 
      print("<script language=\"javaScript\">\r\n");
      print("<!--Remark JavaScript����-->\r\n");
      printJavaScript(request);
      
      print("function page_init(){\r\n");
      print("\tgetObj('cruTitle').innerHTML = cruTitle;\r\n");
      print("\tcruConfig.contextPath = \"");
      print(contextPath);
      print("\";\r\n");
      print("\tadd_init();\r\n");
      print("}\r\n");

      print("</script>\r\n");
      print("</head>\r\n");
      print("\r\n");

      print("<body onLoad=\"page_init()\">\r\n");
/*      print("\r\n");
      print("<div>\r\n");
      print("<span id=\"cruTitle\"></span>\t\r\n");
      print("</div>\r\n");
      print("\r\n");*/
      printTitle(RADConst.TitleType.Hint);
      print("<div id=\"addDiv\">\t\r\n");
      print("  <table id=\"rtCRUTable\" cellSpacing=0 cellPadding=1 width=\"100%\" align=center border=0>\r\n");
      print("  <form >\r\n");
      print("  <span id=\"hiddenFields\" style=\"display:none\"></span>\r\n");
      print("  <!--Remark �˴��ɿ�����Ա�����ֶ�-->\r\n");
      print("    <!--tr>\r\n");
      print("      <td class=\"rtCRUFdName\">�ֶ���</td>\r\n");
      print("      <td class=\"rtCRUFdValue\"><input type=\"text\" name=\"\"></td>\r\n");
      print("      <td class=\"rtCRUFdName\">�ֶ���</td>\r\n");
      print("      <td class=\"rtCRUFdValue\"><input type=\"text\" name=\"\"></td>      \r\n");
      print("    </tr-->\t\t\r\n");
      print("  </table>\r\n");
      print("  </form>\r\n");
      print("  \r\n");
      print("\t<table cellSpacing=0 cellPadding=5 width=\"100%\" align=center border=0 class=\"small\"> \r\n");
      print("\t<tr>\r\n");
      print("\t\t<td colspan=\"4\" align=\"center\">\r\n");
      print("\t\t<input type=\"button\" class=\"button save\" value=\"����\" onClick=\"addEntity()\"/>\r\n");
      print("\t\t<input type=\"button\" class=\"button cancel\" value=\"�ر�\" onClick=\"window.close()\"/>\r\n");
      print("\t\t</td>\r\n");
      print("\t</tr>\r\n");
      print("\t</table>  \r\n");
      print("</div>\r\n");
      print("\r\n");
      print("</body>\r\n");
      print("</html>");      


  } catch (Throwable t) {
	  t.printStackTrace();
	  //System.println(t);
  } finally {
	 if(out!=null) flush();
  }

 

}
  	protected void printJavaScript(HttpServletRequest request)throws IOException{
  		String pageTitle = tlHd.getSingleNodeValue("//PageTitle");
  		print("var cruTitle = \"����--"+pageTitle+"\";\r\n");
  		
  		printSelOptions();  		
  		printJcdpCodes();
  		print("var jcdp_record = null;\r\n");
  		//printFields(request,RADConst.PMDAction.S_C);
  		
  	    printAddJs();
  	}
  	
  	/**
  	 * ��������
  	 * @throws IOException
  	 */
  	protected void printAddJs()throws IOException{
        print("\r\n");
        print("function addEntity(){\r\n");
        print("\tvar path = cruConfig.contextPath+cruConfig.addAction;\r\n");
        print("\tsubmitStr = getSubmitStr();\r\n");
        print("\tif(submitStr == null) return;\r\n");        
        print("\tvar retObject = syncRequest('Post',path,submitStr);\r\n");
        print("\tif (retObject.returnCode != \"0\") alert(\"����ʧ��!\");\r\n");
        print("\telse{\r\n");
        print("\t\talert(\"�����ɹ�!\");\r\n");
        print("\t\twindow.opener.refreshData();\r\n");
        print("\t\twindow.close();\r\n");
        print("\t}\r\n");
        print("}\r\n");
        print("\r\n");  		
  	}

  	protected boolean isContainField(String fieldAction){
  		if(fieldAction==null || fieldAction.indexOf("C")>=0) return true;
  		else return false;
  	}
}
