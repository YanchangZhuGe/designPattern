/**
 * 
 */
package com.bgp.mcs.service.pm.service.p6.util;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.TimerTask;

import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：姜增辉 2012-Jan-10
 *       
 * 描述：存放同步需要调用的方法
 */
public class SynTimerTask extends TimerTask {
	
	private ILog log;
	
	public SynTimerTask() {
		log = LogFactory.getLogger(SynTimerTask.class);
	}
	/* (non-Javadoc)
	 * @see java.util.TimerTask#run()
	 */
	@Override
	public void run() {
		log.info("com.bgp.mcs.p6.service.SynTimerTask ======== BEGIN!");
		try{
			//格式为foo(String filter)的方法可以加到list中，便于调用
			List<String> method_names=new ArrayList<String>();//将要调用的同步方法名add到list里面
			method_names.add("synActivityGMStoP6");
			method_names.add("synActivityP6toGMS");
			//method_names.add("synActivityCodeP6toGMS");
			//method_names.add("synActivityCodeTypeP6toGMS");
			method_names.add("synWbsP6toGMS");
			//method_names.add("synResourceP6toGMS");
			//method_names.add("synResourceAssignmentP6toGMS");
			//method_names.add("synResourceCodeP6toGMS");
			//method_names.add("synResourceCodeTypeP6toGMS");
			//method_names.add("synResourceAssignmentGMStoP6");
			//method_names.add("synUDFValueP6toGMS");
			
			SynUtils synUtils=new SynUtils();
			for(int i=0;i<method_names.size();i++){
				String m_name=method_names.get(i);
				System.out.println(m_name+" is running!!=========");
				Method mothed1 = synUtils.getClass().getMethod("getFilter",String.class );   //方法名以及定义传入的参数类型
	            String filter=(String) mothed1.invoke(synUtils, m_name); //所属对象和参数
//	            System.out.println("filter="+filter);
	            try {
	            	Method mothed2 = synUtils.getClass().getMethod(m_name,String.class );  
					mothed2.invoke(synUtils, filter);
	            	Method mothed3 = synUtils.getClass().getMethod("setUpdateDate",String.class ); 
	            	mothed3.invoke(synUtils, m_name); 
				} catch (Exception e) {
					log.error("定时器:"+m_name+"异常 跳过该定时器 执行下一个定时器");
					e.printStackTrace();
					continue;
				}
			}
			synUtils.syncP6DeletedDatas();//删除同步器
			synUtils.synProject();//项目同步
			synUtils.synBaselineProject();//目标项目同步
			synUtils.syncBaseProjectId();//同步项目的目标项目编号
		}catch(Exception e){
			e.printStackTrace();
		}
		log.info("com.bgp.mcs.p6.service.SynTimerTask ======== END!");
	}
}
