package com.bgp.gms.service.wt.prointe;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.cxf.binding.corba.wsdl.Array;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class WtProinteSrv extends BaseService{
	private ILog log;
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private RADJdbcDao radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	 
	public WtProinteSrv() {
		log = LogFactory.getLogger(WtProinteSrv.class);

	}
	/**
	 * 添加或修改处理解释任务书
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateTaskBookWt(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();		
		Map map = isrvmsg.toMap();
		String taskbook_id = (String)map.get("taskbook_id");
		String ucmDocId = (String)map.get("ucm_id");
		String file_name=(String)map.get("file_name");
		String upload_file_name=(String)map.get("upload_file_name");
		
		MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
		if(upload_file_name!=null&&!"".equals(upload_file_name)){
			byte[] fileBytes = null;
			if(file_name != ""){
				fileBytes = MyUcm.getFileBytes(file_name, user);
			}
			if(fileBytes != null && fileBytes.length > 0){
				ucmDocId = myUcm.uploadFile(file_name, fileBytes);
			}
			map.put("file_name", file_name);
			map.put("ucm_id", ucmDocId);
		}
		if(taskbook_id!=null&&!"".equals(taskbook_id)){
			map.put("taskbook_id", taskbook_id);	
			map.put("updatator", user.getUserId());	
		}
		map.put("bsflag", "0");
		map.put("create_date", new Date());
		map.put("creator", user.getUserId());
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_prointe_taskbook_wt");
		String message="导入成功!";
		responseDTO.setValue("message", message);
		return responseDTO;
	}
	
	/**
	 * 删除解释处理任务书
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteTaskBookWt(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String taskbooks = isrvmsg.getValue("taskbooks");
		String taskbookIds[] = taskbooks.split(",");
		for(int i=0;i<taskbookIds.length;i++){
			String taskbookId = taskbookIds[i];
			radDao.deleteEntity("gp_ops_prointe_taskbook_wt", taskbookId);
		}
		return responseDTO;
	}
	
	public ISrvMsg saveOrUpdateHandle(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);// ????????
		UserToken user = reqDTO.getUserToken();
		MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
		Map map = reqDTO.toMap();
		String design_id = (String)map.get("design_id");
	
	 
		String ucmDocId = (String)map.get("ucm_id");
		String file_name=(String)map.get("file_name");
		byte[] fileBytes = null;
		if(file_name != ""){
			fileBytes = MyUcm.getFileBytes(file_name, user);
		}
		if(fileBytes != null && fileBytes.length > 0){
			ucmDocId = myUcm.uploadFile(file_name, fileBytes);
		}
		
		
		if(ucmDocId!=""){
			map.put("file_name", file_name);
			map.put("ucm_id", ucmDocId);
		}
		if(design_id!=null&&!"".equals(design_id)){
			map.put("design_id", design_id);
			
		}
		map.put("bsflag", "0");
		map.put("create_date", new Date());
 
		map.put("creator", user.getUserId());
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_prointe_design_wt");

		String message="导入成功!";
		msg.setValue("message", message);
		return msg;
		 
	}
	public ISrvMsg getProjectInfo(ISrvMsg reqDTO) throws Exception{
		String design_id=reqDTO.getValue("design_id");
		
		String sql="select wt.* ,t.project_name from GP_OPS_PROINTE_DESIGN_WT wt left join gp_task_project t on"
				+ " t.project_info_no=wt.project_info_no and t.bsflag='0' where wt.bsflag='0' and wt.design_id='"+ design_id+"'";
		
		Map map = jdbcDao.queryRecordBySQL(sql);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		msg.setValue("map", map);
		return msg;
		
	}
	public ISrvMsg deleteHandle(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String designId = isrvmsg.getValue("ids");
		String designIds[] = designId.split(",");
		for(int i=0;i<designIds.length;i++){
			String design_id = designIds[i];
			radDao.deleteEntity("GP_OPS_PROINTE_DESIGN_WT", design_id);
		}
		
		return responseDTO;
	}
	

	/**
	 * 添加或修改项目人员
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdatePerjPersonWt(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();		
		String rowIds = isrvmsg.getValue("rowIds");
		String project_info_no = isrvmsg.getValue("project_info_id");
		
		String[] ids = rowIds.split(","); 
		List tempList = radDao.queryRecords("select PROJPERSON_ID from GP_OPS_PROINTE_PROJPERSON_WT where PROJECT_INFO_NO='"+project_info_no+"'");
		List<String> oldList = new ArrayList<String>();
		if(tempList!=null){
			for(int j=0;j<tempList.size();j++){
				Map tempMap = (Map)tempList.get(j);
				String tempId = (String)tempMap.get("projperson_id");
				oldList.add(tempId);
			}	
		}
		for(int i = 0;i<ids.length;i++){
			String rowId = ids[i];
			String projpersonId  = isrvmsg.getValue("projpersonId"+rowId);			
			String personnalId  = isrvmsg.getValue("personnalId"+rowId);
			String position  = isrvmsg.getValue("position"+rowId);
			String in_project_date  = isrvmsg.getValue("in_project_date"+rowId);
			String remark  = isrvmsg.getValue("remark"+rowId);
			
			Map<String,Object> map =new  HashMap<String, Object>();
			map.put("personnel_id", personnalId);
			map.put("project_info_no", project_info_no);
			map.put("remark", remark);
			map.put("in_project_date", in_project_date);
			map.put("position", position);
			map.put("bsflag","0");
			if(!"".equals(projpersonId)&&projpersonId!=null){
				map.put("projperson_id",projpersonId);				
			}else{
				map.put("creator",user.getUserId());
				map.put("creator_name",user.getUserName());
				map.put("create_date",new Date());				
			}
			if(oldList!=null){
				if(oldList.contains(projpersonId)){
					oldList.remove(projpersonId);
				}
			}
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_prointe_projperson_wt");
		}
		
		for(int q=0;q<oldList.size();q++){
			radDao.executeUpdate("update gp_ops_prointe_projperson_wt set bsflag='1' where projperson_id='"+oldList.get(q)+"'");			
		}
		return responseDTO;
	}
	
}
