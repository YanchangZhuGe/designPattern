package com.cnpc.jcdp.web.rad2.page;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import com.cnpc.jcdp.web.rad.util.DocUtil;
import com.cnpc.jcdp.web.rad.util.RADConst;

public class ViewPager2 extends EditPager2 {
	public ViewPager2(){
		pmdAction = RADConst.PMDAction.S_R;
	}
	
  	protected void printSubmitJs()throws IOException{
  		
  	}
  	
  	protected void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception{
  		super.initPager(request,response);
  		if("true".equals(request.getParameter("noSubmit"))) noSubmitButton = true;
  	}
  	
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
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_view.js");
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
