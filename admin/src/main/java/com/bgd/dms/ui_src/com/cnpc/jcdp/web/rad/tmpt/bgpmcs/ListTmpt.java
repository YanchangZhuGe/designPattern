/**
 * BGPMCSģ��
 */
package com.cnpc.jcdp.web.rad.tmpt.bgpmcs;

import java.io.IOException;
import java.util.List;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.page.QueryListPager;
import com.cnpc.jcdp.web.rad.template.BaseTmpt;
import com.cnpc.jcdp.web.rad.util.RADConst.PAGER_OPEN_TYPE;
import com.cnpc.jcdp.web.rad.util.RADConst.QUERY_CDT_TYPE;

/**
 * @author rechete
 *
 */
public class ListTmpt extends BaseTmpt{
	private QueryListPager listPager;
	
	public ListTmpt(){
		this.open_type = PAGER_OPEN_TYPE.LINK;
		this.cdt_type = QUERY_CDT_TYPE.FORM;
	}
	
	public void printHeader()throws IOException{
		listPager = (QueryListPager)pager;
		pager.println("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">");
		pager.println("<html>");
		pager.println("<head>");
		pager.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\" />");
		pager.println("<link href=\""+pager.getContextPath()+"/css/bgpmcs_table.css\" rel=\"stylesheet\" type=\"text/css\" />");
		pager.println("<link href=\""+pager.getContextPath()+"/css/common.css\" rel=\"stylesheet\" type=\"text/css\" />");
		pager.println("<link href=\""+pager.getContextPath()+"/css/calendar-blue.css\" rel=\"stylesheet\" type=\"text/css\" />");		
		pager.println("<script language=\"JavaScript\" type=\"text/JavaScript\" src=\""+pager.getContextPath()+"/js/bgpmcs/DivHiddenOpen.js\"></script>");
		pager.println("<link href=\""+pager.getContextPath()+"/js/extjs/resources/css/ext-all.css\" rel=\"stylesheet\" type=\"text/css\" />");	
		pager.println("<script type=\"text/javascript\" src=\""+pager.getContextPath()+"/js/extjs/adapter/ext/ext-base.js\"></script>");	
		pager.println("<script type=\"text/javascript\" src=\""+pager.getContextPath()+"/js/extjs/ext-all.js\"></script>");	
		pager.printPagerScript();
		//���ڿؼ�js
		pager.println("<script type=\"text/javascript\" src=\"/BGPMCS/js/calendar.js\"></script>");
		pager.println("<script type=\"text/JavaScript\" src=\"/BGPMCS/js/calendar-zh.js\"></script>");
		pager.println("<script type=\"text/javascript\" src=\"/BGPMCS/js/calendar-setup.js\"></script>");
		
		pager.println("</head>");
	}
	
	private void printButtons()throws IOException{
		List<ICfgNode> nodes = pager.getTlHd().selectNodes("//Buttons/Button");
  		if(nodes==null || nodes.size()==0) return;
  		
		pager.println("<table  border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"Tab_new_mod_del\">");
		pager.println("  <tr class=\"ali7\">");
		pager.println("    <td>");

		for(int i=0;i<nodes.size();i++){
        	ICfgNode node = nodes.get(i);
        	
        	//��ȡ��ť�Ĺ���Ȩ�޴���
        	String funCode = node.getAttrValue("funCode");
        	// �����ǰ�û�û�д˹���Ȩ�ޣ�����ʾ��ť
        	if(funCode!=null && !funCode.equals("")){ //  && !listPager.hasAuth(funCode)
        		boolean hasAuth = false;
        		String[] funCodes = funCode.split(",");
        		for(int k=0;k<funCodes.length;k++){
        			if(listPager.hasAuth(funCodes[k])){
        				hasAuth = true;
        				break;
        			}
        		}
        		if(!hasAuth) continue;
        	}
        	
        	if("Add".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" value=\"����\" onClick=\"toAdd()\">\r\n");
        	/*else if("View".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" value=\"�鿴\" onClick=\"toView()\">\r\n"); */       	
        	else if("Edit".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" value=\"�޸�\" onClick=\"toEdit()\">\r\n");
        	else if("Delete".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" value=\"ɾ��\" onClick=\"toDelete()\">\r\n");
        	else if("Back".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" value=\"����\" onClick=\"toBack()\">\r\n");
        	else if("sql".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" value=\""+node.getAttrValue("Label")+"\" onClick=\"JcdpButton"+i+"OnClick()\">\r\n");
        	else if("link".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" value=\""+node.getAttrValue("Label")+"\" onClick=\"JcdpButton"+i+"OnClick()\">\r\n");
        	/*else if("ShowQuery".equals(node.getAttrValue("Type")))
        		pager.print("<input class=\"iButton2\" type=\"button\" value=\"�߼���ѯ\" onClick=\"showQuery()\" id=\"ShowQueryButton\" >\r\n");*/
        }
		//pager.print("<input class=\"iButton2\" type=\"button\" value=\"�߼���ѯ\" id=\"queryButton\" onClick=\"showQuery()\">\r\n");
		pager.println("    </td>");
		pager.println("  </tr>");
		pager.println("</table>");
	}
	
