/**
 * 
 */
package com.cnpc.jcdp.web.rad.template;

import java.io.IOException;
import java.util.List;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.page.QueryListPager;
import com.cnpc.jcdp.web.rad.util.RADConst.PAGER_OPEN_TYPE;
import com.cnpc.jcdp.web.rad.util.RADConst.QUERY_CDT_TYPE;

/**
 * @author rechete
 *
 */
public class CNPCOMSListTmpt extends BaseTmpt{
	private QueryListPager listPager;
	public CNPCOMSListTmpt(){
		this.open_type = PAGER_OPEN_TYPE.LINK;
		this.cdt_type = QUERY_CDT_TYPE.FORM;
	}
	
	public void printHeader()throws IOException{
		listPager = (QueryListPager)pager;
		pager.println("<html>");
		pager.println("<head>");
		pager.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\" />");
		pager.println("<link href=\""+pager.getContextPath()+"/css/a7_table.css\" rel=\"stylesheet\" type=\"text/css\" />");
		pager.println("<link href=\""+pager.getContextPath()+"/css/a7_ext.css\" rel=\"stylesheet\" type=\"text/css\" />");
		pager.println("<link href=\""+pager.getContextPath()+"/css/calendar-blue.css\" rel=\"stylesheet\" type=\"text/css\" />");		
		pager.println("<script language=\"JavaScript\" type=\"text/JavaScript\" src=\""+pager.getContextPath()+"/js/A7/DivHiddenOpen.js\"></script>");
		pager.println("<script language=\"JavaScript\" type=\"text/JavaScript\" src=\""+pager.getContextPath()+"/js/calendar.js\"></script>");				
		pager.println("<script language=\"JavaScript\" type=\"text/JavaScript\" src=\""+pager.getContextPath()+"/js/calendar-en.js\"></script>");				
		pager.println("<script language=\"JavaScript\" type=\"text/JavaScript\" src=\""+pager.getContextPath()+"/js/calendar-setup.js\"></script>");				
		pager.printPagerScript();
		pager.println("</head>");
	}
	
	private void printButtons()throws IOException{

		pager.println("<table  border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"Tab_new_mod_del\">");
		pager.println("  <tr class=\"ali7\">");
		pager.println("    <td>");
		List<ICfgNode> nodes = pager.getTlHd().selectNodes("//Buttons/Button");
  		if(nodes==null || nodes.size()==0) return;
  		String authStr = null;
		for(int i=0;i<nodes.size();i++){
        	ICfgNode node = nodes.get(i);
        	
        	if(node.getAttrValue("funCode")!=null){
        		if(!listPager.hasAuth(node.getAttrValue("funCode")))  authStr = "disabled";
        	}else authStr = "";
      		
        	if("Add".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" "+authStr+" value=\"新增\" onClick=\"toAdd()\">\r\n");
        	else if("View".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" "+authStr+" value=\"查看\" onClick=\"toView()\">\r\n");        	
        	else if("Edit".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" "+authStr+" value=\"修改\" onClick=\"toEdit()\">\r\n");
        	else if("Delete".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" "+authStr+" value=\"删除\" onClick=\"toDelete()\">\r\n");
        	else if("Back".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" "+authStr+" value=\"返回\" onClick=\"toBack()\">\r\n");
        	else if("sql".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" "+authStr+" value=\""+node.getAttrValue("Label")+"\" onClick=\"JcdpButton"+i+"OnClick()\">\r\n");
        	else if("link".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" "+authStr+" value=\""+node.getAttrValue("Label")+"\" onClick=\"JcdpButton"+i+"OnClick()\">\r\n");
        }
		pager.println("    </td>");
		pager.println("  </tr>");
		pager.println("</table>");
	}
	
	public void printBody()throws IOException{
		pager.println("<body onload=\"page_init()\">");
		if(!listPager.isList2Compose()){
			pager.println("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"Tab_page_title_wt\">");
			pager.println("  <tr>");
			pager.println("    <td class=\"Tab_page_title_text\">物探专业</td>");
			pager.println("    <td>");
			pager.println("	  <img src=\""+pager.getContextPath()+"/images/help.jpg\" width=\"15\" height=\"15\">");
			pager.println("	    <a id=\"pageSet\" style=\"cursor:hand;\" ");
			pager.println("	       >在线帮助</a>");
			pager.println("	</td>");
			pager.println("  </tr>");
			pager.println("</table>");
		}
		pager.println("<table  border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"Tab_page_title\" >");
		pager.println("  <tr class=\"Tab_page_title\">");
		pager.println("    <td id=\"cruTitle\" colspan=\"4\" class=\"Tab_Header\" >生产协调 -> 工农协调信息 -> 新增工农协调信息</td>");
		pager.println("  </tr>");
		pager.println("</table>	");	
		if(!listPager.isList2Compose()) printQueryCdt();
		
		printButtons();
		
		printTable();
		pager.println("</body>");
		pager.println("</html>");		
	}
	

	private void printQueryCdt()throws IOException{
		pager.println("<table  border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"form_info\" id=\"queryCdtTable\" enctype=\"multipart/form-data\" onSubmit=\"return Validator.Validate(this,2)\">");
		pager.println("<!--此处开发人员可添加查询条件-->");
		pager.println("<!--tr>");
		pager.println("    <td class=\"rtCDTFdName\">标题：</td>");
		pager.println("    <td class=\"rtCDTFdValue\"><input name=\"conflictName\" type=\"text\" class=\"input_width\" dataType=\"Limit\" max=\"35\" min=\"1\" msg=\"标题应该在35字之内，请重新输入！\" require=\"false\"/></td>");
		pager.println("    <td class=\"rtCDTFdName\">类型：</td>");
		pager.println("     <td class=\"rtCDTFdValue\" >");
		pager.println("	    <select name=\"conflictType\" class=\"input_width\">");
		pager.println("		    <option selected=\"selected\"></option>");
		pager.println("            <option value=\"1\">正在协调</option>");
		pager.println("            <option value=\"2\">遗留问题</option>");
		pager.println("        </select>");
		pager.println("	</td>    ");
		pager.println("  </tr-->");
		pager.println("  <tr>");
		pager.println("    <td colspan=\"4\" class=\"rtCDTFdName\"><input type=\"submit\" onclick=\"classicQuery()\" name=\"search\" value=\"查询\"  class=\"iButton2\"/></td>");
		pager.println("  </tr>  ");
		pager.println("</table>");		
		pager.println("<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"ali6\">");	
		pager.println("  <tr>");	
		pager.println("    <td><a href=\"#\" onClick=\"switchSysBar1();return false;\" onMouseOut=\"restoreImage(2)\" onMouseOver=\"changeImage(2)\"><img src=\""+pager.getContextPath()+"/images/21.gif\" name=\"ImageUp\" width=\"50\" height=\"8\" border=\"0\" ></a></td>");	
		pager.println("  </tr>");	
		pager.println("</table>	");		
	}
	
	
	protected void printTable()throws IOException{
		pager.println("<div class=\"eXtremeTable\" >");
		pager.println("<table border=\"0\"  cellpadding=\"0\"  cellspacing=\"0\"  class=\"toolbar\"  width=\"100%\" >");
		pager.println("	<tr>");
		pager.println("		<td></td>");
		pager.println("	<td><span id=\"dataRowHint\" class=\"record\" >找到1 条记录, 显示 1 到 1 </span></td>");
		pager.println("		<td align=\"right\" >");
		pager.println("		<table id=\"navTableId\" border=\"0\"  cellpadding=\"0\"  cellspacing=\"0\" >");
		pager.println("			<tr>");
		pager.println("				<td><img src=\"/OMS_Web_GPE/images/table/firstPageDisabled.gif\"  style=\"border:0\"  alt=\"第一页\" /></td>");
		pager.println("				<td><img src=\"/OMS_Web_GPE/images/table/prevPageDisabled.gif\"  style=\"border:0\"  alt=\"上一页\" /></td>");
		pager.println("				<td><img src=\"/OMS_Web_GPE/images/table/nextPageDisabled.gif\"  style=\"border:0\"  alt=\"下一页\" /></td>");
		pager.println("				<td><img src=\"/OMS_Web_GPE/images/table/lastPageDisabled.gif\"  style=\"border:0\"  alt=\"最后页\" /></td>");
		pager.println("			</tr>");
		pager.println("		</table>");
		pager.println("		</td>");
		pager.println("	</tr>");
		pager.println("</table>");
		
		pager.println("<div id=\"resultable\"  style=\"width:100%; overflow-x:scroll;\" >");		
		pager.println("<table border=\"0\"  cellspacing=\"0\"  cellpadding=\"0\"  class=\"eXtremeTable_info\"  width=\"100%\" id=\"queryRetTable\">");
		pager.println("	<thead>");
/*		pager.println("	<tr style=\"padding: 0px;\" >");
		pager.println("		<td colspan=\"7\" >");
		pager.println("		<table border=\"0\"  cellpadding=\"0\"  cellspacing=\"0\"  width=\"100%\" >");
		pager.println("			<tr>");
		pager.println("				<td class=\"statusBar\" ></td>");
		pager.println("			</tr>");
		pager.println("		</table>");
		pager.println("		</td>");
		pager.println("	</tr>");	*/	
		pager.println("");
		pager.println("	<tr>");
		
		List<String> colDatas = listPager.getColDatas();
		for(int i=0;i<colDatas.size();i++){
			if(i==0){
				String str = colDatas.get(i);
				if(str.indexOf("exp=\"<input type='checkbox'")>=0){
					str = str.replaceFirst("checkbox", "radio");
					str = str.substring(0,str.indexOf("<input type='checkbox'"));
					str += "选择</td>";
				}
				pager.println("		<td class=\"tableHeader\" "+str);
			}
			else pager.println("		<td class=\"tableHeader\" "+colDatas.get(i));
		}
/*		pager.println("		<td class=\"tableHeader\" exp=\"<input type='radio' name='chx_entity_id' value='{role_id}'>\">选择</td>");
		pager.println("		<td class=\"tableHeader\" exp=\"<a href='roleAndItems.cpmd?id={role_id}'>{role_c_name}</a>\">中文名称</td>");
		pager.println("				<td class=\"tableHeader\" exp=\"{role_e_name}\">英文名称</td>");*/
		pager.println("	</tr>");
		pager.println("	</thead>");
		pager.println("	<tbody class=\"tableBody\" >");
		pager.println("	");
		pager.println("	</tbody>");
		pager.println("</table>");
		pager.println("</div>");
		
		pager.println("</div>");				
	}
	

}
