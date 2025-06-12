package com.bgp.mcs.web.common.tag;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.tagext.TagSupport;

import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;

/**
 * easyui按钮权限
 */
@SuppressWarnings("serial")
public class EasyUIButtonAuthTag extends TagSupport
{

    public EasyUIButtonAuthTag()
    {
    }

 

	public String getDisplay() {
		return display;
	}

	public void setDisplay(String display) {
		this.display = display;
	}

	public String getFunctionId()
    {
        return functionId;
    }

    public void setFunctionId(String functionId)
    {
        this.functionId = functionId;
    }

 
    public String getEvent()
    {
        return event;
    }

    public void setEvent(String event)
    {
        this.event = event;
    }

    public String getId()
    {
        return id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    public String getClassName()
    {
        return className;
    }

    public void setClassName(String className)
    {
        this.className = className;
    }

    public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public int doStartTag()
    {
        try
        {
            pageContext.getOut().println(getAHrefHtml());
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }
        return 1;
    }

	//<a href="#" class="easyui-linkbutton" onclick='save()'><i class="fa fa-floppy-o fa-lg"></i> 保 存 </a>
    private String getAHrefHtml()
    {
        boolean isUsable = checkFunctionConfine();
        if(!isUsable) return "";
        
        StringBuffer sb = new StringBuffer();
        sb.append("<a href='#' class='easyui-linkbutton' ");

        if(getDisplay() != null)
            sb.append(" ").append("style='display:").append(getDisplay()).append("' ");
        else
            sb.append("");

        if(getId() != null)
            sb.append(" ").append("id='").append(getId()).append("'");
        else
            sb.append("");
        
        if(getEvent() != null)
            sb.append("  onclick='").append(getEvent()).append("' ");
        else
            sb.append("");
        
        sb.append(" ><i class='");
        
        if(getClassName() != null)
            sb.append(getClassName()).append("' ");
        else
            sb.append("");
        
        sb.append(" ></i>");
        
        if(getText() != null)
            sb.append(getText());
        else
            sb.append("");
        
        sb.append("</a>");
        return sb.toString();
    }

    @SuppressWarnings("unchecked")
	private boolean checkFunctionConfine()
    {
//    	return true;
    	
    	if(functionId==null || functionId.trim().equals("")) return true;
    	
    	
    	HttpServletRequest request = (HttpServletRequest)this.pageContext.getRequest();
    	HttpSession session = request.getSession();
    	if(session==null) return false;
    	
    	String funcCodes = (String)session.getAttribute("SYS_USER_FUNC_CODES");
    	if(funcCodes==null || funcCodes.trim().equals("")) return false;
    	
    	List<String> funList = new ArrayList<String>();
    	
    	
    	String[] funcCodeArray = functionId.split(",");
    	for(String funcCode : funcCodeArray){
    		String[] arr = funcCode.split("--");
    		if(arr.length==2){
    			String preStr = arr[0];
    			int end = Integer.parseInt(arr[1]);
    			for(int i=1;i<end+1;i++){
    				funList.add(preStr+i);
    			}
    		}else{
    			funList.add(arr[0]);
    		}
    		
    	}
    	
    	for(String funId : funList){
	    	for(String funcCode : funcCodes.split(",")){
	    			if(funId.indexOf(funcCode)>=0){
	        			return true;
	        		}
	    	}
    	}
    	
    	return false;
    }

    private String display;
    private String functionId;
    private String id;
    private String className;
    private String event;
    private String text;
}
