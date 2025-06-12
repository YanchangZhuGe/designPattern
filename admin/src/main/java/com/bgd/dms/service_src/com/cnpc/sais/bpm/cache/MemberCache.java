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
 * @author 夏烨  
 * @version 创建时间：2009-10-14 下午04:15:42 
 * 类说明 
 */
public class MemberCache {
	  private Cache cache;
	  private IProcInstSrv procInstSrv;
	  //创建一个单例
      static private MemberCache instance = new MemberCache();

	  
	  
//	构造函数
	    private MemberCache() {
	        try {
	            //初始化缓存对象
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
	    	System.out.println("模板缓存成功！");
	    }
	    public void storeObjectClass(String key,Class cls,Object obj)
	    {
	    	key = cls.getName()+"_"+key;
	    	cache.store(key, obj);
	    	System.out.println("模板缓存成功！");
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
	    			throw new RuntimeException("模版加载失败，未找到该模版");
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
