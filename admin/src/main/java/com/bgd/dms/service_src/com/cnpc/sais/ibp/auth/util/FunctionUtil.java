package com.cnpc.sais.ibp.auth.util;

import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;

import com.cnpc.sais.ibp.auth.pojo.PAuthFunction;





/**
 * Project��CNLC OMS(Service)
 * 
 * Creator��rechete
 * 
 * Creator Time:2008-5-4 ����10:17:47
 * 
 * Description��System Function Management Util
 * 
 * Revision history��
 * 
 * 
 * 
 */
public class FunctionUtil {
	/**
	 * ����ϵͳ���еĹ���
	 */
	private static Map<String,PAuthFunction> allFuncs = new Hashtable();
	
	public static PAuthFunction getPAuthFunction(String funcId){
		if(funcId==null) return null;
		
		if(allFuncs.containsKey(funcId))
			return allFuncs.get(funcId);
		else return null;			
	}
	
	/**
	 * �����е�funcCode+","���һ���ַ�������
	 * @return
	 */
	public static String getAllFuncCodes(){
		StringBuffer funcCodes = new StringBuffer("");
		Iterator iter = allFuncs.values().iterator();
		while(iter.hasNext()){
			PAuthFunction func = (PAuthFunction)iter.next();
			funcCodes.append(func.getFuncCode()+",");
		}
		return funcCodes.toString();
	}
	
	public static void addAll(List<PAuthFunction> funcs){
		allFuncs.clear();
		for(int i=0;i<funcs.size();i++){
			PAuthFunction func = funcs.get(i);
			Hibernate.initialize(func);
			allFuncs.put(func.getFuncId(), func);
		}		
	}
	
	/**
	 * �������ܺ󣬸��»���
	 * @param func
	 */
	public static void addFunction(PAuthFunction func){
		allFuncs.put(func.getFuncId(), func);
	}
	
	/**
	 * ɾ�����ܺ󣬸��»���
	 * @param func
	 */
	public static void deleteFunction(PAuthFunction func){
		allFuncs.remove(func.getFuncId());
	}	

	/**
	 * �޸Ĺ��ܺ󣬸��»���
	 * @param func
	 */	
	public static void updateFunction(PAuthFunction func){
		allFuncs.remove(func.getFuncId());
		allFuncs.put(func.getFuncId(), func);
	}		
}
