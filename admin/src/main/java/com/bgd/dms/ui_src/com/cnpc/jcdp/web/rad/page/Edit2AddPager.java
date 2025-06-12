/**
 * 
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import com.cnpc.jcdp.web.rad.util.RADConst;

/**
 * @author rechete
 *
 */
public class Edit2AddPager extends EditPager{
  	protected void printJavaScript(HttpServletRequest request)throws IOException{
  		String pageTitle = tlHd.getSingleNodeValue("//PageTitle");
  		//if(pageTitle.startsWith("±à¼­"))
  		pageTitle = "ÐÂÔö--"+pageTitle;
  		print("var cruTitle = \""+pageTitle+"\";\r\n");
  		
  		printSelOptions();  		
  		printJcdpCodes();
  		print("var jcdp_record = null;\r\n");
  		//printFields(request,RADConst.PMDAction.S_C);
  		
  	    //printAddJs();
  	}
}
