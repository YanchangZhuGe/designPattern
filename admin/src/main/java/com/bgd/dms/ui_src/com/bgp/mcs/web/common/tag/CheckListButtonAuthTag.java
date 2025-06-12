package com.bgp.mcs.web.common.tag;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.tagext.TagSupport;

import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;

/**
 * 列表页面按钮权限
 */
@SuppressWarnings("serial")
public class CheckListButtonAuthTag extends TagSupport
{
 
    public CheckListButtonAuthTag()
    {
    }

    public String getTdid() {
		return tdid;
	}

	public void setTdid(String tdid) {
		this.tdid = tdid;
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

    public String getCss()
    {
        return css;
    }

    public void setCss(String css)
    {
        this.css = css;
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

    public String getStyle()
    {
        return style;
    }

    public void setStyle(String style)
    {
        this.style = style;
    }

    public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
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

    // <td id="ab" style="display:none" class="ali_btn" ><span class="gl"><a href="#" onclick="toSearch()" title="JCDP_btn_filter"></a></span></td>
    private String getAHrefHtml()
    {
        boolean isUsable = checkFunctionConfine();
        if(!isUsable) return "";
        
        StringBuffer sb = new StringBuffer();
        sb.append("<td");

        if(getTdid() != null)
            sb.append(" ").append("id='").append(getTdid()).append("'");
        else
            sb.append("");

        if(getDisplay() != null)
            sb.append(" ").append("style='display:").append(getDisplay()).append("'");
        else
            sb.append("");

        sb.append(" class='ali_btn'><span class='").append(getCss()).append("'><a href='####'");
        
        if(getId() != null)
            sb.append(" ").append("id='").append(getId()).append("'");
        else
            sb.append("");

        if(getStyle() != null)
            sb.append(" ").append("style='").append(getStyle()).append("'");
        else
            sb.append("");
        
        if(getEvent() != null)
            sb.append(" ").append(getEvent()).append(" ");
        else
            sb.append("");
        
        if(getTitle() != null)
            sb.append(" ").append("title='").append(getTitle()).append("'");
        else
            sb.append("");
        
        sb.append("></a></span></td>");
        
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
    	
    	String[] funcCodeArray = funcCodes.split(",");
    	
    	for(String funcCode : funcCodeArray){
    		if(functionId.indexOf(funcCode)>=0){
    			return true;
    		}
    	}
    	
    	return false;
    }

    private String tdid;
    private String display;
    private String functionId;
    private String id;
    private String style;
    private String css;
    private String event;
    private String title;
}
