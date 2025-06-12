/**
 * 主子表页面2
 * 主子表在同一编辑页面
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.util.RADConst;

/**
 * @author rechete
 *
 */
public class EditCpmxPager extends EditPager{
	
	public EditCpmxPager(){
		pmdAction = RADConst.PMDAction.C_U;
	}
	
  	protected void printPageInit()throws IOException{
  		print("\r\n");
        print("function page_init(){\r\n");
        print("\tgetObj('cruTitle').innerHTML = cruTitle;\r\n");
        print("\tcruConfig.contextPath = \"");
        print(contextPath);
        print("\";\r\n");
        if("1".equals(lineRange))
        	print("\tcruConfig.lineRange = '1';\r\n");        
		sql = replaceParams(sql);
        print("\tcruConfig.querySql = \""+sql+"\";\r\n");
        itemsSql = replaceParams(itemsSql);
        println("\tcruConfig.queryItemsSql =\""+itemsSql+"\";");
        print("\tcmpx_init();\r\n");
        print("}\r\n");  		
  	} 
  	
  	protected void printFields(HttpServletRequest request,String action)throws IOException{
  		super.printFields(request, action);
  		List<ICfgNode> nodes = tlHd.selectNodes("//ItemFields/field");
  		StringBuffer sb = new StringBuffer(",");
  		if(nodes!=null)
  			for(int i=0;i<nodes.size();i++){
  				ICfgNode node = nodes.get(i);
  				String cruAction = node.getAttrValue("action");
  				if(cruAction!=null && cruAction.indexOf("U")<0) continue;
  				if("ReadOnly".equals(node.getAttrValue("isShow"))) continue;
  				sb.append(node.getAttrValue("name")+","); 
  			}
  		println("var itemFields ='"+sb.toString()+"';");
  	}
  	
  	protected void printSubmitJs()throws IOException{
        print("\r\n");
        print("function submitFunc(){\r\n");
        print("\tvar path = cruConfig.contextPath+cruConfig.updateCmpxAction;\r\n");
        print("\tsubmitStr = getSubmitStr();\r\n");
        print("\tif(submitStr == null) return;\r\n"); 
        println("\tsubmitStr = \"entityParam=\"+convertSubmitStr2JSONObj(submitStr).toJSONString();");
        println("\tvar itemsParam = getItemsParam();");
        println("\tsubmitStr += \"&itemsParam=\"+itemsParam.toJSONString();");
        String itemTableName = tlHd.getSingleNodeValue("QueryItemsSQL/tableName");
        String itemTableFk = tlHd.getSingleNodeValue("QueryItemsSQL/fkName");
        println("\tsubmitStr += \"&itemTableName="+itemTableName+"&itemTableFk="+itemTableFk+"\";");
        print("\tvar retObject = syncRequest('Post',path,submitStr);\r\n");
        print("\tif (retObject.returnCode != \"0\") alert(\"编辑失败!\");\r\n");
        print("\telse{\r\n");
        print("\t\talert(\"编辑成功!\");\r\n");
//        print("\t\twindow.opener.refreshData();\r\n");
//        print("\t\twindow.close();\r\n");
        
        print("\t\t"+tpt.getParentRefreshFunc()+"\r\n");
        print("\t\t"+tpt.getWindowCloseFunc()+"\r\n");
        print("\t}\r\n");
        print("}\r\n");
        print("\r\n");  	
        
  	}  	
  	
  	protected void printOtherJs()throws IOException{
  		println("");
  		println("function initItems(itemDatas){");
  		println("\tif(itemDatas==undefined || itemDatas.length==0){");
  		println("\t\taddItem();");
  		println("\t\treturn;");
  		println("\t}");
  		println("");
  		println("\tvar itemsTable = getObj(\"itemsTable\");");
  		println("\tfor(var i=0;i<itemDatas.length;i++){");
  		println("\t\taddItem();");
  		println("\t\tvar vTr = itemsTable.rows[itemsTable.rows.length-1];");
  		println("\t\tfor(var j=0;j<vTr.all.length;j++){");
  		println("\t\t\tvar obj = vTr.all(j);");
  		println("\t\t\tif (obj.tagName == \"INPUT\" && obj.name!=null) {");
  		println("\t\t\t\tobj.value = eval('itemDatas[i].'+obj.name);");
  		println("\t\t\t}");
  		println("\t\t}");
  		println("\t}");  		
  		println("}");
  		println("");
  	}
  	
  	
    protected void printItemsTable(HttpServletRequest request)throws IOException{
    	String popSize = request.getParameter("popSize");
    	int windowHeight = RADConst.POP_WINDOW_HEIGHT;
    	if(popSize!=null && popSize.indexOf(":")>0){
    		windowHeight = Integer.parseInt(popSize.substring(popSize.indexOf(":")+1));
    	}
    	List<ICfgNode> nodes = tlHd.selectNodes("//ItemFields/field");    
    	println("<!--Remark 子表-->");
    	println("<div  style=\"width:100%;height:"+(windowHeight-100-cruTableHeight)+";overflow-x:hidden;overflow-y:auto;border-bottom:0px;border-right:1px outset;dashed #000000;\">");
    	println("<table id=\"itemsTable\"  class=\"itemsTable\">");    	
    	println("<thead>");
    	println("<tr>");
    	println("\t<td></td>");
    	for(int i=1;i<nodes.size();i++){
    		ICfgNode node = nodes.get(i);
    		println("\t<td>"+node.getValue()+"</td>");
    	}
    	println("</tr>");
    	println("</thead>");
    	println("<tr style=\"display:none\">");
    	for(int i=0;i<nodes.size();i++){
    		ICfgNode node = nodes.get(i);
    		if(i==0){
    			println("\t<td><input type=\"checkbox\" value=\"\" name=\""+node.getAttrValue("name")+"\"></td>");
    			continue;
    		}
    		String size = node.getAttrValue("size");
    		if(size==null) size = "10";
    		println("\t<td><input type=\"text\" size=\""+size+"\" name=\""+node.getAttrValue("name")+"\"></td>");
    	}
    	println("</tr>");
    	println("</table>");
    	println("</div>");
    	println("");
    }
}
