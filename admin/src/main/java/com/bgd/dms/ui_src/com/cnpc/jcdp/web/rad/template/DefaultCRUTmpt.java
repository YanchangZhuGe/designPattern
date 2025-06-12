/**
 * 默认风格-CRU页面
 */
package com.cnpc.jcdp.web.rad.template;

import java.io.IOException;
import java.util.List;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.page.AbstractPager;
import com.cnpc.jcdp.web.rad.page.EditPager;

/**
 * @author rechete
 *
 */
public class DefaultCRUTmpt extends BaseTmpt{
	protected EditPager editPager;
	
	
	public void printHeader()throws IOException{
		editPager = (EditPager)pager;
		pager.println("<html>");
		pager.println("<head>");
		pager.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\" />");
		pager.println("<link href=\""+pager.getContextPath()+"/css/common.css\" rel=\"stylesheet\" type=\"text/css\" />");
		pager.println("<link href=\""+pager.getContextPath()+"/css/main.css\" rel=\"stylesheet\" type=\"text/css\" />");
		pager.println("<link href=\""+pager.getContextPath()+"/css/rt_cru.css\" rel=\"stylesheet\" type=\"text/css\" />");
		pager.printPagerScript();
		pager.println("</head>");	      
	}
	
	public void printBody()throws IOException{
      pager.print("<body onLoad=\"page_init()\">\r\n");
      
      pager.print("<div id=\"hintTitle\">\r\n");
      pager.print("<span id=\"cruTitle\"></span>\t\r\n");
      pager.print("</div>\r\n");     
      
      pager.println("<div id=\"addDiv\" style=\"width:100%;height:10;\">\t");
      pager.print("  <form name='fileForm' encType='multipart/form-data'  method='post' target='hidden_frame'>");
      pager.print("  <table id=\"rtCRUTable\" cellSpacing=0 cellPadding=1 width=\"100%\" align=center border=0>\r\n");
      pager.print("  <span id=\"hiddenFields\" style=\"display:none\"></span>\r\n");
      pager.print("  <!--Remark 此处由开发人员加入字段-->\r\n");
      pager.print("    <!--tr>\r\n");
      pager.print("      <td class=\"rtCRUFdName\">字段名</td>\r\n");
      pager.print("      <td class=\"rtCRUFdValue\"><input type=\"text\" name=\"\"></td>\r\n");
      pager.print("      <td class=\"rtCRUFdName\">字段名</td>\r\n");
      pager.print("      <td class=\"rtCRUFdValue\"><input type=\"text\" name=\"\"></td>      \r\n");
      pager.print("    </tr-->\t\t\r\n");
      pager.print("  </table>\r\n");
      pager.print("  </form>");
      pager.print("  <iframe name='hidden_frame' width='1' height='1' marginwidth='0' marginheight='0' scrolling='no' frameborder='0'></iframe>");
      if(editPager.isComplexAction())
    	  pager.println("  <span class=\"itemsTitle\">"+pager.getTlHd().getSingleNodeValue("ItemsTitle")+"</span>");
      pager.print("</div>\r\n");
      pager.print("  \r\n");
      
      if(editPager.isComplexAction()) printItemsTable();
      
      if(!editPager.isNoSubmitButton()) printSubmitButtons();
      
      pager.print("</body>\r\n");
      pager.print("</html>");      
	}	
	
	/**
	 * 
	 */
	protected void printItemsTable()throws IOException{

	}
	
	protected void printSubmitButtons()throws IOException{
	      pager.println("<div style=\"padding-top:3;width:100%;height:10;\">");
	      pager.print("\t<table cellSpacing=0 cellPadding=0 width=\"100%\" align=center border=0 class=\"small\"> \r\n");
	      if(pager.isComplexAction()){
	          pager.println("\t<!--Remark 子表增删按钮区-->");
	          pager.println("\t<tr>");
	          pager.println("\t<td align=\"left\">");
	          pager.println("\t<input type=\"button\" class=\"button approve\" value=\"添加\" onClick=\"addItem()\"/>");
	          pager.println("\t<input type=\"button\" class=\"button approve\" value=\"删除\" onClick=\"deleteItem()\"/>");
	          pager.println("\t</td>");
	          pager.println("\t</tr>");    	  
	      }
	      pager.println("\t<!--Remark 页面保存按钮区-->");
	      pager.print("\t<tr>\r\n");
	      pager.print("\t\t<td colspan=\"4\" align=\"center\">\r\n");
	      if(!pager.isViewAction())
	    	  pager.print("\t\t<input type=\"button\" class=\"button save\" value=\"保存\" onClick=\"submitFunc()\"/>\r\n");
	     
	      if(!editPager.isNoCloseButton())
	    	  pager.print("\t\t<input type=\"button\" class=\"button cancel\" value=\"关闭\" onClick=\"window.close()\"/>\r\n");
	      pager.print("\t\t</td>\r\n");
	      pager.print("\t</tr>\r\n");
	      pager.print("\t</table>  \r\n"); 
	      pager.println("</div>");  			
	}
	
	
}
