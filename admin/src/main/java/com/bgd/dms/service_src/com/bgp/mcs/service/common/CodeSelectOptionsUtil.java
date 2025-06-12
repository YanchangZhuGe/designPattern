package com.bgp.mcs.service.common;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;

/**
 * ���⣺������������˾��̽��������ϵͳ
 * 
 * ��˾: �������
 * 
 * ���ߣ����˽�
 *       
 * ��������selectLib.xml��codeLib.xml��������������ݵĹ�����
 */
public class CodeSelectOptionsUtil{

	private ILog log;
    private IJdbcDao jdbcDao;
    private static Map optionMap = new HashMap();
    
    public CodeSelectOptionsUtil()
    {
        log = LogFactory.getLogger(CodeSelectOptionsUtil.class);
        jdbcDao = BeanFactory.getPureJdbcDAO();
    }
    
	public static ISrvMsg getAllOptions(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		Map optionNameMap = new HashMap();
		
		for(Iterator i = optionMap.keySet().iterator();i.hasNext();){
			String key = (String)i.next();
			optionNameMap.put(key, key);
			
			msg.setValue(key, optionMap.get(key));
		}
		
		msg.setValue("optionMap", optionNameMap);
		
		return msg;
	}
	
	/**
	 * ��Map�����һ��option����
	 * @param name
	 * @param optionList
	 */
	public static void addOption(String name, List optionList){
		optionMap.put(name, optionList);
	}
	
	/**
	 * ��Map���ȡһ��option����
	 * @param name
	 */
	public static List getOptionByName(String name){
		return (List)optionMap.get(name);
	}
	
	/*
	 * ����optionName�Լ�nameֵ��ȡname��Ӧ��valueֵ
	 * 
	 *
	 */
	public static String getValueByOptionAndName(String optionName,String name){
		List<Map> listCode = CodeSelectOptionsUtil.getOptionByName(optionName);
		String returnValue="";
		if(listCode!=null&&listCode.size()>0){
			for(int i=0;i<listCode.size();i++){
				String label=(String) listCode.get(i).get("label");
				String value=(String) listCode.get(i).get("value");
				if(label.equals(name)){
					returnValue= value;
					break;
				}
			}
		}
		return returnValue;
	}
}
