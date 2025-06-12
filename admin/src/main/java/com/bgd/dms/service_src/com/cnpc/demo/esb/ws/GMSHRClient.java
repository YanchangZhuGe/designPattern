package com.cnpc.demo.esb.ws;

import java.util.Map;
import java.util.HashMap;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPElement;
import com.cnpc.jcdp.soa.msg.client.BaseSOAPClient;

/**
 * ����ESS�ķ��񣬸����û���¼����ȡ���û����ʵ�����
 * @author Administrator
 *
 */
@SuppressWarnings("unchecked") 
public class GMSHRClient extends BaseSOAPClient {
	private Map paramMap;

	  public  GMSHRClient(String opName, Map paramMap) throws Exception {    
			// ������ò������ơ������ռ�   
			super(opName, "http://www.cnpc.com/SAIS/wsdl/");   
			this.paramMap = paramMap;   
			// ���÷��ʵ�ַ   
			this.setEndPoint("http://10.88.248.133:9080/ess/WSDLEngine/questionService?wsdl");   
	   }   

	public void fillOP_questionType_Params() throws Exception {
		
		SOAPBody body = reqMsg.getSOAPBody();
		
		SOAPElement soapElement = body.addChildElement("questionType", BaseSOAPClient.NAME_SPACE);

		soapElement.addChildElement("userId").addTextNode((String) paramMap.get("userId"));
	}
	
	public Map getHRDeptId(String userId) throws Exception {

		Map map = new HashMap();
		map.put("userId", userId);
		
		GMSHRClient getHRDeptClient = new GMSHRClient("questionType", map);
		
		getHRDeptClient.call();

		String projects = getHRDeptClient.getValue("info");
		map.put("url", getHRDeptClient.getValue("url"));
		map.put("list", projects);
		return map;

	}
	
	public static void main(String args[]) throws Exception {
		GMSHRClient client = new GMSHRClient(null, null);
		
		System.out.println(client.getHRDeptId("superadmin"));
	}
}
