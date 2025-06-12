/**
 * 集团生产运行管理系统模板
 */
package com.cnpc.jcdp.web.rad.template;

import java.io.IOException;

import com.cnpc.jcdp.web.rad.page.AbstractPager;

/**
 * @author rechete
 *
 */
public class CNPCOMSCRUTmpt extends BaseTmpt{
	
	
	public void printHeader()throws IOException{
		pager.println("<html>");
		pager.println("<head>");
		pager.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\" />");
		pager.println("<link href=\""+pager.getContextPath()+"/css/a7_table.css\" rel=\"stylesheet\" type=\"text/css\" />");
		pager.printPagerScript();
		pager.println("</head>");
	}
	
	public void printBody()throws IOException{
		pager.println("<body onload=\"page_init()\">");
		pager.println("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"Tab_page_title_wt\">");
		pager.println("  <tr>");
		pager.println("    <td class=\"Tab_page_title_text\">物探专业</td>");
		pager.println("    <td>");
		pager.println("	  <img src=\""+pager.getContextPath()+"/images/help.jpg\" width=\"15\" height=\"15\">");
		pager.println("	    <a id=\"pageSet\" style=\"cursor:hand;\" ");
		pager.println("	      onclick=\"window.open('/OMS_Web_GPE/gpe/help/HelperFrame.jsp?context=produce_harmony/harmony.htm')\" target=_blank>在线帮助</a>");
		pager.println("	</td>");
		pager.println("  </tr>");
		pager.println("</table>");
		pager.println("<table  border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"Tab_page_title\" >");
		pager.println("  <tr class=\"Tab_page_title\">");
		pager.println("    <td id=\"cruTitle\" colspan=\"4\" class=\"Tab_Header\" >生产协调 -> 工农协调信息 -> 新增工农协调信息</td>");
		pager.println("  </tr>");
		pager.println("</table>	");	
		
		pager.println("<table id=\"rtCRUTable\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"form_info\">");	
		pager.println("  <span id=\"hiddenFields\" style=\"display:none\"></span>\r\n");
		pager.println("  <!--tr>");	
		pager.println("    <td class=\"rtCRUFdName\"><font color=\"red\">*</font>&nbsp;协调负责人：</td>");	
		pager.println("    <td class=\"rtCRUFdValue\" >");	
		pager.println("    <input type=\"text\" name=\"coordinator\" value=\"\" class=\"input_width\" dataType=\"Limit\" max=\"17\" min=\"0\" msg=\"协调负责人应该17字之内，请重新输入！\" require=\"false\"/>");	
		pager.println("    </td>");	
		pager.println("    <td class=\"rtCRUFdName\"><font color=\"red\">*</font>&nbsp;协调负责人所属单位：</td>");	
		pager.println("    <td class=\"rtCRUFdValue\" >");	
		pager.println("	<input type=\"hidden\" name=\"orgId\" id=\"orgId\" value=\"\"/>");	
		pager.println("    <input type=\"text\" name=\"orgName\" id=\"orgName\" value=\"\" class=\"input_width\" readOnly />");	
		pager.println("	<input name=\"Submit\" type=\"button\" class=\"iButton2\"  onClick=\"openSelectVehicle();\" value=\"选择\" />");	
		pager.println("    </td>");	
		pager.println("  </tr-->");	
		pager.println("  <tr>");	
		pager.println("    <td colspan=\"4\" class=\"rtCRUFdName\">");	
		if(pager.isViewAction()){
			pager.println("    <input name=\"Submit\" type=\"button\" class=\"iButton2\"  onClick=\"window.history.back();\" value=\"返回\" />");	
		}else{
			pager.println("    <input name=\"Submit\" type=\"button\" class=\"iButton2\" onClick=\"submitFunc();\"  value=\"确定\" />");	
			pager.println("    <input name=\"Submit\" type=\"button\" class=\"iButton2\"  onClick=\"window.history.back();\" value=\"取消\" /></td>");	
		}
		pager.println("  </tr>");	 
		pager.println("</table>");			
		
		pager.println("</body>");
		pager.println("</html>");
	}	
}
