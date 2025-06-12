package com.cnpc.demo.esb.ws;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.soap.SOAPException;

import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class MarketWeeklySrv extends BaseService {
	
	public ISrvMsg queryMarketWeekReport(ISrvMsg reqMsg) throws SOAPException {
		 
		List<Map<String, String>> retMapList = new ArrayList<Map<String, String>>();
		int totalRows = 0;
		String currentPage = reqMsg.getValue("currentPage");
		String pageSize = reqMsg.getValue("pageSize");
		try {
			Map map = new HashMap(); 
			map.put("SelectForm_p", currentPage); 
			map.put("SelectForm_crd", pageSize); 
			ESBClientDemo test = new ESBClientDemo("queryMarketWeekReport",map); 
			test.call(); 
			
			List<MsgElement> meList = test.getMsgElements("queryMarketWeekReport_rep"); 			
			for (MsgElement me : meList) { 
				retMapList.add(me.toMap());
			} 
			totalRows = Integer.parseInt(test.getValue("totalRows")); 
		} catch(Exception e) {
			System.out.println("取webservice服务数据出现错误：" + e);
			e.printStackTrace();
		}
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		retMsg.setValue("datas", retMapList);
		retMsg.setValue("totalRows", totalRows);
		return retMsg;
	}
	
}
