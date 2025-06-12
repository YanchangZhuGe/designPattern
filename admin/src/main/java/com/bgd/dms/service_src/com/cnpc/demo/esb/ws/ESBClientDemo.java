package com.cnpc.demo.esb.ws;
  
import java.util.List;
import java.util.Map; 
import java.util.HashMap; 
import javax.xml.soap.SOAPBody; 
import javax.xml.soap.SOAPElement; 

import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.client.BaseSOAPClient;  

public class ESBClientDemo extends BaseSOAPClient {   
	private Map paramMap; 

   public  ESBClientDemo(String opName, Map paramMap) throws Exception {    
			// 传入调用操作名称、命名空间   
			super(opName, "http://www.cnpc.com/SAIS/wsdl/");   
			this.paramMap = paramMap;   
			// 设置访问地址   
			this.setEndPoint("http://10.88.2.248:9280/ESBServer/WebService/MarketWeeklySrv");   
	   }    

    public void fillOP_queryMarketWeekReport_Params() throws Exception {   
              SOAPBody body=reqMsg.getSOAPBody();   
              SOAPElement soapElement=body.addChildElement("queryMarketWeekReport",BaseSOAPClient.NAME_SPACE);  
  
             //请根据实际情况完善下面参数
             SOAPElement sText0=soapElement.addChildElement("SelectForm_p");
              sText0.addTextNode((String)paramMap.get("SelectForm_p")); 
              SOAPElement sText1=soapElement.addChildElement("SelectForm_crd");
              sText1.addTextNode((String)paramMap.get("SelectForm_crd")); 
 
      }   

	public static void main(String args[]) throws Exception{ 
		Map map = new HashMap(); 
		map.put("SelectForm_p","1"); 
		map.put("SelectForm_crd","5"); 
		ESBClientDemo test = new ESBClientDemo("queryMarketWeekReport",map); 
		test.call(); 
		test.printOutput();
		
			//MsgElement element = test.getMsgElement("queryMarketWeekReport_response");

			List<MsgElement> meList = test.getMsgElements("queryMarketWeekReport_rep"); 
			
			for (MsgElement me : meList) { 
				System.out.println (me.getValue("orgId"));
				//System.out.println(me.toMap()); 
			} 
	} 
}    

