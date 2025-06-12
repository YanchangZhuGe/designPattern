/**
 * load “≥√Êƒ£øÈ≈‰÷√
 */
package com.cnpc.jcdp.web.rad.util;

import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.common.IAutoRunBean;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.web.rad.template.BaseTmptFactory;
import com.cnpc.jcdp.webapp.srvclient.IServiceCall;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

/**
 * @author rechete
 *
 */
public class RADInitializor implements IAutoRunBean{
	public void run(){
		try {		
			IServiceCall caller = ServiceCallFactory.getIServiceCall();
			ISrvMsg reqMsg = SrvMsgUtil.createISrvMsg("queryTmpts");
			String url = "RADProdConfig/queryTmpts";
			ISrvMsg resMsg = caller.callWithDTO(null,reqMsg, url);
			List<MsgElement> msgs = resMsg.getMsgElements("tmpts");
			for(int i=0;i<msgs.size();i++){
				Map map = msgs.get(i).toMap();
				BaseTmptFactory ft = (BaseTmptFactory)Class.forName(map.get("factory_class").toString()).newInstance();
				PagerFactory.tptFacts.put(map.get("tmpt_code").toString(), ft);
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
}
