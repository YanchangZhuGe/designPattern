package com.bgp.mcs.service.pm.service.p6.code;

import java.util.ArrayList;
import java.util.List;

import com.bgp.mcs.service.pm.service.common.P6WSPortTypeFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.udfvalue.UDFValue;
import com.primavera.ws.p6.udfvalue.UDFValueFieldType;
import com.primavera.ws.p6.udfvalue.UDFValuePortType;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，Mar 23, 2012
 * 
 * 描述：
 * 
 * 说明:
 */
public class UDFValueWSBean {

	private ILog log;
    
    public UDFValueWSBean()
    {
        log = LogFactory.getLogger(UDFValueWSBean.class);
    }
    
    public List<UDFValue> getUDFValueFromP6(UserToken mcsUser, String filter, String order)throws Exception {
    	List<UDFValueFieldType> fieldTypes = new ArrayList<UDFValueFieldType>(); 
    	
    	fieldTypes.add(UDFValueFieldType.FOREIGN_OBJECT_ID);//外键
    	fieldTypes.add(UDFValueFieldType.UDF_TYPE_OBJECT_ID);//该值所属分类的主键
    	//以上两个作为联合主键
    	fieldTypes.add(UDFValueFieldType.UDF_CODE_OBJECT_ID);
    	
    	fieldTypes.add(UDFValueFieldType.PROJECT_OBJECT_ID);
    	fieldTypes.add(UDFValueFieldType.UDF_TYPE_DATA_TYPE);//自定义字段类型
    	fieldTypes.add(UDFValueFieldType.UDF_TYPE_SUBJECT_AREA);//自定义字段作用区域
    	fieldTypes.add(UDFValueFieldType.UDF_TYPE_TITLE);//自定义字段名
    	
    	fieldTypes.add(UDFValueFieldType.TEXT);
    	fieldTypes.add(UDFValueFieldType.DOUBLE);
    	fieldTypes.add(UDFValueFieldType.INTEGER);
    	fieldTypes.add(UDFValueFieldType.COST);
    	
    	fieldTypes.add(UDFValueFieldType.START_DATE);
    	fieldTypes.add(UDFValueFieldType.FINISH_DATE);
    	
    	
    	fieldTypes.add(UDFValueFieldType.CODE_VALUE);
    	fieldTypes.add(UDFValueFieldType.LAST_UPDATE_DATE);
    	fieldTypes.add(UDFValueFieldType.LAST_UPDATE_USER);
    	
    	UDFValuePortType uDFValuePortType = P6WSPortTypeFactory.getPortType(UDFValuePortType.class, mcsUser);
    	
    	List<UDFValue> list = uDFValuePortType.readUDFValues(fieldTypes, filter, order);
    	
    	return list;
    }
    
    public boolean updateUDFValueToP6(UserToken mcsUser, List<UDFValue> uDFValues) throws Exception {
    	
    	UDFValuePortType uDFValuePortType = P6WSPortTypeFactory.getPortType(UDFValuePortType.class, mcsUser);
    	
    	boolean flag = uDFValuePortType.updateUDFValues(uDFValues);
    	
    	return flag;
    }
    
    public static void main(String[] args) throws Exception {
    	UDFValueWSBean s = new UDFValueWSBean();
    	List<UDFValue> list = s.getUDFValueFromP6(null, null, null);
    	
    	for (int i = 0; i < list.size(); i++) {
    		UDFValue uValue = list.get(i);
    		System.out.println(uValue.getUDFTypeTitle() + " "+uValue.getUDFTypeDataType());
		}
	}
    
}
