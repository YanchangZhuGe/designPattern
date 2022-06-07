package com.example.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @Description 借款合同变更字段
 * @date 2022/1/19 16:48
 * @author Caiww
 */
@Getter
@AllArgsConstructor
public enum LmsContractModifyColumn {

	/* 申请单号 */
	APPLY_ID("applyId","申请单号"),
	/* 借款品种 */
	LOAN_TYPE_NAME("loanTypeName","借款品种"),
	/* 合同金额 */
	AMOUNT("amount","合同金额"),
	/* 借出方核算账户 */
	LENDER_ACCOUNT("lenderAccount","借出方核算账户"),
	/* 借入方核算账户 */
	BORROWER_ACCOUNT("borrowerAccount","借入方核算账户"),
	/* 起始日期 */
	START_DATE("startDate","起始日期"),
	/* 终止日期 */
	END_DATE("endDate","终止日期"),
	/* 是否计息 */
	IS_CALC_INTEREST("isCalcInterestName","是否计息"),
	/* 利率 */
	RATE("rate","利率"),
	/* 资金来源 */
	FUND_SOURCE("fundSourceName","资金来源"),
	/* 签约日期 */
	SIGN_DATE("signDate","签约日期"),
	/* 借款用途 */
	LOAN_USAGE("loanUsageName","借款用途"),
	/* 付息方式 */
	INTEREST_TYPE("interestTypeName","付息方式"),
	/**
	 * 补充说明
	 */
	REMARK("remark","补充说明"),

	/* 附件 */
	ATTACH_FILE("fileList","附件")
	;

	private String value;
	private String name;

	/**
	 *
	 * @Description:变更字段
	 * @param
	 * @return
	 * @author
	 */
	public static List<String> getList(){
		List<String> list = new ArrayList<>();
		for(LmsContractModifyColumn t : values()){
			list.add(t.getValue());
		}
		return list;
	}

	/**
	 *
	 * @Description:根据值获取名称
	 * @param
	 * @return
	 * @author
	 */
	public static String getNameByValue(String value){
		for(LmsContractModifyColumn t : values()){
			if(t.getValue().equals(value)){
				return t.getName();
			}
		}
		return null;
	}
}
