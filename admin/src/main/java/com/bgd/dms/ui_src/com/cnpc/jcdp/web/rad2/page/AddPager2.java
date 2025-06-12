/**
 *
 * 单个实体的新增页面
 */
package com.cnpc.jcdp.web.rad2.page;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.util.DocUtil;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.RADConst.PAGER_OPEN_TYPE;

/**
 * @author rechete
 *
 */
public class AddPager2 extends EditPager2{	
	public AddPager2(){
		pmdAction = RADConst.PMDAction.S_C;
	}
	
  	protected void printPageInit(Element em)throws IOException{
  		if(pmdJsFuncNames.get("page_init()")!=null) return;
  		em.appendText("\n");
  		em.appendText("function page_init(){\r\n");
  		em.appendText("\tgetObj('cruTitle').innerHTML = cruTitle;\n");
  		em.appendText("\tcruConfig.contextPath = \"");
  		em.appendText(contextPath);
  		em.appendText("\";\n");
        String backUrl = request.getParameter("backUrl");
        if(backUrl!=null)
        	em.appendText("\tcruConfig.openerUrl = \""+request.getParameter("backUrl")+"\";\n");
        if("1".equals(lineRange))
        	em.appendText("\tcruConfig.lineRange = '1';\n");        
        em.appendText("\tcru_init();\n");
        em.appendText("}\n");  		
  	} 
  	
/*  	protected void printSubmitJs()throws IOException{
  		if(pmdJsFuncNames.get("submitFunc()")!=null) return;
        print("\r\n");
        print("function submitFunc(){\r\n");
        //多表修改
        if(tlHd.selectNodes("//Tables/Table")!=null){
        	println("	var submitStr = \"jcdp_tables=\"+tables.toJSONString();");
			println("	for(var i=0;i<tables.length;i++){");
			println("	  var tableName = tables[i][0];");
			println("	  var tSubmitStr = '';");
			println("	  if(tableName==defaultTableName) tSubmitStr = getSubmitStr();");
			println("	  else 	tSubmitStr = getSubmitStr(tableName);");
			println("		submitStr += \"&\"+tableName+\"=\"+submitStr2Array(tSubmitStr).toJSONString();");
			println("	}");
			println("	");
			println("	var path = cruConfig.contextPath+cruConfig.addMulTableAction;");
			println("	var retObject = syncRequest('Post',path,submitStr);");
        }else{//单表修改        
	        print("\tvar path = cruConfig.contextPath+cruConfig.addAction;\r\n");
	        print("\tsubmitStr = getSubmitStr();\r\n");
	        print("\tif(submitStr == null) return;\r\n");        
	        print("\tvar retObject = syncRequest('Post',path,submitStr);\r\n");
        }
        println("\tafterSubmit(retObject);");
        print("}\r\n");
        print("\r\n"); 	
  	}*/
  	
  	protected void printHeader(HttpServletRequest request) throws IOException {
		//处理css
		Elements css = getDoc().getElementsByTag("link");
		
		for(int i=0;i<css.size();i++){
			String href = css.get(i).attr("href");
			if(href != null || !href.equals("")){
				if(href.charAt(0) == '/'){
					css.get(i).attr("href",contextPath + href);
				}
				else{
					css.get(i).attr("href",contextPath +"/"+ href);
				}
			}
		}
		
		//处理script
		Element head = getDoc().head();
    	if(head == null)
    		return;
    	Elements scripts = head.getElementsByTag("script");
    	Element point;
    	if(scripts == null || scripts.size() == 0){
    		point = head.getElementsByTag("title").first().previousElementSibling();  
    	}
    	else{
    		for(int i=0;i<scripts.size();i++){
    			String src = scripts.get(i).attr("src");
    			if(src != null && !src.equals("")){
    				if(src.charAt(0) == '/'){
    					scripts.get(i).attr("src",contextPath + src);
    				}
    				else{
    					scripts.get(i).attr("src",contextPath +"/"+ src);
    				}
    			}
    		}
    		point = scripts.last();
    	}
    	Element newJs = DocUtil.createScriptEm(contextPath+"/js/calendar.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/JCDP_SAIS_JS/calendar_lan.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/calendar-setup.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_base.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_cru.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/JCDP_SAIS_JS/rt_cru_lan.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/proc_base.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/fujian.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_validate.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/JCDP_SAIS_JS/rt_validate_lan.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_add.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/json.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm("");
        point.after(newJs);
    	point = newJs;
    	printJavaScript(point,request);
    
	}
}
