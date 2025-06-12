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
 * ���⣺������������˾��̽��������ϵͳ
 * 
 * ��˾: �������
 * 
 * ���ߣ������� 2012-Jan-10
 *       
 * ���������ͬ����Ҫ���õķ���
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
			//��ʽΪfoo(String filter)�ķ������Լӵ�list�У����ڵ���
			List<String> method_names=new ArrayList<String>();//��Ҫ���õ�ͬ��������add��list����
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
				Method mothed1 = synUtils.getClass().getMethod("getFilter",String.class );   //�������Լ����崫��Ĳ�������
	            String filter=(String) mothed1.invoke(synUtils, m_name); //��������Ͳ���
//	            System.out.println("filter="+filter);
	            try {
	            	Method mothed2 = synUtils.getClass().getMethod(m_name,String.class );  
					mothed2.invoke(synUtils, filter);
	            	Method mothed3 = synUtils.getClass().getMethod("setUpdateDate",String.class ); 
	            	mothed3.invoke(synUtils, m_name); 
				} catch (Exception e) {
					log.error("��ʱ��:"+m_name+"�쳣 �����ö�ʱ�� ִ����һ����ʱ��");
					e.printStackTrace();
					continue;
				}
			}
			synUtils.syncP6DeletedDatas();//ɾ��ͬ����
			synUtils.synProject();//��Ŀͬ��
			synUtils.synBaselineProject();//Ŀ����Ŀͬ��
			synUtils.syncBaseProjectId();//ͬ����Ŀ��Ŀ����Ŀ���
		}catch(Exception e){
			e.printStackTrace();
		}
		log.info("com.bgp.mcs.p6.service.SynTimerTask ======== END!");
	}
}
