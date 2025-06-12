/**
 * 
 */
package com.cnpc.jcdp.web.rad.template;

import java.io.IOException;

import com.cnpc.jcdp.web.rad.page.ListSelectPager;
import com.cnpc.jcdp.web.rad.page.QueryListPager;

/**
 * @author rechete
 *
 */
public class CNPCOMSListSelectTmpt extends CNPCOMSListTmpt{
	
	protected void printTable()throws IOException{
		printOtherButton();
		super.printTable();
	}
	
    private void printOtherButton()throws IOException{
        pager.print("<div id=\"div_button\">\r\n");
        pager.print("<table  cellSpacing=0 cellPadding=0 border=0 >\r\n");
        pager.print("<tr>\r\n");
        pager.print("<td >\r\n");
        pager.print("<input class=\"button general\" type=\"button\" value=\"È·ÈÏ\" onClick=\"selectEntities()\">\r\n");
        pager.print("<input class=\"button general\" type=\"button\" value=\"¹Ø±Õ\" onClick=\"window.close()\">\r\n");  		
        pager.print("</td>\r\n");
        pager.print("</tr>\r\n");
        pager.print("</table>\r\n");
        pager.print("</div>\r\n");
        pager.print("\r\n");   		
    }	
}
