/**
 * 默认风格-列表页面
 */
package com.cnpc.jcdp.web.rad.template;

import java.io.IOException;
import java.util.List;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.page.QueryListPager;
import com.cnpc.jcdp.web.rad.util.RADConst.LISTTYPE;
import com.cnpc.jcdp.web.rad.util.RADConst.PAGER_OPEN_TYPE;
import com.cnpc.jcdp.web.rad.util.RADConst.QUERY_CDT_TYPE;

/**
 * @author rechete
 *
 */
public class DefaultListTmpt extends BaseTmpt{
	private QueryListPager listPager;
	
	public DefaultListTmpt(){
		this.open_type = PAGER_OPEN_TYPE.POP;
		this.cdt_type = QUERY_CDT_TYPE.SELECT;
	}
	
	public void printHeader()throws IOException{
		listPager = (QueryListPager)pager;
		pager.print("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
		pager.print("<head>\r\n");
		pager.print("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\" />\r\n");
		  if(pager.isToJspRequest()){
			  pager.print("<%@ include file=\"/common/pmd_list.jsp\"%>\r\n");
		  }
		  else{
			  pager.print("<script type=\"text/javascript\" src=\"");
			  pager.print(pager.getContextPath());
			  pager.print("/js/rt/rt_list.js\"></script>  \r\n");
			  pager.print("<script type=\"text/javascript\" src=\"");
			  pager.print(pager.getContextPath());
			  pager.print("/js/rt/rt_base.js\"></script>\r\n");
			  pager.print("<script type=\"text/javascript\" src=\"");
			  pager.print(pager.getContextPath());
			  pager.print("/js/rt/rt_search.js\"></script>\r\n");
			  pager.print("<script type=\"text/javascript\" src=\"");
			  pager.print(pager.getContextPath());
			  pager.print("/js/json.js\"></script>\r\n");      
			  pager.print("\r\n");
			  pager.print("<link rel=\"stylesheet\" href=\"");
			  pager.print(pager.getContextPath());
			  pager.print("/css/rt_table.css\" type=\"text/css\" />  \r\n");
			  pager.print("<link rel=\"stylesheet\" href=\"");
			  pager.print(pager.getContextPath());
			  pager.print("/css/common.css\" type=\"text/css\" />\r\n");
			  pager.print("<link rel=\"stylesheet\" href=\"");
			  pager.print(pager.getContextPath());
			  pager.print("/css/main.css\" type=\"text/css\" />\r\n");
		  }
		  pager.printPagerScript();	
	}
	
	private void printButtons()throws IOException{
  		//不是列表查看页面，无上面的新增、编辑、删除按钮，返回
  		//if(listType!=LISTTYPE.List2View) return;
  		
  		List<ICfgNode> nodes = pager.getTlHd().selectNodes("//Buttons/Button");
  		if(nodes==null || nodes.size()==0) return;
        pager.print("<div id=\"div_button\">\r\n");
        pager.print("<table  cellSpacing=0 cellPadding=0 border=0 >\r\n");
        pager.print("<tr>\r\n");
        pager.print("<td>\r\n");  		
	        for(int i=0;i<nodes.size();i++){
	        	ICfgNode node = nodes.get(i);
	        	String funcCode = node.getAttrValue("funCode");
	        	String authStr = "";
	        	if(funcCode!=null && !"".equals(funcCode.trim())){
	        		if(!pager.hasAuth(funcCode)) authStr = "disabled";
	        	}
	        	if("Add".equals(node.getAttrValue("Type")))
	        		pager.print("<input class=\"button general\" type=\"button\" value=\"添加\" "+authStr+" onClick=\"toAdd()\">\r\n");
	        	else if("Edit".equals(node.getAttrValue("Type")))
	        		pager.print("<input class=\"button general\" type=\"button\" value=\"编辑\" "+authStr+" onClick=\"toEdit()\">\r\n");
	        	else if("Delete".equals(node.getAttrValue("Type")))
	        		pager.print("<input class=\"button prompt\" type=\"button\" value=\"删除\" "+authStr+" onClick=\"toDelete()\">\r\n");
	        	else if("Back".equals(node.getAttrValue("Type")))
	        		pager.print("<input class=\"button other\" type=\"button\" value=\"返回\" "+authStr+" onClick=\"toBack()\">\r\n");
	        	else 
	        		pager.print("<input class=\"button other\" type=\"button\" "+authStr+" value=\""+node.getAttrValue("Label")+"\" onClick=\"JcdpButton"+i+"OnClick()\">\r\n");
	        	
	        }        
        
        
        pager.print("</td>\r\n");
        pager.print("</tr>\r\n");
        pager.print("</table>\r\n");
        pager.print("</div>\r\n");
        pager.print("\r\n");  
	}
	
	public void printBody()throws IOException{
		pager.println("<body onload=\"page_init()\">");
		//标题
		pager.print("<!--Remark 标题-->\r\n");
		pager.print("<div id=\"nav\">\r\n");
		pager.print("  <ul><li id=\"cruTitle\" style=\"filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(");
		pager.print("src='"+pager.getContextPath()+"/images/manage_r2_c13.jpg', sizingMethod='scale')\"></li></ul>\r\n");
		pager.print("</div>\r\n");
		pager.print("\r\n");
		
		//功能按钮
		pager.print("<!--Remark 按钮区域-->\r\n");
		printButtons();
		
		//查询条件
		if(listPager.hasQueryCdts()) printQueryCdt();		
		
		//list2Select 选择按钮
		if(listPager.getListType()==LISTTYPE.List2Sel) printSelectButton();
			
		//查询结果
		printTable();
		
		pager.print("</body>\r\n");
		pager.print("</html>\r\n");	
	}
	

	private void printQueryCdt()throws IOException{
      pager.print("<!--Remark 快捷查询区域-->\r\n");
      pager.print("<div id=\"basicSearch\" >\r\n");
      pager.print("<table class=\"searchUIBasic\" cellSpacing=0 cellPadding=2 width=\"100%\" align=center border=0>\r\n");
      pager.print("<tr>\r\n");
      pager.print("<td width=\"60\" align=left noWrap>\r\n");
      pager.print("\t<span><img src=\"");
      pager.print(pager.getContextPath());
      pager.print("/images/search.gif\" width=\"25\"></span><br>\r\n");
      pager.print("\t<span ><a class=\"tishi_1txt\" href=\"javascript:divHide('basicSearch');divShow('advanceSearch');\">组合查询</a></span>\r\n");
      pager.print("</td>\r\n");
      pager.print("\r\n");
      pager.print("<td width=\"150\" class=noWrap>\r\n");
      pager.print("\t<select id=bas_field style=\"WIDTH: 150px\" onChange=\"updateFieldOption(this, 'bas_cdt','bas_sel','bas_input');\" /> \r\n");
      pager.print("</td>\r\n");
      pager.print("<td width=\"100\" class=\"noWrap\">\r\n");
      pager.print("\t<select style='WIDTH: 100px' id=\"bas_cdt\"/>\r\n");
      pager.print("</td>\r\n");
      pager.print("<td width=\"120\" class=\"noWrap\">\r\n");
      pager.print("\t<input class=txtBox style=\"WIDTH:120px\" id=\"bas_input\" style=\"display:none\">\r\n");
      pager.print("\t<select class=txtBox id=bas_sel style=\"WIDTH: 120px\"/> \r\n");
      pager.print("</td>\r\n");
      pager.print("<td class=\"noWrap\" align=\"left\">\r\n");
      pager.print("\t<input class=\"button general\" onClick=\"basicQuery();\" type=button value=\" 查找 \" name=submit>&nbsp; \r\n");
      pager.print("</td>\r\n");
      pager.print("<td ></td>\r\n");
      pager.print("</tr>\r\n");
      pager.print("</table>\r\n");
      pager.print("</div>\r\n");
      pager.print("\r\n");	  
      
      pager.print("<!--Remark 组合查询区域-->\r\n");
      pager.print("<div id=\"advanceSearch\" style=\"display:none\">\r\n");
      pager.print("<table class=\"searchUIBasic\" cellSpacing=0 cellPadding=0 width=\"100%\" align=center border=0>\r\n");
      pager.print("<tr>\r\n");
      pager.print("\t<td width=\"60\">\r\n");
      pager.print("\t<span><img src=\"");
      pager.print(pager.getContextPath());
      pager.print("/images/search.gif\" width=\"25\"></span>\r\n");
      pager.print("\t<br>\r\n");
      pager.print("\t<span ><a class=\"tishi_1txt\" href=\"javascript:divHide('advanceSearch');divShow('basicSearch');\">快捷查询</a></span>\t\r\n");
      pager.print("\t</td>\r\n");
      pager.print("\t\r\n");
      pager.print("  <td width=\"380\">\r\n");
      pager.print("  \t<div class=small id=fixed style=\"BORDER-RIGHT: #cccccc 1px solid; PADDING-RIGHT: 0px; BORDER-TOP: #cccccc 1px solid; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; OVERFLOW: auto; BORDER-LEFT: #cccccc 1px solid; WIDTH: 410; PADDING-TOP: 0px; BORDER-BOTTOM: #cccccc 1px solid; POSITION: relative; HEIGHT: 85px; BACKGROUND-COLOR: #FFFFCC\">\r\n");
      pager.print("    <table id=\"ComplexTable\" width=\"95%\" border=0>\r\n");
      pager.print("      <tr>\r\n");
      pager.print("        <td><select style=\"WIDTH: 150px\" onChange=\"updateCmpOption(this)\" name='cmp_field'/>\r\n");
      pager.print("              </td>\r\n");
      pager.print("        <td><select style='WIDTH: 100px' name='cmp_cdt'/></td>             \r\n");
      pager.print("        <td width=\"50%\"><input name='cmp_input' style=\"WIDTH:120px\">\r\n");
      pager.print("        \t<select name='cmp_sel' style=\"WIDTH: 120px\"/> \r\n");
      pager.print("        </td>\r\n");
      pager.print("      </tr>\r\n");
      pager.print("      <tr>\r\n");
      pager.print("        <td><select style=\"WIDTH: 150px\" onChange=\"updateCmpOption(this)\" name='cmp_field'/>\r\n");
      pager.print("              </td>\r\n");
      pager.print("        <td><select style='WIDTH: 100px' name='cmp_cdt'/></td>             \r\n");
      pager.print("        <td width=\"50%\"><input name='cmp_input' style=\"WIDTH:120px\">\r\n");
      pager.print("        \t<select name='cmp_sel' style=\"WIDTH: 120px\"/> \r\n");
      pager.print("        </td>\r\n");
      pager.print("      </tr>\r\n");
      pager.print("      <tr>\r\n");
      pager.print("        <td><select style=\"WIDTH: 150px\" onChange=\"updateCmpOption(this)\" name='cmp_field'/>\r\n");
      pager.print("              </td>\r\n");
      pager.print("        <td><select style='WIDTH: 100px' name='cmp_cdt'/></td>             \r\n");
      pager.print("        <td width=\"50%\"><input name='cmp_input' style=\"WIDTH:120px\">\r\n");
      pager.print("        \t<select name='cmp_sel' style=\"WIDTH: 120px\"/> \r\n");
      pager.print("        </td>\r\n");
      pager.print("      </tr>\r\n");
      pager.print("    </table>\r\n");
      pager.print("  </div></td>\r\n");
      pager.print("  \r\n");
      pager.print("\t<td align=left>\r\n");
      pager.print("\t<table cellSpacing=0 cellPadding=0 align=left border=0>\r\n");
      pager.print("\t\t<tr>\t\r\n");
      pager.print("\t\t<td height=\"34\" align=center>\r\n");
      pager.print("\t\t  <input class=\"button general\" onClick=\"cmpQuery();\" type=button value=\" 查找 \"> \r\n");
      pager.print("\t\t</td>\r\n");
      pager.print("\t\t</tr>\r\n");
      pager.print("\t\t<tr>\r\n");
      pager.print("\t\t<td height=\"36\" align=center>\r\n");
      pager.print("\t\t<input class=\"button other\" onClick=\"addSearchRow()\" type=button value=\"添加条件\" name=more> \r\n");
      pager.print("\t\t<input class=\"button other\" onclick=deleteSearchRow() type=button value=\"减少条件\" name=button>\r\n");
      pager.print("\t\t</td>\r\n");
      pager.print("\t\t</tr>\r\n");
      pager.print("\t\r\n");
      pager.print("\t\t</table>\r\n");
      pager.print("\t</td>\r\n");
      pager.print("\t<td></td>\t\r\n");
      pager.print("</tr>\r\n");
      pager.print("</table>\r\n");
      pager.print("</div>\r\n");
      pager.print("\r\n");      	
	}
	
	/**
	 * 输出查询列表结果
	 * @throws IOException
	 */
	protected void printTable()throws IOException{
      pager.print("<!--Remark 查询指示区域-->\r\n");
      pager.print("<div id=\"rtToolbarDiv\">\r\n");
      pager.print("<table border=\"0\"  cellpadding=\"0\"  cellspacing=\"0\"  class=\"rtToolbar\"  width=\"100%\" >\r\n");
      pager.print("\t<tr>\r\n");
      pager.print("\t\t<td></td>\r\n");
      pager.print("\t<td>\r\n");
      pager.print("\t\t<span id=\"dataRowHint\">第0/0页,共0条记录 </span>&nbsp;&nbsp;\r\n");
      pager.print("\t\t到&nbsp;<input type=\"text\"  id=\"changePage\"  class=\"rtToolbar_chkboxme\">&nbsp;页\r\n");
      pager.print("\t\t<a href='javascript:changePage()'><img src='");
      pager.print(pager.getContextPath());
      pager.print("/images/table/bullet_go.gif'    alt='Go' align=\"absmiddle\" /></a>\t\t </td>\r\n");
      pager.print("\t\t<td align=\"right\" >\r\n");
      pager.print("\t\t<table id=\"navTableId\" border=\"0\"  cellpadding=\"0\"  cellspacing=\"0\" >\r\n");
      pager.print("\t\t\t<tr>\r\n");
      pager.print("\t\t\t\t<td><img src=\"");
      pager.print(pager.getContextPath());
      pager.print("/images/table/firstPageDisabled.gif\"  style=\"border:0\"  alt=\"First\" /></td>\r\n");
      pager.print("\t\t\t\t<td><img src=\"");
      pager.print(pager.getContextPath());
      pager.print("/images/table/prevPageDisabled.gif\"  style=\"border:0\"  alt=\"Prev\" /></td>\r\n");
      pager.print("\t\t\t\t<td><img src=\"");
      pager.print(pager.getContextPath());
      pager.print("/images/table/nextPageDisabled.gif\"  style=\"border:0\"  alt=\"Next\" /></td>\r\n");
      pager.print("\t\t\t\t<td><img src=\"");
      pager.print(pager.getContextPath());
      pager.print("/images/table/lastPageDisabled.gif\"  style=\"border:0\"  alt=\"Last\" /></td>\t\t\t\t\r\n");
      pager.print("\t\t\t</tr>\r\n");
      pager.print("\t\t</table>\r\n");
      pager.print("\t\t</td>\r\n");
      pager.print("\t</tr>\r\n");
      pager.print("</table>\r\n");
      pager.print("</div>\r\n");
      pager.print("\r\n");
      
      pager.print("<!--Remark 查询结果显示区域-->\r\n");	
      List<ICfgNode> nodes = pager.getTlHd().selectNodes("DataList/data"); 		
  	  pager.print("<div style=\"OVERFLOW-y:scroll;\">\r\n");
  	  pager.println("<table class=\"rtTable\" id=\"queryRetTable\">");
  	  pager.print("<thead>\r\n");
  	  pager.print("<tr>\r\n");	    
		for(int i=0;i<nodes.size();i++){
			ICfgNode node = nodes.get(i);
			String exp = node.getAttrValue("exp");
			//exp = exp.replaceAll("href='/", "href='"+pager.getContextPath()+"/");
			//exp = exp.replaceAll("popWindow\\u0028'/", "popWindow('"+pager.getContextPath()+"/");
			exp = pager.replaceListExp(exp);
			StringBuffer sb = new StringBuffer("\t<td exp=\""+exp+"\"");
			String func = node.getAttrValue("func");
			if(func!=null){
				func = pager.replaceListExp(func);
				sb.append(" func=\""+func+"\"");
			}
			if(node.getAttrValue("isShow")!=null){
				sb.append(" isShow=\""+node.getAttrValue("isShow")+"\"");
				if("Hide".equals(node.getAttrValue("isShow")) || "TextHide".equals(node.getAttrValue("isShow")))
					sb.append(" style=\"display:none\"");
			}
			if(node.getAttrValue("fieldName")!=null)
				sb.append(" fieldName=\""+node.getAttrValue("fieldName")+"\"");
			if(node.getAttrValue("size")!=null)
				sb.append(" size=\""+node.getAttrValue("size")+"\"");			
			sb.append(">");
			if(exp!=null && exp.indexOf("type='checkbox'")>0 && exp.indexOf("name='chx_entity_id'")>0){
				sb.append("<input type='checkbox' id='headChxBox' onclick=\"head_chx_box_changed(this)\">");
			}
			else sb.append(node.getValue());
			sb.append("</td>\r\n");
			pager.print(sb.toString());
		} 	    

  	  pager.print("</tr>\r\n");
  	  pager.print("</thead>\r\n");
  	  pager.print("</table>\r\n");
  	  pager.print("</div>\r\n");
  	  pager.print("\r\n");	      
	}
	
	/**
	 * 针对List2Select页面，打印确认按钮
	 * @throws IOException
	 */
	protected void printSelectButton()throws IOException{
      pager.print("<div id=\"div_button\">\r\n");
      pager.print("<table  cellSpacing=0 cellPadding=0 border=0 >\r\n");
      pager.print("<tr>\r\n");
      pager.print("<td >\r\n");
  	  pager.print("<input class=\"button general\" type=\"button\" value=\"确认\" onClick=\"selectEntities()\">\r\n");
  	  pager.print("<input class=\"button general\" type=\"button\" value=\"关闭\" onClick=\"window.close()\">\r\n");  		
      pager.print("</td>\r\n");
      pager.print("</tr>\r\n");
      pager.print("</table>\r\n");
      pager.print("</div>\r\n");
      pager.print("\r\n"); 		
	}
	
}
