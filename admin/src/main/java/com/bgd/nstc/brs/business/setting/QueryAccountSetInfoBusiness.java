package com.nstc.brs.business.setting;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsAccountSet;
import com.nstc.brs.util.PageUtils;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.StringUtils;

/**
 * 对账账户设置详情
 * @ClassName QueryAccountSetInfoBusiness
 * @Author fmh
 * @Date 2024-11-19
 */
public class QueryAccountSetInfoBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_accountEdit_qry;
	private String bankNo;

	@SuppressWarnings("unchecked")
	@Override
	public void doExecute() throws Exception {

		if(brs_accountEdit_qry==null){
			brs_accountEdit_qry = new HashMap<String, Object>();
			brs_accountEdit_qry.put("bankNo",bankNo);
		}
		brs_accountEdit_qry.put("accountState","1");
		brs_accountEdit_qry.put("existsFlag","true");
		brs_accountEdit_qry.put("custNo","01100");//只查询财务公司账户
		List<Map<String,Object>> dataList = this.getContext().getCommonService().selectBankAccountList(brs_accountEdit_qry);
		int totalCount = dataList.size();
		int pageSize = PageUtils.getPageSize(bizEvent, "brs_accountEdit_list", getAppNo());
		int curPageNo = PageUtils.getCurPageNo(bizEvent, "brs_accountEdit_list");
		Map<String,Object> pageInfo = PageUtils.getPageInfoMap(pageSize, curPageNo);
		brs_accountEdit_qry.putAll(pageInfo);
		dataList = this.getContext().getCommonService().selectBankAccountList(brs_accountEdit_qry);
		this.putResult("brs_accountEdit_list", dataList);
		this.putResult("bankList", this.getContext().getAccountService().getBankList());
		this.putResult("curList", this.getContext().getCommonService().getCurrencyList());
		this.putResult("brs_accountEdit_qry", brs_accountEdit_qry);
		this.putResult("brs_accountEdit_list._rowCount", totalCount);
		this.putResult("brs_accountEdit_list._curPageNum", curPageNo);
	}

	public Map<String, Object> getBrs_accountEdit_qry() {
		return brs_accountEdit_qry;
	}

	public void setBrs_accountEdit_qry(Map<String, Object> brs_accountEdit_qry) {
		this.brs_accountEdit_qry = brs_accountEdit_qry;
	}

	public String getBankNo() {
		return bankNo;
	}

	public void setBankNo(String bankNo) {
		this.bankNo = bankNo;
	}
}
