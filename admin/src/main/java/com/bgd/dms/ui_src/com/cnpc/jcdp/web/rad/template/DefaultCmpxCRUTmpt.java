/**
 * 
 */
package com.cnpc.jcdp.web.rad.template;

import java.io.IOException;
import java.util.List;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.page.EditCpmxPager;
import com.cnpc.jcdp.web.rad.page.EditPager;
import com.cnpc.jcdp.web.rad.util.RADConst;

/**
 * @author rechete
 *
 */
public class DefaultCmpxCRUTmpt extends DefaultCRUTmpt{
	protected void printItemsTable()throws IOException{
    	String popSize = editPager.getPopSize();
    	int windowHeight = RADConst.POP_WINDOW_HEIGHT;
    	if(popSize!=null && popSize.indexOf(":")>0){
    		windowHeight = Integer.parseInt(popSize.substring(popSize.indexOf(":")+1));
    	}
    	List<ICfgNode> nodes = pager.getTlHd().selectNodes("//ItemFields/field");    
    	pager.println("<!--Remark вс╠М-->");
    	pager.println("<div  style=\"width:100%;height:"+(windowHeight-150-pager.getCruTableHeight())+";overflow-x:hidden;overflow-y:auto;border-bottom:0px;border-right:1px outset;dashed #000000;\">");
    	pager.println("<table id=\"itemsTable\"  class=\"itemsTable\">");    	
    	pager.println("<thead>");
    	pager.println("<tr>");
    	pager.println("\t<td></td>");
    	for(int i=1;i<nodes.size();i++){
    		ICfgNode node = nodes.get(i);
    		pager.println("\t<td>"+node.getValue()+"</td>");
    	}
    	pager.println("</tr>");
    	pager.println("</thead>");
    	pager.println("<tr style=\"display:none\">");
    	for(int i=0;i<nodes.size();i++){
    		ICfgNode node = nodes.get(i);
    		if(i==0){
    			pager.println("\t<td><input type=\"checkbox\" value=\"\" name=\""+node.getAttrValue("name")+"\"></td>");
    			continue;
    		}
    		String size = node.getAttrValue("size");
    		if(size==null) size = "10";
    		pager.println("\t<td><input type=\"text\" size=\""+size+"\" name=\""+node.getAttrValue("name")+"\"></td>");
    	}
    	pager.println("</tr>");
    	pager.println("</table>");
    	pager.println("</div>");
    	pager.println("");		
	}
}
