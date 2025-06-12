/**
 * �б�ѡ��ҳ��
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.web.rad.template.BaseTmpt;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.RADConst.LISTTYPE;

/**
 * @author rechete
 *
 */
public class ListSelectPager extends QueryListPager{
	public ListSelectPager(){
		pmdAction = RADConst.PMDAction.L2S;
	}
	
	protected void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception{
		super.initPager(request, response);		
		String paramStrs = "$PARAM.rlTableName$PARAM.rlColumnName$PARAM.rlColumnValue";
		addParams(paramStrs,request); 
		listType = LISTTYPE.List2Sel;
	}
	
	
    /**
     * �����б�ѡ��ҳ��ʱ����ӡȷ�ϰ�ť
     * @throws IOException
     */
    public void printOtherButton()throws IOException{
        print("<div id=\"div_button\">\r\n");
        print("<table  cellSpacing=0 cellPadding=0 border=0 >\r\n");
        print("<tr>\r\n");
        print("<td >\r\n");
  		print("<input class=\"button general\" type=\"button\" value=\"ȷ��\" onClick=\"selectEntities()\">\r\n");
//  		print("<input class=\"button general\" type=\"button\" value=\"�ر�\" onClick=\"window.close()\">\r\n");  
  		print("<input class=\"button general\" type=\"button\" value=\"�ر�\" onClick=\""+ tpt.getWindowCloseFunc() +"\">\r\n");  		
        print("</td>\r\n");
        print("</tr>\r\n");
        print("</table>\r\n");
        print("</div>\r\n");
        print("\r\n");   		
    }
    
    protected void printButtonJs(HttpServletRequest request)throws IOException{ 
    	print("function selectEntities(){\r\n");
        println("\tvar addRet = addSelectEntities();");
    	println("\tif(addRet.returnCode!='0'){");
    	println("\t\talert(addRet.returnMsg);");
    	println("\t\treturn;");
    	println("\t}");
        if(!"false".equals(request.getParameter("autoClose"))){
        	BaseTmpt tmpt = this.tpt;
        	println("\t"+tmpt.getParentRefreshFunc()+"\r\n");
        	println("\t"+tmpt.getWindowCloseFunc()+"\r\n");
//        	println("\twindow.opener.refreshData();");
//        	println("\twindow.close();");
        }
        print("}\r\n");
        print("\r\n");     	
    }
    
}
