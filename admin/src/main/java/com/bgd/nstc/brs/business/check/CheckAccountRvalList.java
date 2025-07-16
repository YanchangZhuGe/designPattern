package com.nstc.brs.business.check;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.nstc.brs.domain.BrsBankRecord;
import com.nstc.brs.domain.BrsStatementRecord;
import com.nstc.brs.domain.BrsVoucher;
import com.nstc.brs.handler.R;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.util.CastUtil;
import com.nstc.brs.util.DateUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 余额对账查询结果
 * @Description: 
 * @author fankebo
 * @date 2016-12-22 下午01:34:21
 */
public class CheckAccountRvalList extends CheckAccountMainBusiness {
	private List<Map<String,String>> brs_checkAccountRval_List;
	private Map<String,String> brs_checkAccountRval_Query;
	
	@Override
	public void doExecute() throws Exception {
		 Map queryMap = buildAccountRvalQry();
		 List rvalList = getContext().getAccountService().getCheckAccountRvalList(queryMap);
		 putResult("brs_checkAccountRval_List", rvalList);
		 putResult("brs_checkAccountRval_Query", queryMap);
	}
	public   Map buildAccountRvalQry(){
		if(brs_checkAccountRval_Query == null)
			return null;
		Map map =new HashMap();
		map.put("isMatch", CastUtil.trimNull(brs_checkAccountRval_Query.get("isMatch")));
		try {
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
			Date bookDate = sdf.parse(CastUtil.trimNull(brs_checkAccountRval_Query.get("bookDate")));
			map.put("bookDate", bookDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return map;
	}
	public List<Map<String, String>> getBrs_checkAccountRval_List() {
		return brs_checkAccountRval_List;
	}
	public void setBrs_checkAccountRval_List(
			List<Map<String, String>> brs_checkAccountRval_List) {
		this.brs_checkAccountRval_List = brs_checkAccountRval_List;
	}
	public Map<String, String> getBrs_checkAccountRval_Query() {
		return brs_checkAccountRval_Query;
	}
	public void setBrs_checkAccountRval_Query(
			Map<String, String> brs_checkAccountRval_Query) {
		this.brs_checkAccountRval_Query = brs_checkAccountRval_Query;
	}
    
}
