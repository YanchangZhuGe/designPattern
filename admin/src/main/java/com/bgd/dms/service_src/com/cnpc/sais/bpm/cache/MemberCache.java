package com.cnpc.sais.bpm.cache;

import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.sais.bpm.IProcInstSrv;
import com.cnpc.sais.bpm.ProcInstSrv;
import com.cnpc.sais.bpm.define.entity.process.ProcessDefineEntity;
import com.cnpc.sais.bpm.pojo.WfDProcdefine;
import com.cnpc.sais.bpm.service.ProcDefineService;
import com.whirlycott.cache.Cache;
import com.whirlycott.cache.CacheException;
import com.whirlycott.cache.CacheManager;
/** 
 * @author ����  
 * @version ����ʱ�䣺2009-10-14 ����04:15:42 
 * ��˵�� 
 */
public class MemberCache {
	  private Cache cache;
	  private IProcInstSrv procInstSrv;
	  //����һ������
      static private MemberCache instance = new MemberCache();

	  
	  
//	���캯��
	    private MemberCache() {
	        try {
	            //��ʼ���������
	            cache = CacheManager.getInstance().getCache();
	          //  this.storeprocProcDefins();
	        } catch (CacheException ex) {
	        	ex.printStackTrace();
	           System.out.println("Cannot get the WhirlyCache. Member caching is disabled:"+ ex);
	        } catch (LinkageError e) {
	        	e.printStackTrace();
	            // @todo: Should be never throw
	           System.out.println("Cannot get the WhirlyCache caused by Package Conflict. Member caching is disabled.:"+e);
	        }
	    }
	 
	    static public MemberCache getInstance() {
	        return instance;
	    }
	 
	    
	    public void storeObject(String key,Object obj)
	    {
	    	key = obj.getClass().getName()+"_"+key;
	    	cache.store(key, obj);
	    	System.out.println("ģ�建��ɹ���");
	    }
	    public void storeObjectClass(String key,Class cls,Object obj)
	    {
	    	key = cls.getName()+"_"+key;
	    	cache.store(key, obj);
	    	System.out.println("ģ�建��ɹ���");
	    }
	    public ProcessDefineEntity retrieveProcDefine(String key)
	    {
	    	ProcessDefineEntity processDefineEntity=(ProcessDefineEntity)retrieveObject(ProcessDefineEntity.class,key);
	    	if(processDefineEntity==null){
	    		ProcDefineService procdefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
	    		String []keys=key.split("_");
	    		WfDProcdefine wfDProcdefine=null;
	    		try{
	    			wfDProcdefine=procdefineService.getProcdefineDAO().queryProcByEnameVersion(keys[0], keys[1]);
	    		}catch(Exception e){
	    			throw new RuntimeException("ģ�����ʧ�ܣ�δ�ҵ���ģ��");
	    		}
	    		processDefineEntity=procdefineService.initProcDefines(this, wfDProcdefine);
	    	}
	      return processDefineEntity; 
	    	
	    }
	    
	    public Object retrieveObject(Class cls,String key){
	    	key = cls.getName()+"_"+key;
	    	return cache.retrieve(key);
	    }
	 
	    public void clear() {
	        if (cache != null) {
	            cache.clear();
	        }
	    }
	   /* private void storeprocInstSrv()
	    {
	    	procInstSrv=(IProcInstSrv) BeanFactory.getBean("ProcInstSrv");
	    }*/
	    private void storeprocProcDefins()
	    {
	    	ProcDefineService procdefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
	    	procdefineService.initProcDefines(this);
	    }
	    public int size()
	    {
	    	return this.cache.size();
	    }

	 /*   public IProcInstSrv getProcInstSrv(){
	    	return (IProcInstSrv) this.retrieveObject(ProcInstSrv.class, "procInstSrv");
	    }*/
	    public IProcInstSrv getProcInstSrv(){
	    	if(procInstSrv!=null){
	    		return procInstSrv;
	    	}else{
	    		procInstSrv=(IProcInstSrv) BeanFactory.getBean("ProcInstSrv");
	    		return procInstSrv;
	    	}
	    	
	    }
	    public void reloadProcDefins(){
	    	this.clear();
	    	storeprocProcDefins();
	    }

}
