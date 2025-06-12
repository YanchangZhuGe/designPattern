package com.bgp.mcs.web.common.tag;

import java.util.List;

import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.jdbc.core.BeanPropertyRowMapper;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：屈克将
 *       
 * 描述：
 */
public class DevTypeTag extends TagSupport {

	private static final long serialVersionUID = 7828753850792047206L;
	private String name;//select的name
	private String id;//select的name
    private String cssClass;//select的css
    private String selectonchange;//onchang事件
    private String style;
	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public int doStartTag() {
		//获得数据
		String sql = "select t.device_id optionvalue,t.dev_model optiondesc from GMS_DEVICE_COLLECTINFO t where t.dev_code like '01%' and t.node_level=3 order by t.dev_code";
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<SelectEntity> list = dao.getJdbcTemplate().query(sql, new BeanPropertyRowMapper<SelectEntity>(SelectEntity.class));
		
		StringBuffer sb = new StringBuffer("<select name=\'");
		
		if(name!=null){
			sb.append(name);
		}
		if(id!=null){
			sb.append("\' id=\'").append(id);
		}
		sb.append("\' class=\'");

		if(cssClass!=null){
			sb.append(cssClass);
		}
		
		sb.append("\'");
		
		if(selectonchange!=null){
			sb.append(" onchange=\'").append(selectonchange).append("\'");
		}
		
		if(style!=null){
			sb.append(" style=\'").append(style).append("\'");
		}
		
		sb.append(">");
		
        try {
			if(CollectionUtils.isNotEmpty(list)){
				for (SelectEntity entity : list) {
					sb.append("<option value=\'").append(entity.getOptionvalue()).append("\'");
					sb.append(">").append(entity.getOptiondesc()).append("</option>");
				}
			}
			
			sb.append("</select>");
	        pageContext.getOut().print(sb.toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return 1;
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

	public String getSelectonchange() {
		return selectonchange;
	}

	public void setSelectonchange(String selectonchange) {
		this.selectonchange = selectonchange;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	
}
