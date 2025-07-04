/**
 * 采油厂模板
 */
package com.cnpc.jcdp.web.rad.tmpt.wrms;

import java.io.IOException;

import com.cnpc.jcdp.web.rad.page.ListSelectPager;
import com.cnpc.jcdp.web.rad.page.QueryListPager;

/**
 * @author rechete
 *
 */
public class ListSelectTmpt extends ListTmpt{
	
	protected void printTable()throws IOException{
		printOtherButton();
		super.printTable();
	}
	
    private void printOtherButton()throws IOException{
        pager.print("<div id=\"div_button\">\r\n");
        pager.print("<table  border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"Tab_new_mod_del\">\r\n");
        pager.print("<tr class=\"ali7\">\r\n");
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