	public void printBody()throws IOException{
		pager.println("<body onload=\"page_init()\">");
//		if(!listPager.isList2Compose()){
//			pager.println("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"Tab_page_title\">");
//			pager.println("  <tr>");
//			pager.println("			<td height=1 colspan=\"4\" align=left></td>");
//			pager.println("  </tr>");
//			pager.println("  <tr>");			
//			pager.println("			<td width=\"5%\"   height=28 align=left ><img src=\""+pager.getContextPath()+"/images/oms_index_09.gif\" width=\"100%\" height=\"28\" /></td>");
//			pager.println("			<td id=\"cruTitle\" width=\"40%\" align=left background=\""+pager.getContextPath()+"/images/oms_index_11.gif\" class=\"text11\">");
//			pager.println("            	����ͳ�� -> Һ������");
//			pager.println("          	</td>");
//			pager.println("			<td width=\"5%\" align=left ><img src=\""+pager.getContextPath()+"/images/oms_index_13.gif\" width=\"100%\" height=\"28\" /></td>");
//			pager.println("			<td width=\"50%\" align=left style=\"background:url("+pager.getContextPath()+"/images/oms_index_14.gif) repeat-x;\">&nbsp;</td>");
//			pager.println("  </tr>");
//			pager.println("</table>");
//		}
		if(!listPager.isList2Compose()) printQueryCdt();
		
		printButtons();
		
		printTable();
		pager.println("</body>");
		pager.println("</html>");		
	}
	

