package com.cnpc.jcdp.web.rad2.page;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Entities.EscapeMode;

import com.cnpc.jcdp.cfg.SystemConfig;
import com.cnpc.jcdp.web.rad.template.BaseTmpt;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.RADConst.LISTTYPE;

public class ListSelectPager2 extends QueryListPager2 {
	private Document doc;
	public Document getDoc() {
		return doc;
	}

	public void setDoc(Document doc) {
		this.doc = doc;
	}

	public ListSelectPager2(){
		pmdAction = RADConst.PMDAction.L2S;
	}
	
	protected void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception{
		super.initPager(request, response);		
		String paramStrs = "$PARAM.rlTableName$PARAM.rlColumnName$PARAM.rlColumnValue";
		addParams(paramStrs,request); 
		listType = LISTTYPE.List2Sel;
	}
	
	protected void readTmpt(HttpServletRequest request) throws IOException{
		String contextPath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
		if(request.getContextPath().startsWith("/")){
			contextPath = contextPath + request.getContextPath();
		}
		else{
			contextPath = contextPath + "/" + request.getContextPath();
		}

		String path = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getRequestURI();
		String suffix = path.substring(path.lastIndexOf(".")+1);
		path = path.replace(suffix, "html");
		Document doc = null;
		String localPath = SystemConfig.WEB_ROOT_PATH.substring(0, SystemConfig.WEB_ROOT_PATH  
                .indexOf("/WEB-INF/classes")) +path.replace(contextPath,"");
		File file=new File(localPath);
		if(file.exists()){
			doc = Jsoup.parse(file, null);
		}else{
			String filePath=contextPath + "/html/";
			String  templatePath = getTlHd().getSingleNodeValue("PageTemplate");
			if(templatePath!=null){
				if(templatePath.startsWith("/"))
					templatePath=templatePath.substring(1);
				filePath += templatePath;
			}else{
				filePath += "cn/list2select.html";
			}
			localPath = SystemConfig.WEB_ROOT_PATH.substring(0, SystemConfig.WEB_ROOT_PATH  
	                .indexOf("/WEB-INF/classes")) +filePath.replace(contextPath,"");
			file=new File(localPath);
			doc = Jsoup.parse(file,null);
		}
		this.setDoc(doc);
	}
	
	
    /**
     * 用于列表选择页面时，打印确认按钮
     * @throws IOException
     */
    public void printOtherButton()throws IOException{
    	getDoc().getElementById("btn_submit").attr("style", "visibility:visible");
    	getDoc().getElementById("btn_submit").attr("onClick", "selectEntities()");
    	getDoc().getElementById("btn_close").attr("style", "visibility:visible");
    	getDoc().getElementById("btn_close").attr("onClick", "newClose()");
//  		print("<input class=\"button general\" type=\"button\" value=\"确认\" onClick=\"selectEntities()\">\r\n");
//  		print("<input class=\"button general\" type=\"button\" value=\"关闭\" onClick=\""+ tpt.getWindowCloseFunc() +"\">\r\n");  		
       
    }
    
    protected void printButtonJs(Element em){ 
    	em.appendText("function selectEntities(){\n");
    	em.appendText("\tvar addRet = addSelectEntities();\n");
    	em.appendText("\tif(addRet.returnCode!='0'){\n");
    	em.appendText("\t\talert(addRet.returnMsg);\n");
    	em.appendText("\t\treturn;\n");
    	em.appendText("\t}\n");
    	
    	em.appendText("\trefreshData();");
    	em.appendText("\tnewClose();");
    	em.appendText("\t}\n");
//        if(!"false".equals(request.getParameter("autoClose"))){
//        	BaseTmpt tmpt = this.tpt;
//        	println("\t"+tmpt.getParentRefreshFunc()+"\r\n");
//        	println("\t"+tmpt.getWindowCloseFunc()+"\r\n");
//        }
    }
    
    protected void printSelectButton() {
    	getDoc().getElementById("btn_submit").attr("style", "visibility:visible");
    	getDoc().getElementById("btn_submit").attr("onClick", "selectEntities()");
    	getDoc().getElementById("btn_close").attr("style", "visibility:visible");
    	getDoc().getElementById("btn_close").attr("onClick", "newClose()");
//	  	  pager.print("<input class=\"cuteBtn\" type=\"button\" value=\"确认\" onClick=\"selectEntities()\">\r\n");
//	  	  pager.print("<input class=\"cuteBtn\" type=\"button\" value=\"关闭\" onClick=\""+getWindowCloseFunc()+"\">\r\n");  		
		
	}
    
}
