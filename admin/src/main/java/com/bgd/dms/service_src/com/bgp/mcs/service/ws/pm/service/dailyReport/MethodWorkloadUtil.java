package com.bgp.mcs.service.ws.pm.service.dailyReport;

import java.util.HashMap;
import java.util.Map;

public class MethodWorkloadUtil {
	
	private static Map<String,String> methodWorkloadNexus = new HashMap<String,String>();//施工方法 工作量 映射关系
	
	static{
		//重力类型施工方法 对应 重力类型工作量
		methodWorkloadNexus.put("5110000056000000007", "G6602");
		methodWorkloadNexus.put("5110000056000000008", "G6602");
		methodWorkloadNexus.put("5110000056000000009", "G6602");
		methodWorkloadNexus.put("5110000056000000010", "G6602");
		methodWorkloadNexus.put("5110000056000000011", "G6602");
		
		//磁力
		methodWorkloadNexus.put("5110000056000000012", "G6603");
		methodWorkloadNexus.put("5110000056000000013", "G6603");
		methodWorkloadNexus.put("5110000056000000014", "G6603");
		methodWorkloadNexus.put("5110000056000000015", "G6603");
		
		//天然场源电磁法
		methodWorkloadNexus.put("5110000056000000016", "G6605");
		methodWorkloadNexus.put("5110000056000000017", "G6605");
		methodWorkloadNexus.put("5110000056000000018", "G6605");
		methodWorkloadNexus.put("5110000056000000019", "G6605");
		methodWorkloadNexus.put("5110000056000000020", "G6605");
		
		//人工场源电磁法
		methodWorkloadNexus.put("5110000056000000021", "G6604");
		methodWorkloadNexus.put("5110000056000000022", "G6604");
		methodWorkloadNexus.put("5110000056000000023", "G6604");
		methodWorkloadNexus.put("5110000056000000024", "G6604");
		methodWorkloadNexus.put("5110000056000000025", "G6604");
		methodWorkloadNexus.put("5110000056000000026", "G6604");
		methodWorkloadNexus.put("5110000056000000027", "G6604");
		
		//工程勘探
		methodWorkloadNexus.put("5110000056000000028", "G6607");
		methodWorkloadNexus.put("5110000056000000029", "G6607");
		methodWorkloadNexus.put("5110000056000000030", "G6607");
		methodWorkloadNexus.put("5110000056000000031", "G6607");
		methodWorkloadNexus.put("5110000056000000032", "G6607");
		methodWorkloadNexus.put("5110000056000000033", "G6607");
		methodWorkloadNexus.put("5110000056000000034", "G6607");
		methodWorkloadNexus.put("5110000056000000035", "G6607");
		methodWorkloadNexus.put("5110000056000000036", "G6607");
		methodWorkloadNexus.put("5110000056000000037", "G6607");
		methodWorkloadNexus.put("5110000056000000038", "G6607");
		methodWorkloadNexus.put("5110000056000000039", "G6607");
		methodWorkloadNexus.put("5110000056000000040", "G6607");
		methodWorkloadNexus.put("5110000056000000041", "G6607");
		methodWorkloadNexus.put("5110000056000000042", "G6607");
		methodWorkloadNexus.put("5110000056000000043", "G6607");
		
		//化探G6606
		methodWorkloadNexus.put("5110000056000000005", "G6606");
	}
	
	public static String getWorkloadCodeByMethodCode(String methodCode){
		return methodWorkloadNexus.get(methodCode);
	}
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