	private void printQueryCdt()throws IOException{
		if(listPager.hasQueryCdts()){
			pager.println("<div id=\"queryDiv\" style=\"display:\">");
			pager.println("<table  border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"form_info\" id=\"queryCdtTable\" enctype=\"multipart/form-data\">");
//			pager.println("<!--�˴�������Ա����Ӳ�ѯ����-->");
//			pager.println("<!--tr>");
//			pager.println("    <td class=\"rtCDTFdName\">���⣺</td>");
//			pager.println("    <td class=\"rtCDTFdValue\"><input name=\"conflictName\" type=\"text\" class=\"input_width\" dataType=\"Limit\" max=\"35\" min=\"1\" msg=\"����Ӧ����35��֮�ڣ����������룡\" require=\"false\"/></td>");
//			pager.println("    <td class=\"rtCDTFdName\">���ͣ�</td>");
//			pager.println("     <td class=\"rtCDTFdValue\" >");
//			pager.println("	    <select name=\"conflictType\" class=\"input_width\">");
//			pager.println("		    <option selected=\"selected\"></option>");
//			pager.println("            <option value=\"1\">����Э��</option>");
//			pager.println("            <option value=\"2\">��������</option>");
//			pager.println("        </select>");
//			pager.println("	</td>    ");
//			pager.println("  </tr-->");
			pager.println("  <tr class=\"ali4\">");
			pager.print("    <td colspan=\"4\"><input type=\"submit\" onclick=\"classicQuery()\" name=\"search\" value=\"��ѯ\"  class=\"iButton2\"/>");
			pager.println("  <input type=\"reset\" name=\"reset\" value=\"���\" onclick=\"clearQueryCdt()\" class=\"iButton2\"/></td>");		
			pager.println("  </tr>  ");
			pager.println("</table>");		
			pager.println("</div>");	
		}
	}
	
	
	protected void printTable()throws IOException{
	      pager.print("<!--Remark ��ѯָʾ����-->\r\n");
	      pager.print("<div id=\"rtToolbarDiv\">\r\n");
	      pager.print("<table border=\"0\"  cellpadding=\"0\"  cellspacing=\"0\"  class=\"rtToolbar\"  width=\"100%\" >\r\n");
	      pager.print("\t<tr>\r\n");
	      //pager.print("\t\t<td></td>\r\n");
	      pager.print("\t\t<td align=\"right\" >\r\n");
	      pager.print("\t\t\t<span id=\"dataRowHint\">��0/0ҳ,��0����¼ </span>\r\n");
	      
	      pager.print("\t\t\t<table id=\"navTableId\" border=\"0\"  cellpadding=\"0\"  cellspacing=\"0\" style=\"display:inline\">\r\n");
	      pager.print("\t\t\t\t<tr>\r\n");
	      pager.print("\t\t\t\t\t<td><img src=\"");
	      pager.print(pager.getContextPath());
	      pager.print("/images/table/firstPageDisabled.gif\"  style=\"border:0\"  alt=\"First\" /></td>\r\n");
	      pager.print("\t\t\t\t\t<td><img src=\"");
	      pager.print(pager.getContextPath());
	      pager.print("/images/table/prevPageDisabled.gif\"  style=\"border:0\"  alt=\"Prev\" /></td>\r\n");
	      pager.print("\t\t\t\t\t<td><img src=\"");
	      pager.print(pager.getContextPath());
	      pager.print("/images/table/nextPageDisabled.gif\"  style=\"border:0\"  alt=\"Next\" /></td>\r\n");
	      pager.print("\t\t\t\t\t<td><img src=\"");
	      pager.print(pager.getContextPath());
	      pager.print("/images/table/lastPageDisabled.gif\"  style=\"border:0\"  alt=\"Last\" /></td>\t\t\t\t\r\n");
	      pager.print("\t\t\t\t</tr>\r\n");
	      pager.print("\t\t\t</table>\r\n");
	      
	      pager.print("\t\t\t<span>��&nbsp;<input type=\"text\"  id=\"changePage\"  class=\"rtToolbar_chkboxme\">&nbsp;ҳ");
	      pager.print("<a href='javascript:changePage()'><img src='");
	      pager.print(pager.getContextPath());
	      pager.print("/images/table/bullet_go.gif' alt='Go' align=\"absmiddle\" /></a></span>\t\t\r\n");
	      
	      pager.print("\t\t</td>\r\n");
	      pager.print("\t</tr>\r\n");
	      pager.print("</table>\r\n");
	      pager.print("</div>\r\n");
	      pager.print("\r\n");
		
		pager.println("<div id=\"resultable\"  style=\"width:100%; overflow-x:scroll ;\" >");
		pager.println("<table border=\"0\"  cellspacing=\"0\"  cellpadding=\"0\"  class=\"form_info\"  width=\"100%\" id=\"queryRetTable\">");
		pager.println("	<thead>");
		pager.println("");
		pager.println("	<tr class=\"bt_info\">");
		
		List<String> colDatas = listPager.getColDatas();
		for(int i=0;i<colDatas.size();i++){
			String str = colDatas.get(i);
			pager.println("		<td class=\"tableHeader\" "+str);
			
			//��һ�к��ӡ�����
			if(i==0 && str.indexOf("isShow=\"TextHide\"")<0 && str.indexOf("name='chx_entity_id'")>0){// ����ѡ��ҳ�棬������ѡ���һ��

				pager.println("		<td class=\"tableHeader\" autoOrder=\"1\">���</td> ");
				
			}
			//System.out.println(str);
		}
		pager.println("	</tr>");
		pager.println("	</thead>");
		pager.println("	<tbody>");
		pager.println("	");
		pager.println("	</tbody>");
		pager.println("</table>");
//		
//		pager.println("<table style=\"height:1px;\">");
//		pager.println("	<tr><td>&nbsp;</td><tr>");
//		pager.println("</table>");
//		
		pager.println("</div>");
		
	}
	

}
