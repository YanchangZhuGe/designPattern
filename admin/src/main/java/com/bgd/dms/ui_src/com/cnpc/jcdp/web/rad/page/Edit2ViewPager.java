/**
 * 
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import com.cnpc.jcdp.web.rad.util.RADConst.PMDAction;
import com.cnpc.jcdp.webapp.util.OMSMVCUtil;

/**
 * @author rechete
 *
 */
public class Edit2ViewPager extends BasePager{
	protected String sql;
	protected String itemsSql;
	protected String lineRange;
	//不打印关闭按钮
	private boolean noSubmitButton = false;
	
    protected void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception{
		
    	sql = tlHd.getSingleNodeValue("//QuerySQL/sql");
		addParams(sql,request);
		if("true".equals(request.getParameter("noSubmit"))) noSubmitButton = true;
    }
    
  public void process(HttpServletRequest request, HttpServletResponse response)
  	throws java.io.IOException, ServletException {
  try {
	  
	  response.setContentType("text/html;charset=GBK");

      print("\t\r\n");
      print("<html>\r\n");
      print("<head>\r\n");
      print("<title>查看页面</title>\r\n");
      print("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\">\r\n");
      if("toJsp".equals(action)){
    	  print("<%@ include file=\"/common/pmd_view.jsp\"%>\r\n");
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
	      print("\r\n");
	      print("<script type=\"text/javascript\" src=\"");
	      print(contextPath);
	      print("/js/rt/rt_base.js\"></script>\r\n");
	      print("<script type=\"text/javascript\" src=\"");
	      print(contextPath);
	      print("/js/rt/rt_cru.js\"></script>\r\n");     
	      
	      
	      print("<script type=\"text/javascript\" src=\"");
	      print(contextPath);
	      print("/js/rt/proc_base.js\"></script>\r\n");
	      print("<script type=\"text/javascript\" src=\"");
	      print(contextPath);
	      print("/js/rt/fujian.js\"></script>\r\n");
	      
	      print("<script type=\"text/javascript\" src=\"");
	      print(contextPath);
	      print("/js/rt/rt_validate.js\"></script>\r\n");
	      print("<script type=\"text/javascript\" src=\"");
	      print(contextPath);
	      print("/js/rt/rt_view.js\"></script> \r\n");
	      print("<script type=\"text/javascript\" src=\"");
	      print(contextPath);
	      print("/js/json.js\"></script> \r\n");      
	      print("\r\n");
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
      print("<script language=\"javaScript\">\r\n");
      print("<!--Remark JavaScript定义-->\r\n");
      printJavaScript(request);

      print("</script>\r\n");
      print("</head>\r\n");
      print("\r\n");

      print("<body onLoad=\"page_init()\">\r\n");
      print("\r\n");
      String style = "";
      if(noSubmitButton){
    	  printTitle(RADConst.TitleType.TAB);
    	  style = "style=\"BORDER-TOP: #dedede 1px solid;\"";
      }
      else printTitle(RADConst.TitleType.Hint);
      print("<div id=\"addDiv\">\t\r\n");
      print("  <table id=\"rtCRUTable\" "+style+" cellSpacing=0 cellPadding=1 width=\"100%\" align=center border=0>\r\n");
      print("  <form >\r\n");
      print("  <span id=\"hiddenFields\" style=\"display:none\"></span>\r\n");
      print("  <!--Remark 此处由开发人员加入字段-->\r\n");
      print("    <!--tr>\r\n");
      print("      <td class=\"rtCRUFdName\">字段名</td>\r\n");
      print("      <td class=\"rtCRUFdValue\"><input type=\"text\" name=\"\"></td>\r\n");
      print("      <td class=\"rtCRUFdName\">字段名</td>\r\n");
      print("      <td class=\"rtCRUFdValue\"><input type=\"text\" name=\"\"></td>      \r\n");
      print("    </tr-->\t\t\r\n");
      print("  </table>\r\n");
      print("  </form>\r\n");
      print("  \r\n");
      if(!noSubmitButton){
          print("\t<table cellSpacing=0 cellPadding=5 width=\"100%\" align=center border=0 class=\"small\"> \r\n");
          print("\t<tr>\r\n");
          print("\t\t<td colspan=\"4\" align=\"center\">\r\n");
          //print("\t\t<input type=\"button\" class=\"button save\" value=\"保存\" onClick=\"editEntity()\"/>\r\n");
          print("\t\t<input type=\"button\" class=\"button cancel\" value=\"关闭\" onClick=\"window.close()\"/>\r\n");
          print("\t\t</td>\r\n");
          print("\t</tr>\r\n");
          print("\t</table>  \r\n");    	  
      }
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
  	private void printJavaScript(HttpServletRequest request)throws IOException{
  		String pageTitle = request.getParameter("pageTitle");
        //log.info(request.getCharacterEncoding());
  		if(pageTitle==null){
	  		pageTitle = tlHd.getSingleNodeValue("//PageTitle");
	  		pageTitle = "查看--"+pageTitle;
  		}
  		else pageTitle = new String(pageTitle.getBytes("ISO-8859-1"),"UTF-8");
  		//log.info(pageTitle);
  		print("var cruTitle = \""+pageTitle+"\";\r\n");
  		
  		printSelOptions();  		
  		printJcdpCodes();
  		
  		print("var jcdp_record = null;\r\n");
        
  		//printFields(request,PMDAction.S_R);
  	    
  	    printPageInit();
  	    
  	}
  	
  	private void printPageInit()throws IOException{
  		print("\r\n");
        print("function page_init(){\r\n");
        print("\tgetObj('cruTitle').innerHTML = cruTitle;\r\n");
        print("\tcruConfig.contextPath = \"");
        print(contextPath);
        print("\";\r\n");
       
        Pattern pattern = Pattern.compile("\\u0024PARAM.(\\w)+");
		Matcher matcher = pattern.matcher(sql);
		while(matcher.find()){
			String str = matcher.group();
			String key = str.substring(7);
			sql = sql.replaceAll("\\u0024PARAM."+key, params.get(key).toString());
		}
        //sql = sql.replaceAll("\\u007Bid}", id);
        print("\tcruConfig.querySql = \""+sql+"\";\r\n");
        print("\tview_init();\r\n");
        print("}\r\n");  		
  	} 
  	
  	protected boolean isContainField(String fieldAction){
  		if(fieldAction==null || fieldAction.indexOf("R")>=0) return true;
  		else return false;
  	}
}
