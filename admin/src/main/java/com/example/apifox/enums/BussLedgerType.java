package com.example.apifox.enums;
/**
 * <p>Title: BussLedgerType.java</p>
 *
 * <p>Description:担保合同台账类型 </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author luoyun
 * 
 * @since：2018-10-22 下午04:54:57
 * 
 */
public enum BussLedgerType implements TypeEnum{
	INTO(0,"融入"),
	REPAY(1,"还本"),
	INTEREST(2,"付息"),
	COST(3,"费用"),
	ADVANCE_REPAY(6,"提前还本");
	
	
	private Integer value;
	private String name;
	
	private BussLedgerType(Integer value,String name){
		this.value = value;
		this.name = name;
	}

	@Override
	public Integer getValue() {
		return value;
	}

	public void setValue(Integer value) {
		this.value = value;
	}

	public void setName(String name) {
		this.name = name;
	}
	public String getName() {
		return name;
	}
}
