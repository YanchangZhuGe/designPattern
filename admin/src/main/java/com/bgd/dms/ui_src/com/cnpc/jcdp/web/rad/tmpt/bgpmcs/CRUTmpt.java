/**
 * BGPMCS模板
 */
package com.cnpc.jcdp.web.rad.tmpt.bgpmcs;

import java.io.IOException;

import com.cnpc.jcdp.web.rad.page.EditPager;
import com.cnpc.jcdp.web.rad.template.BaseTmpt;

/**
 * @author rechete
 *
 */
public class CRUTmpt extends BaseTmpt{
	protected EditPager editPager;
	
	public void printHeader()throws IOException{
		editPager = (EditPager)pager;
		pager.println("<html>");
		pager.println("<head>");
		pager.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\" />");
		pager.println("<link href=\""+pager.getContextPath()+"/css/bgpmcs_table.css\" rel=\"stylesheet\" type=\"text/css\" />");	
		pager.printPagerScript();
		pager.println("<script type=\"text/JavaScript\" src=\"/BGPMCS/js/calendar-zh.js\"></script>");
		pager.println("</head>");
	}
	
	public void printBody()throws IOException{
		pager.println("<body onload=\"page_init()\">");
		pager.println("<table  border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"Tab_page_title\" >");
/*		pager.println("  <tr class=\"Tab_page_title\">");
		pager.println("    <td id=\"cruTitle\" colspan=\"4\" class=\"Tab_Header\" >生产协调 -> 工农协调信息 -> 新增工农协调信息</td>");
		pager.println("  </tr>");*/
		
		
		pager.println("<tr>");
		pager.println("	<td height=1 colspan=\"4\" align=left></td>");
		pager.println("</tr>");
		pager.println("<tr>");
		pager.println("	<td width=\"5%\"  height=28 align=left ><img src=\""+pager.getContextPath()+"/images/oms_index_09.gif\" width=\"100%\" height=\"28\" /></td>");
		pager.println("	<td id=\"cruTitle\" width=\"40%\" align=left background=\""+pager.getContextPath()+"/images/oms_index_11.gif\" class=\"text11\">");
	    pager.println(" </td>");
		pager.println("	<td width=\"5%\" align=left ><img src=\""+pager.getContextPath()+"/images/oms_index_13.gif\" width=\"100%\" height=\"28\" /></td>");
		pager.println("	<td width=\"50%\" align=left style=\"background:url("+pager.getContextPath()+"/images/oms_index_14.gif) repeat-x;\">&nbsp;</td>");
		pager.println("</tr>");	
		pager.println("</table>	");	
		
		pager.println("  <form name='fileForm' encType='multipart/form-data'  method='post' target='hidden_frame'>");
		
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
		pager.println("    <td colspan=\"4\" class=\"ali4\">");	
	    if(!pager.isViewAction())
	        pager.println("    <input name=\"Submit\" type=\"button\" class=\"iButton2\" onClick=\"submitFunc();\"  value=\"确定\" />");	
	     
	    if(!editPager.isNoCloseButton())
	        pager.println("    <input name=\"Submit\" type=\"button\" class=\"iButton2\"  onClick=\"window.history.back();\" value=\"取消\" /></td>");	
	    
/*		if(pager.isViewAction()){
			pager.println("    <input name=\"Submit\" type=\"button\" class=\"iButton2\"  onClick=\"window.history.back();\" value=\"返回\" />");	
		}else{
			pager.println("    <input name=\"Submit\" type=\"button\" class=\"iButton2\" onClick=\"submitFunc();\"  value=\"确定\" />");	
			pager.println("    <input name=\"Submit\" type=\"button\" class=\"iButton2\"  onClick=\"window.history.back();\" value=\"取消\" /></td>");	
		}*/
		pager.println("  </tr>");	 
		pager.println("</table>");			
		
		pager.println("</form>  <iframe name='hidden_frame' width='1' height='1' marginwidth='0' marginheight='0' scrolling='no' frameborder='0'></iframe>");
		
		pager.println("</body>");
		pager.println("</html>");
	}	
}
