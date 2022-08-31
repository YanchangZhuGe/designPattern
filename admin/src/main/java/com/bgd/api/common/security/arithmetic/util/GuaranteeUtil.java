/*================================================================================
 * GuaranteeUtil.java
 * 生成日期：2015-10-16 上午11:43:28
 * 作          者：zhanghonghui
 * 项          目：GWMS-Service
 * (C)COPYRIGHT BY NSTC.
 * ================================================================================
 */
package com.bgd.api.common.security.arithmetic.util;

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
 * @since：2015-10-16 上午11:43:28
 */
public class GuaranteeUtil {
	/**
	 * @return
	 * @Description:获取担保合同的字段名称和字段对应的map
	 * @author zhanghonghui
	 * @since 2015-10-16 上午11:44:16
	 */
	public static Map<String, Object> getFiledNameMap() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("guaranteeNo", "委托担保协议编号");
		map.put("guaranteeTypeName", "担保类型");
		map.put("lshName", "合作金融网点");
		map.put("cltName", "申请单位");
		map.put("propName", "保证金性质");
		map.put("drawTypeName", "支取方式");
		map.put("accountNo", "保证金账户");
		map.put("curCodeName", "币种");
		map.put("dayNum", "期限");
		map.put("guarantorName", "担保人");
		map.put("interestDay", "计息基数");
		map.put("amount", "金额");
		map.put("rate", "保证金利率");
		map.put("startDate", "开始日期");
		map.put("endDate", "到期日期");
		map.put("signDate", "签约日期");
		map.put("purpose", "用途");
		map.put("memo", "备注");
		map.put("obligorName", "被担保人");
		map.put("guaranteeNumber", "保证担保编号");
		map.put("guaranteeRateStr", "年担保费率(%)");
		map.put("verdueDays", "滞纳金产生期限(天)");
		map.put("isOverdueName", "是否收取滞纳金");
		map.put("frequencyName", "保费日收取频率");
		map.put("verdueRateStr", "滞纳金费率(日)");
		map.put("counterGuaranteeStrategy", "反担保措施");
		map.put("guaranteeModeName", "保证方式");
		map.put("crossBorderName", "是否跨境");
		map.put("chargePremiumName", "是否收取保费");
		map.put("premiumDayName", "保费收取天数");
		return map;
	}

	public static Map<String, Object> getPledgeFiledNameMap() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("amount", "抵质押物信息/抵质押物编号/抵押价值");
		map.put("pledgeRatio", "抵质押物信息/抵质押物编号/质押比例(%)");
		return map;
	}

	public static Map<String, Object> getCounterFiledNameMap() {
		String str = "反担保信息/担保类型/保证人/抵质押物编号/";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("amount", str + "金额");
		map.put("ptCode", str + "抵质押物类型");
		map.put("pledgee", str + "抵质押权人");
		map.put("pledgedCompany", str + "出质权所在公司");
		map.put("stockAmount", str + "出质股权数额");
		map.put("registrationAuthority", str + "抵质押登记机关");
		return map;
	}

	/**
	 * @param oldObj
	 * @param newObj
	 * @return
	 * @Description:取担保合同修正的属性列表
	 * @author zhanghonghui
	 * @since 2015-10-16 上午11:50:08
	 */
	public static List<ObjectChangeItem> getGuaranteeChange(Object oldObj, Object newObj, Map<String, Object> nameMap) {
		Map<String, Object> fieldNameMap = nameMap;
		Iterator<String> it = fieldNameMap.keySet().iterator();
		List<String> onlyFileds = new ArrayList<String>();
		while (it.hasNext()) {
			String fieldKey = it.next();
			onlyFileds.add(fieldKey);
		}
		ObjectChange change = new ObjectChange(oldObj, newObj, fieldNameMap
				, null, onlyFileds.toArray(new String[onlyFileds.size()]));
		return change.getChangeItem();
	}


}
