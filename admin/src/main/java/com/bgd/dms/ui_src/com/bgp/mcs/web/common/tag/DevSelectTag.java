package com.bgp.mcs.web.common.tag;

import java.util.List;

import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.BeanPropertyRowMapper;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

/**
 * ���⣺������������˾��̽��������ϵͳ
 * 
 * ��˾: �������
 * 
 * ���ߣ����˽�
 *       
 * ������
 */
public class DevSelectTag extends TagSupport {

	private static final long serialVersionUID = 7828753850792047206L;
	private String name;//select��name
	private String id;//select��name
	private String typeKey;//�ֵ�����key
    private String cssClass;//select��css
    private String selectedValue;//Ĭ��ѡȡ��ֵ
    private String selectdefaultV;//�Ƿ��� ��ѡ�� ѡ����
	private String selectdisabled;//�Ƿ����
    private String selectonchange;//onchang�¼�

	public int doStartTag() {
		//�������
		String sql = "select t.dictkey,t.dictdesc,i.optionvalue,i.optiondesc,i.displayorder from GMS_DEVICE_COMM_DICT t join GMS_DEVICE_COMM_DICT_ITEM i on t.id=i.dict_id where t.bsflag='0' and t.dictkey=? order by i.displayorder";
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<SelectEntity> list = dao.getJdbcTemplate().query(sql, new Object[]{typeKey}, new BeanPropertyRowMapper<SelectEntity>(SelectEntity.class));
		
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
		
		if(selectdisabled!=null && selectdisabled.equals("true")){
			sb.append(" disabled");
		}

		if(selectonchange!=null){
			sb.append(" onchange=\'").append(selectonchange).append("\'");
		}
		
		sb.append(">");
		
		if(selectdefaultV!=null && selectdefaultV.equals("true")){
			sb.append("<option value=\'\'>--��ѡ��--</option>");
		}

        try {
			if(CollectionUtils.isNotEmpty(list)){
				for (SelectEntity entity : list) {
					sb.append("<option value=\'").append(entity.getOptionvalue()).append("\'");
					//����ֵѡ��ָ����
					if(StringUtils.isNotEmpty(selectedValue) && selectedValue.equals(entity.getOptionvalue())){
						sb.append(" selected");
					}
					sb.append(">").append(entity.getOptiondesc()).append("</option>");
				}
			}
			
			sb.append("</select>");
			System.out.println("---------------:" + sb.toString());
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

	public String getTypeKey() {
		return typeKey;
	}

	public void setTypeKey(String typeKey) {
		this.typeKey = typeKey;
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

	public String getSelectdefaultV() {
		return selectdefaultV;
	}

	public void setSelectdefaultV(String selectdefaultV) {
		this.selectdefaultV = selectdefaultV;
	}

	public String getSelectdisabled() {
		return selectdisabled;
	}

	public void setSelectdisabled(String selectdisabled) {
		this.selectdisabled = selectdisabled;
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
