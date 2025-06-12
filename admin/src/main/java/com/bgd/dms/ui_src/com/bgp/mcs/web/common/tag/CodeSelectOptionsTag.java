package com.bgp.mcs.web.common.tag;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.jsp.tagext.TagSupport;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：屈克将
 *       
 * 描述：
 */
public class CodeSelectOptionsTag extends TagSupport {

	private String name;
	private String option;
    private String cssClass;
    private String addAll;
    private String selectedValue;
    private String disabled;
    private String onchange;
    private static Map optionMap;
    
    /**
	 * 
	 */
	public CodeSelectOptionsTag() {

		if(optionMap==null) loadOptions();
		
	}
	
	public void loadOptions(){

		ServiceCallConfig servicecallconfig = new ServiceCallConfig();
		
		servicecallconfig.setServiceName("CodeSelectOptionsSrv");
		servicecallconfig.setOperationName("getCodeSelectOption");
		
		try {
			ISrvMsg reqDTO = SrvMsgUtil.createISrvMsg(servicecallconfig.getOperationName());
			ISrvMsg respDTO = ServiceCallFactory.getIServiceCall().callWithDTO(null, reqDTO, servicecallconfig);

			optionMap =respDTO.getMsgElement("optionMap").toMap();

			for(Iterator i = optionMap.keySet().iterator();i.hasNext();){
				String key = (String)i.next();
				optionMap.put(key, respDTO.getMsgElements(key));
			}
		} catch (Exception e) {
			
		}
		
		
	}
	public int doStartTag()
    {
		
		StringBuffer sb = new StringBuffer("<select name=\"");
		
		if(name!=null){
			sb.append(name);
		}
		if(name!=null){
			sb.append("\" id=\"").append(name);
		}
		sb.append("\" class=\"");

		if(cssClass!=null){
			sb.append(cssClass);
		}
		
		sb.append("\"");
		
		if(disabled!=null && disabled.equals("true")){
			sb.append(" disabled");
		}

		if(onchange!=null){
			sb.append(" onchange=\"").append(onchange).append("\"");
		}
		
		sb.append(">");
		
		if(addAll!=null && addAll.equals("true")){
			sb.append("\n\t<option value=\"\">--请选择--</option>");
		}

        try
        {
			List optionList = (List)optionMap.get(option);
			
			if(optionList!=null && !optionList.isEmpty()){
				for(int i=0;i<optionList.size();i++){
					
					MsgElement option = (MsgElement)optionList.get(i);
					
					sb.append("\n\t<option value=\"").append(option.getValue("value")).append("\"");
					
					if(selectedValue!=null && selectedValue.equals(option.getValue("value"))) sb.append(" selected");
					
					sb.append(">").append(option.getValue("label")).append("</option>");
				}
			}

			sb.append("\n</select>");

	        pageContext.getOut().println(sb.toString());
	        
		
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return 1;
    }

	public String getOption() {
		return option;
	}

	public void setOption(String option) {
		this.option = option;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCssClass() {
		return cssClass;
	}

	public void setCssClass(String cssClass) {
		this.cssClass = cssClass;
	}

	public String getSelectedValue() {
		return selectedValue;
	}

	public void setSelectedValue(String selectedValue) {
		this.selectedValue = selectedValue;
	}

	public String getDisabled() {
		return disabled;
	}

	public void setDisabled(String disabled) {
		this.disabled = disabled;
	}

	public String getAddAll() {
		return addAll;
	}

	public void setAddAll(String addAll) {
		this.addAll = addAll;
	}

	public String getOnchange() {
		return onchange;
	}

	public void setOnchange(String onchange) {
		this.onchange = onchange;
	}
	
	
}
