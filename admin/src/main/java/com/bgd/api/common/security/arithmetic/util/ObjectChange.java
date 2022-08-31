/*================================================================================
 * ObjectChangeModel.java
 * 生成日期：2015-9-23 下午04:12:07
 * 作          者：zhanghonghui
 * 项          目：GWMS-Service
 * (C)COPYRIGHT BY NSTC.
 * ================================================================================
 */
package com.bgd.api.common.security.arithmetic.util;

import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.TextFormat;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.*;

/**
 * <p>
 * Title:
 * </p>
 *
 * <p>
 * Description:
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author zhanghonghui
 * @version 1.0
 * @since：2015-9-23 下午04:12:07
 */
public class ObjectChange {

	private Object obj;
	private Object newObj;
	/**
	 * 只比较数组中的属性
	 */
	private String[] onlyFields;
	/**
	 * 不比较数组中的属性
	 */
	private String[] noFields;
	/**
	 * 属性对应的名称
	 */
	private Map<String, Object> fieldNameMap = new HashMap<String, Object>();


	public ObjectChange(Object obj, Object newObj, Map<String, Object> fieldNameMap) {
		this.obj = obj;
		this.newObj = newObj;
		this.fieldNameMap = fieldNameMap;
	}

	public ObjectChange(Object obj, Object newObj, Map<String, Object> fieldNameMap, String[] noFields) {
		this.obj = obj;
		this.newObj = newObj;
		this.noFields = noFields;
		this.fieldNameMap = fieldNameMap;
	}

	public ObjectChange(Object obj, Object newObj, Map<String, Object> fieldNameMap, String[] noFields, String[] onlyFields) {
		this.obj = obj;
		this.newObj = newObj;
		this.noFields = noFields;
		this.onlyFields = onlyFields;
		this.fieldNameMap = fieldNameMap;
	}

	/**
	 * @param obj
	 * @param newObj
	 * @param noFields
	 * @param onlyFields
	 * @return
	 * @Description:取newObj中和obj中不相同的属性列表，不比较noFields数组中的属性,只比较onlyFields数组中的属性
	 * @author zhanghonghui
	 * @since 2015-9-23 下午04:09:03
	 */
	public List<ObjectChangeItem> getChangeItem() {
		if (fieldNameMap == null) {
			fieldNameMap = new HashMap<String, Object>();
		}
		List<ObjectChangeItem> list = new ArrayList<ObjectChangeItem>();
		Map<String, Object> notFieldMap = new HashMap<String, Object>();
		notFieldMap.put("serialVersionUID", "serialVersionUID");
		if (noFields != null && noFields.length > 0) {
			for (int i = 0; i < noFields.length; i++) {
				notFieldMap.put(noFields[i], noFields[i]);
			}
		}
		Map<String, Object> onlyFieldMap = new HashMap<String, Object>();
		if (onlyFields != null && onlyFields.length > 0) {
			for (int i = 0; i < onlyFields.length; i++) {
				onlyFieldMap.put(onlyFields[i], onlyFields[i]);
			}
		}
		if (!obj.getClass().isInstance(newObj)) {
			return list;
		}
		List<Field> fields = getField(obj);
		for (int i = 0; i < fields.size(); i++) {
			Field f = fields.get(i);
			String fieldName = f.getName();
			if (notFieldMap.get(fieldName) != null) {
				continue;
			}
			if (onlyFields != null && onlyFields.length > 0) {
				if (onlyFieldMap.get(fieldName) == null) {
					continue;
				}
			}
			String orgVal = getValue(BeanHelper.getProperty(obj, fieldName), fieldName);
			String newVal = getValue(BeanHelper.getProperty(newObj, fieldName), fieldName);
			boolean flag = false;
			//原值等于空时，如果新值不为空，则为有变化
			if (orgVal == null && newVal != null) {
				flag = true;
			}
			//原值不为空，如果新值不等于原值，则为有变化
			if (orgVal != null && !orgVal.equals(newVal)) {
				flag = true;
			}
			if (flag) {
				ObjectChangeItem item = new ObjectChangeItem();
				if (fieldNameMap.get(fieldName) != null) {
					item.setFieldNameText(CastUtil.toNotNullString(fieldNameMap.get(fieldName)));
				} else {
					item.setFieldNameText(fieldName);
				}
				item.setFieldName(fieldName);
				item.setOrgVal(orgVal);
				item.setNewVal(newVal);
				list.add(item);
			}
		}
		return list;
	}

	/**
	 * @param obj
	 * @return
	 * @Description:取所有的属性
	 * @author zhanghonghui
	 * @since 2015-9-23 下午03:09:00
	 */
	private List<Field> getField(Object obj) {
		List<Field> list = new ArrayList<Field>();
		Field[] fields = obj.getClass().getDeclaredFields();
		if (fields != null) {
			for (int i = 0; i < fields.length; i++) {
				list.add(fields[i]);
			}
		}
		if (obj.getClass().getSuperclass() != null
				&& obj.getClass().getSuperclass().getDeclaredFields().length > 0) {
			try {
				list.addAll(getField(obj.getClass().getSuperclass().newInstance()));
			} catch (InstantiationException e) {
			} catch (IllegalAccessException e) {
			}
		}
		return list;
	}

	private String getValue(Object obj, String fieldName) {
		String val = "";
		if (obj instanceof Double) {
			if ("rate".equals(fieldName)) {
				val = TextFormat.formatNumber((Double) obj, "#,##0.000000");
			} else {
				val = TextFormat.formatCurrency((Double) obj);
			}
		} else if (obj instanceof Date) {
			val = TextFormat.formatDate((Date) obj);
		} else if (obj instanceof Integer) {
			val = obj.toString();
		} else if (obj instanceof String) {
			val = obj.toString();
		} else if (obj instanceof Boolean) {
			val = obj.toString();
		} else if (obj instanceof BigDecimal) {
			val = TextFormat.formatCurrency((BigDecimal) obj);
		} else {
			val = CastUtil.toNotNullString(obj);
		}
		return val;
	}

}
