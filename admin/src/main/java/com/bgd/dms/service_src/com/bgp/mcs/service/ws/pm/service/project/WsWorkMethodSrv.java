package com.bgp.mcs.service.ws.pm.service.project;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import oracle.stellent.ridc.IdcClientException;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;


public class WsWorkMethodSrv  extends BaseService {
	
	
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	private JdbcTemplate dao = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	
	/**
	 * 保存井中施工方法
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveWsWorkMethod(ISrvMsg reqDTO) throws Exception{
		
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		
		int really_type = Integer.valueOf(reqDTO.getValue("reallyType")).intValue();

		/**观测系统**/
		if(reqDTO.getValue("layoutnum")!=null&&Integer.valueOf(reqDTO.getValue("layoutnum")).intValue()!=0){
			int layoutnum = Integer.valueOf(reqDTO.getValue("layoutnum")).intValue();
			//List oldArtilleryFile = dao.queryForList("select artillery_file from gp_ws_system where project_info_no='"+project_info_no+"'");
			dao.execute("delete from gp_ws_system where project_info_no='"+project_info_no+"'");
			//新增
			for (int i = 0; i < layoutnum; i++) {
				wsSaveLayout(reqDTO,i+1);
			}
		}
		
		/**井炮**/
		if(reqDTO.getValue("wellArtilleryIndex")!=null&&Integer.valueOf(reqDTO.getValue("wellArtilleryIndex")).intValue()!=0){
			//存在井炮数据
			int wellArtilleryIndex = Integer.valueOf(reqDTO.getValue("wellArtilleryIndex")).intValue();
			dao.execute("delete from gp_ws_well_artillery where project_info_no='"+project_info_no+"' and really_type="+really_type);
			for (int i = 0; i < wellArtilleryIndex; i++) {
				wsSaveWellArtillery(reqDTO,i+1);
			}
		}
		
		/**震源**/
		if(reqDTO.getValue("sourceIndex")!=null&&Integer.valueOf(reqDTO.getValue("sourceIndex")).intValue()!=0){
			int sourceIndex = Integer.valueOf(reqDTO.getValue("sourceIndex")).intValue();
			dao.execute("delete from gp_ws_quake_source where project_info_no='"+project_info_no+"' and really_type="+really_type);
			for (int i = 0; i < sourceIndex; i++) {
				wsSaveSource(reqDTO,i+1);
			}
		}
		
		/**气枪**/
		if(reqDTO.getValue("aigGunIndex")!=null&&Integer.valueOf(reqDTO.getValue("aigGunIndex")).intValue()!=0){
			int aigGunIndex = Integer.valueOf(reqDTO.getValue("aigGunIndex")).intValue();
			dao.execute("delete from gp_ws_air_gun where project_info_no='"+project_info_no+"' and really_type="+really_type);
			for (int i = 0; i < aigGunIndex; i++) {
				wsSaveAigGun(reqDTO,i+1);
			}
		}
		
		/**井下扫描源**/
		if(reqDTO.getValue("scanSourceIndex")!=null&&Integer.valueOf(reqDTO.getValue("scanSourceIndex")).intValue()!=0){
			int scanSourceIndex = Integer.valueOf(reqDTO.getValue("scanSourceIndex")).intValue();
			dao.execute("delete from gp_ws_scan_source where project_info_no='"+project_info_no+"' and really_type="+really_type);
			for (int i = 0; i < scanSourceIndex; i++) {
				wsSaveScanSource(reqDTO,i+1);
			}
		}
		
		/**井下脉冲源**/
		if (reqDTO.getValue("pulseSourceIndex")!=null&&Integer.valueOf(reqDTO.getValue("pulseSourceIndex")).intValue()!=0) {
			int pulseSourceIndex = Integer.valueOf(reqDTO.getValue("pulseSourceIndex")).intValue();
			dao.execute("delete from gp_ws_pulse_source where project_info_no='"+project_info_no+"' and really_type="+really_type);
			for (int i = 0; i < pulseSourceIndex; i++) {
				wsSavePulseSource(reqDTO,i+1);
			}
		}
		
		
		/**接受参数**/
		if (reqDTO.getValue("acceptParaIndex")!=null&&Integer.valueOf(reqDTO.getValue("acceptParaIndex")).intValue()!=0) {
			int acceptParaIndex = Integer.valueOf(reqDTO.getValue("acceptParaIndex")).intValue();
			dao.execute("delete from gp_ws_accept_para  where project_info_no='"+project_info_no+"'");
			for (int i = 0; i < acceptParaIndex; i++) {
				wsSaveAcceptPara(reqDTO,i+1);
			}
		}
		/**仪器参数**/
		if (reqDTO.getValue("instrumentParaIndex")!=null&&Integer.valueOf(reqDTO.getValue("instrumentParaIndex")).intValue()!=0) {
			int instrumentParaIndex = Integer.valueOf(reqDTO.getValue("instrumentParaIndex")).intValue();
			dao.execute("delete from gp_ws_instrument_para  where project_info_no='"+project_info_no+"'");
			for (int i = 0; i < instrumentParaIndex; i++) {
				wsSaveInstrumentPara(reqDTO,i+1);
			}
		}
		
		/**平面位置图**/
		if (reqDTO.getValue("positionImageIndex")!=null&&Integer.valueOf(reqDTO.getValue("positionImageIndex")).intValue()!=0) {
			int positionImageIndex = Integer.valueOf(reqDTO.getValue("positionImageIndex")).intValue();
			dao.execute("delete from gp_ws_position_image where project_info_no='"+project_info_no+"'");
			for (int i = 0; i < positionImageIndex; i++) {
				wsSavePositionImage(reqDTO,i+1);
			}
		}
		
		

//		
//		map.put("project_info_no",project_info_no);
//		map.put("line_group_id", line_group_id);
//		map.put("work_type", work_type);
//		map.put("name", task_name);
//		map.put("workarea_name", workarea_name);
//		map.put("team_name", team_name);
//		map.put("produce_date", produce_date);
//		map.put("receive_name", receive_name);
//		map.put("send_name", send_name);
//		map.put("folder_id", folder_id);
//		
//		map.put("bsflag", "0");
//		
//		// 保存文件
//		String fileName = "";
//		String fileUcmId = "";
//		String fileType = "";
//		String oldUcmId = reqDTO.getValue("oldUcmId") != null?reqDTO.getValue("oldUcmId"):"";
//		boolean fileExist = false;
//		
//		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
//		mqMsg.
//		List<WSFile> fileList = mqMsg.getFiles();
//		if(fileList.size()!=0){
//			WSFile uploadFile = fileList.get(0);
//			fileName = uploadFile.getFilename();
//			fileType = uploadFile.getType();
//			byte[] uploadData = uploadFile.getFileData();
//			fileUcmId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
//			map.put("ucm_id", fileUcmId);
//			
//			fileExist = true;
//		}
//		
//		Serializable taskbook_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_ops_work_report");
//		
//		if(!"".equals(oldUcmId)){
//			// 删除旧的文件记录
//			myUcm.deleteFile(oldUcmId);
//			String sql = "update bgp_doc_gms_file set bsflag = '1' where ucm_id = '" + oldUcmId + "'";
//			RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
//			JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
//			jdbcTemplate.execute(sql);
//		}
//		
//		if(fileExist){
//			Map fileMap = new HashMap();
//			fileMap.put("file_name", fileName);
//			fileMap.put("ucm_id", fileUcmId);
//			fileMap.put("file_type", fileType);
//			fileMap.put("parent_file_id", folder_id);
//		
//			fileMap.put("project_info_no", project_info_no);
//			fileMap.put("bsflag", "0");
//			fileMap.put("is_file", "1");
//			fileMap.put("creator_id", user.getEmpId());
//			fileMap.put("create_date", new Date());
//		
//			String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fileMap, "bgp_doc_gms_file").toString();
//			myUcm.docVersion(doc_pk_id, "1.0", fileUcmId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
//			myUcm.docLog(doc_pk_id, "1.0", 1, fileUcmId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
//		}
//		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		responseDTO.setValue("saveResult", "1");
		return responseDTO;
//		return null;
	}
	
	/**
	 * 测线平面位置图
	 * @param reqDTO
	 * @param i
	 */
	private void wsSavePositionImage(ISrvMsg reqDTO, int rownum)  throws Exception {
		
		Map<String,Object> rs = new HashMap<String,Object>();
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		

		String observation_system = reqDTO.getValue("observation_system_"+rownum)!=null?reqDTO.getValue("observation_system_"+rownum):"";
		String mapping_images = reqDTO.getValue("mapping_images_"+rownum)!=null?reqDTO.getValue("mapping_images_"+rownum):"";
		
		rs.put("project_info_no", project_info_no);
		rs.put("observation_system", observation_system);
		rs.put("mapping_images", mapping_images);//存在以前文件 保存
		rs.put("ordernum", rownum);
		
		//保存文件
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList.size()!=0){
			
			for (WSFile uploadFile:fileList) {
				if(uploadFile.getKey().equals("mapping_images_file_"+rownum)){
					byte[] uploadData = uploadFile.getFileData();
					String fileUcmId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
					rs.put("mapping_images", fileUcmId);
				}
			}
		}

		
		
		pureDao.saveOrUpdateEntity(rs, "gp_ws_position_image");
		
		 		
	}

	/**
	 * 仪器参数
	 * @param reqDTO
	 * @param i
	 */
	private void wsSaveInstrumentPara(ISrvMsg reqDTO, int rownum) throws Exception{
		
		Map<String,Object> rs = new HashMap<String,Object>();
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		

		String instrument_type = reqDTO.getValue("instrument_type_"+rownum)!=null?reqDTO.getValue("instrument_type_"+rownum):"";
		String well_instrument_type = reqDTO.getValue("well_instrument_type_"+rownum)!=null?reqDTO.getValue("well_instrument_type_"+rownum):"";
		String well_instrument_level = reqDTO.getValue("well_instrument_level_"+rownum)!=null?reqDTO.getValue("well_instrument_level_"+rownum):"";
		String well_instrument_distance = reqDTO.getValue("well_instrument_distance_"+rownum)!=null?reqDTO.getValue("well_instrument_distance_"+rownum):"";
		String record_length = reqDTO.getValue("record_length_"+rownum)!=null?reqDTO.getValue("record_length_"+rownum):"";
		String sampling_interval = reqDTO.getValue("sampling_interval_"+rownum)!=null?reqDTO.getValue("sampling_interval_"+rownum):"";
		String filtering_type = reqDTO.getValue("filtering_type_"+rownum)!=null?reqDTO.getValue("filtering_type_"+rownum):"";
		String high_frequency = reqDTO.getValue("high_frequency_"+rownum)!=null?reqDTO.getValue("high_frequency_"+rownum):"";
		String low_frequency = reqDTO.getValue("low_frequency_"+rownum)!=null?reqDTO.getValue("low_frequency_"+rownum):"";
		String preamp_gain = reqDTO.getValue("preamp_gain_"+rownum)!=null?reqDTO.getValue("preamp_gain_"+rownum):"";
		String demodulator_component_product = reqDTO.getValue("demodulator_component_product_"+rownum)!=null?reqDTO.getValue("demodulator_component_product_"+rownum):"";
		rs.put("project_info_no", project_info_no);
		rs.put("instrument_type", instrument_type);
		rs.put("well_instrument_type", well_instrument_type);
		rs.put("well_instrument_level", well_instrument_level);
		rs.put("well_instrument_distance", well_instrument_distance);
		rs.put("record_length", record_length);
		rs.put("sampling_interval", sampling_interval);
		rs.put("filtering_type", filtering_type);
		rs.put("high_frequency", high_frequency);
		rs.put("low_frequency", low_frequency);
		rs.put("preamp_gain", preamp_gain);
		rs.put("demodulator_component_product", demodulator_component_product);
		rs.put("ordernum", rownum);
		
		pureDao.saveOrUpdateEntity(rs, "gp_ws_instrument_para");
		
		
	}

	/**
	 * 接受参数
	 * @param reqDTO
	 * @param i
	 */
	private void wsSaveAcceptPara(ISrvMsg reqDTO, int rownum) throws Exception{
		Map<String,Object> rs = new HashMap<String,Object>();
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		

		String well_instrument_model = reqDTO.getValue("well_instrument_model_"+rownum)!=null?reqDTO.getValue("well_instrument_model_"+rownum):"";
		String well_instrument_type = reqDTO.getValue("well_instrument_type_"+rownum)!=null?reqDTO.getValue("well_instrument_type_"+rownum):"";
		String demodulator_component_product = reqDTO.getValue("demodulator_component_product_"+rownum)!=null?reqDTO.getValue("demodulator_component_product_"+rownum):"";
		String pushed_type = reqDTO.getValue("pushed_type_"+rownum)!=null?reqDTO.getValue("pushed_type_"+rownum):"";
		
		
		rs.put("project_info_no", project_info_no);
		rs.put("well_instrument_model", well_instrument_model);
		rs.put("well_instrument_type", well_instrument_type);
		rs.put("demodulator_component_product", demodulator_component_product);
		rs.put("pushed_type", pushed_type);
		
		rs.put("ordernum", rownum);
		
		pureDao.saveOrUpdateEntity(rs, "gp_ws_accept_para");
		
	}

	/**
	 * 井下脉冲源
	 * @param reqDTO
	 * @param i
	 */
	private void wsSavePulseSource(ISrvMsg reqDTO, int rownum) throws Exception{
		
		Map<String,Object> rs = new HashMap<String,Object>();
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		

		String pulse_quake_type = reqDTO.getValue("pulse_quake_type_"+rownum)!=null?reqDTO.getValue("pulse_quake_type_"+rownum):"";
		String pulse_quake_power = reqDTO.getValue("pulse_quake_power_"+rownum)!=null?reqDTO.getValue("pulse_quake_power_"+rownum):"";
		
		rs.put("project_info_no", project_info_no);
		rs.put("pulse_quake_type", pulse_quake_type);
		rs.put("pulse_quake_power", pulse_quake_power);
		rs.put("ordernum", rownum);
		int really_type = Integer.valueOf(reqDTO.getValue("reallyType")).intValue();
		rs.put("really_type", really_type);
		
		pureDao.saveOrUpdateEntity(rs, "gp_ws_pulse_source");
		
	}

	/**
	 * 井下扫描源
	 * @param reqDTO
	 * @param i
	 */
	private void wsSaveScanSource(ISrvMsg reqDTO, int rownum) throws Exception{
		
		Map<String,Object> rs = new HashMap<String,Object>();
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		
		String scan_quake_type = reqDTO.getValue("scan_quake_type_"+rownum)!=null?reqDTO.getValue("scan_quake_type_"+rownum):"";
		String scan_quake_power = reqDTO.getValue("scan_quake_power_"+rownum)!=null?reqDTO.getValue("scan_quake_power_"+rownum):"";
		String scan_quake_num = reqDTO.getValue("scan_quake_num_"+rownum)!=null?reqDTO.getValue("scan_quake_num_"+rownum):"";
		String source_scan_type = reqDTO.getValue("source_scan_type_"+rownum)!=null?reqDTO.getValue("source_scan_type_"+rownum):"";
		String scan_begin_frequency = reqDTO.getValue("scan_begin_frequency_"+rownum)!=null?reqDTO.getValue("scan_begin_frequency_"+rownum):"";
		String scan_end_frequency = reqDTO.getValue("scan_end_frequency_"+rownum)!=null?reqDTO.getValue("scan_end_frequency_"+rownum):"";
		String source_scan_length = reqDTO.getValue("source_scan_length_"+rownum)!=null?reqDTO.getValue("source_scan_length_"+rownum):"";	
		
		rs.put("project_info_no", project_info_no);
		rs.put("scan_quake_type", scan_quake_type);
		rs.put("scan_quake_power", scan_quake_power);
		rs.put("scan_quake_num", scan_quake_num);
		rs.put("source_scan_type", source_scan_type);
		rs.put("scan_begin_frequency", scan_begin_frequency);
		rs.put("scan_end_frequency", scan_end_frequency);
		rs.put("source_scan_length", source_scan_length);
		rs.put("ordernum", rownum);
		int really_type = Integer.valueOf(reqDTO.getValue("reallyType")).intValue();
		rs.put("really_type", really_type);
		
		pureDao.saveOrUpdateEntity(rs, "gp_ws_scan_source");
		
	}
	/**
	 * 气枪
	 * @param reqDTO
	 * @param i
	 */
	private void wsSaveAigGun(ISrvMsg reqDTO, int rownum) throws Exception{
		
		Map<String,Object> rs = new HashMap<String,Object>();
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		
		String air_gun_type= reqDTO.getValue("air_gun_type_"+rownum)!=null?reqDTO.getValue("air_gun_type_"+rownum):"";
		String volume_total= reqDTO.getValue("volume_total_"+rownum)!=null?reqDTO.getValue("volume_total_"+rownum):"";
		String air_gun_pressure= reqDTO.getValue("air_gun_pressure_"+rownum)!=null?reqDTO.getValue("air_gun_pressure_"+rownum):"";
		String gun_num= reqDTO.getValue("gun_num_"+rownum)!=null?reqDTO.getValue("gun_num_"+rownum):"";
		String peak_value= reqDTO.getValue("peak_value_"+rownum)!=null?reqDTO.getValue("peak_value_"+rownum):"";
		String bubble_ratio= reqDTO.getValue("bubble_ratio_"+rownum)!=null?reqDTO.getValue("bubble_ratio_"+rownum):"";
		String bandwidth= reqDTO.getValue("bandwidth_"+rownum)!=null?reqDTO.getValue("bandwidth_"+rownum):"";
		String array_length= reqDTO.getValue("array_length_"+rownum)!=null?reqDTO.getValue("array_length_"+rownum):"";
		
		rs.put("project_info_no", project_info_no);
		rs.put("air_gun_type", air_gun_type);
		rs.put("volume_total", volume_total);
		rs.put("air_gun_pressure", air_gun_pressure);
		rs.put("gun_num", gun_num);
		rs.put("peak_value", peak_value);
		rs.put("bubble_ratio", bubble_ratio);
		rs.put("bandwidth", bandwidth);
		rs.put("array_length", array_length);
		rs.put("ordernum", rownum);
		int really_type = Integer.valueOf(reqDTO.getValue("reallyType")).intValue();
		rs.put("really_type", really_type);
		
		pureDao.saveEntity(rs, "gp_ws_air_gun");
		
	}

	/**
	 * 震源
	 * @param reqDTO
	 * @param i
	 */
	private void wsSaveSource(ISrvMsg reqDTO, int rownum) throws Exception{
		Map<String,Object> rs = new HashMap<String,Object>();
		
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		
		String quake_type= reqDTO.getValue("quake_type_"+rownum)!=null?reqDTO.getValue("quake_type_"+rownum):"";
		String quake_box= reqDTO.getValue("quake_box_"+rownum)!=null?reqDTO.getValue("quake_box_"+rownum):"";
		String quake_machine_num= reqDTO.getValue("quake_machine_num_"+rownum)!=null?reqDTO.getValue("quake_machine_num_"+rownum):"";
		String quake_num= reqDTO.getValue("quake_num_"+rownum)!=null?reqDTO.getValue("quake_num_"+rownum):"";
		String quake_direction= reqDTO.getValue("quake_direction_"+rownum)!=null?reqDTO.getValue("quake_direction_"+rownum):"";
		String quake_cardinal_distance= reqDTO.getValue("quake_cardinal_distance_"+rownum)!=null?reqDTO.getValue("quake_cardinal_distance_"+rownum):"";
		String scan_type= reqDTO.getValue("scan_type_"+rownum)!=null?reqDTO.getValue("scan_type_"+rownum):"";
		String frequency_compensation= reqDTO.getValue("frequency_compensation_"+rownum)!=null?reqDTO.getValue("frequency_compensation_"+rownum):"";
		String begin_frequency= reqDTO.getValue("begin_frequency_"+rownum)!=null?reqDTO.getValue("begin_frequency_"+rownum):"";
		String end_frequency= reqDTO.getValue("end_frequency_"+rownum)!=null?reqDTO.getValue("end_frequency_"+rownum):"";
		String scan_length = reqDTO.getValue("scan_length_"+rownum)!=null?reqDTO.getValue("scan_length_"+rownum):"";
		String driving_scope = reqDTO.getValue("driving_scope_"+rownum)!=null?reqDTO.getValue("driving_scope_"+rownum):"";
		String start_stop_slope = reqDTO.getValue("start_stop_slope_"+rownum)!=null?reqDTO.getValue("start_stop_slope_"+rownum):"";
		String slide_scan_time = reqDTO.getValue("slide_scan_time_"+rownum)!=null?reqDTO.getValue("slide_scan_time_"+rownum):"";
		
		rs.put("project_info_no", project_info_no);
		rs.put("quake_type", quake_type);
		rs.put("quake_box", quake_box);
		rs.put("quake_machine_num", quake_machine_num);
		rs.put("quake_num", quake_num);
		rs.put("quake_direction", quake_direction);
		rs.put("quake_cardinal_distance", quake_cardinal_distance);
		rs.put("scan_type", scan_type);
		rs.put("frequency_compensation", frequency_compensation);
		rs.put("begin_frequency", begin_frequency);
		rs.put("end_frequency", end_frequency);
		rs.put("scan_length", scan_length);
		rs.put("driving_scope", driving_scope);
		rs.put("start_stop_slope", start_stop_slope);
		rs.put("slide_scan_time", slide_scan_time);
		rs.put("ordernum", rownum);
		
		int really_type = Integer.valueOf(reqDTO.getValue("reallyType")).intValue();
		rs.put("really_type", really_type);
		pureDao.saveEntity(rs, "gp_ws_quake_source");
		
	}

	/**
	 * 保存观测系统数据
	 * rownum 第几条数据
	 * rownumFile key:第几条数据 value:第几次出现文件
	 * @throws IdcClientException 
	 */
	@SuppressWarnings("unchecked")
	private void wsSaveLayout(ISrvMsg reqDTO,int rownum) throws Exception{
		

		Map rs = new HashMap();
		UserToken user = reqDTO.getUserToken();
		
		String project_info_no = user.getProjectInfoNo();
		//String id = reqDTO.getValue("layoutid_"+rownum) != null?reqDTO.getValue("layoutid_"+rownum):"";
		String wave_x = reqDTO.getValue("wave_x_"+rownum) != null?reqDTO.getValue("wave_x_"+rownum):"";
		String wave_y = reqDTO.getValue("wave_y_"+rownum) != null?reqDTO.getValue("wave_y_"+rownum):"";
		String wave_z = reqDTO.getValue("wave_z_"+rownum) != null?reqDTO.getValue("wave_z_"+rownum):"";
		String artillery_file = reqDTO.getValue("artillery_file_"+rownum) != null?reqDTO.getValue("artillery_file_"+rownum):"";//炮点文件
		String artillery_total = reqDTO.getValue("artillery_total_"+rownum) != null?reqDTO.getValue("artillery_total_"+rownum):"";
		String artillery_area = reqDTO.getValue("artillery_area_"+rownum) != null?reqDTO.getValue("artillery_area_"+rownum):"";
		String max_offset = reqDTO.getValue("max_offset_"+rownum) != null?reqDTO.getValue("max_offset_"+rownum):"";
		String artillery_point = reqDTO.getValue("artillery_point_"+rownum) != null?reqDTO.getValue("artillery_point_"+rownum):"";
		String observe_point = reqDTO.getValue("observe_point_"+rownum) != null?reqDTO.getValue("observe_point_"+rownum):"";
		String observe_begin_depth = reqDTO.getValue("observe_begin_depth_"+rownum) != null?reqDTO.getValue("observe_begin_depth_"+rownum):"";
		String observe_end_depth = reqDTO.getValue("observe_end_depth_"+rownum) != null?reqDTO.getValue("observe_end_depth_"+rownum):"";
		String observe_level = reqDTO.getValue("observe_level_"+rownum) != null?reqDTO.getValue("observe_level_"+rownum):"";
		String observe_physical_point = reqDTO.getValue("observe_physical_point_"+rownum) != null?reqDTO.getValue("observe_physical_point_"+rownum):"";
		rs.put("project_info_no", project_info_no);
//		rs.put("id", id);
		rs.put("wave_x", wave_x);
		rs.put("wave_y", wave_y);
		rs.put("wave_z", wave_z);
		rs.put("artillery_total", artillery_total);
		rs.put("artillery_area", artillery_area);
		rs.put("max_offset", max_offset);
		rs.put("artillery_point", artillery_point);
		rs.put("observe_point", observe_point);
		rs.put("observe_begin_depth", observe_begin_depth);
		rs.put("observe_end_depth", observe_end_depth);
		rs.put("observe_level", observe_level);
		rs.put("observe_physical_point", observe_physical_point);
		rs.put("ordernum", rownum);
		rs.put("artillery_file", artillery_file);//保存文件
		
		// 保存文件
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList.size()!=0){
			for(WSFile uploadFile:fileList){
				if(uploadFile.getKey().equals("artillery_file_file_"+rownum)){
					byte[] uploadData = uploadFile.getFileData();
					String fileUcmId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
					rs.put("artillery_file", fileUcmId);
				}
			}
		}
		//保存数据
		pureDao.saveEntity(rs, "gp_ws_system").toString();	
	}
	
	/**
	 * 保存井炮数据
	 * @throws IdcClientException 
	 */
	@SuppressWarnings("unchecked")
	private void wsSaveWellArtillery(ISrvMsg reqDTO,int rownum) throws Exception{
		Map rs = new HashMap();
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		//String id = reqDTO.getValue("layoutid_"+rownum) != null?reqDTO.getValue("layoutid_"+rownum):"";
		String well_total_depth = reqDTO.getValue("well_total_depth_"+rownum) != null?reqDTO.getValue("well_total_depth_"+rownum):"";
		String drug_quantity = reqDTO.getValue("drug_quantity_"+rownum) != null?reqDTO.getValue("drug_quantity_"+rownum):"";
		String drug_type = reqDTO.getValue("drug_type_"+rownum) != null?reqDTO.getValue("drug_type_"+rownum):"";
		rs.put("project_info_no", project_info_no);
//		rs.put("id", id);
		rs.put("well_total_depth", well_total_depth);
		rs.put("drug_quantity", drug_quantity);
		rs.put("drug_type", drug_type);
		rs.put("ordernum", rownum);
		int really_type = Integer.valueOf(reqDTO.getValue("reallyType")).intValue();
		rs.put("really_type", really_type);
		pureDao.saveEntity(rs, "gp_ws_well_artillery");
		
		
		
	}
	
//	
//	public ISrvMsg saveWork3Method(ISrvMsg reqDTO) throws Exception{
//		Map map = reqDTO.toMap();
//		UserToken user = reqDTO.getUserToken();
//		String wa3dID = reqDTO.getValue("wa3d_id");
//		if(wa3dID == null || "".equals(wa3dID)){
//			map.put("creator", user.getEmpId());
//			map.put("create_date", new Date());
//		}
//		map.put("bslag", "0");
//		map.put("updator", user.getEmpId());
//		map.put("modifi_date", new Date());
//		
//		Serializable work_method_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_wa3d_method_data");
//		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
//		
//		return msg;
//	}
//	
	/**
	 * 获取井中施工方法
	 * @throws Exception
	 */
	
	public ISrvMsg getWsWorkMethod(ISrvMsg reqDTO) throws Exception {
		String project_info_no = reqDTO.getValue("projectInfoNo");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		int really_type = Integer.valueOf(reqDTO.getValue("reallyType")).intValue();
		if(really_type==0){
			//设计施工方法
			//观测系统
			StringBuffer layoutSql = new StringBuffer("select * from gp_ws_system t");
			layoutSql.append(" where t.project_info_no='").append(project_info_no).append("' order by t.ordernum asc");
			List<Map> layoutData = pureDao.queryRecords(layoutSql.toString());
			//接受参数
			StringBuffer acceptParaSql = new StringBuffer("select * from gp_ws_accept_para t");
			acceptParaSql.append(" where t.project_info_no='").append(project_info_no).append("' order by t.ordernum asc");
			List<Map> acceptParaData = pureDao.queryRecords(acceptParaSql.toString());
			//仪器参数
			StringBuffer instrumentParaSql = new StringBuffer("select * from gp_ws_instrument_para t");
			instrumentParaSql.append(" where t.project_info_no='").append(project_info_no).append("' order by t.ordernum asc");
			List<Map> instrumentParaData = pureDao.queryRecords(instrumentParaSql.toString());
			//测线平面位置图
			StringBuffer positionImageSql = new StringBuffer("select * from gp_ws_position_image t");
			positionImageSql.append(" where t.project_info_no='").append(project_info_no).append("' order by t.ordernum asc");
			List<Map> positionImageData = pureDao.queryRecords(positionImageSql.toString());
			
			responseMsg.setValue("layoutData", layoutData);
			responseMsg.setValue("acceptParaData", acceptParaData);
			responseMsg.setValue("instrumentParaData", instrumentParaData);
			responseMsg.setValue("positionImageData", positionImageData);
			
		}
//		else if(really_type==1){
//			//实际施工方法
//		}
		
		//激发参数 井炮
		StringBuffer wellArtillerySql = new StringBuffer("select * from gp_ws_well_artillery t");
		wellArtillerySql.append(" where t.project_info_no='").append(project_info_no).append("' and really_type=").append(really_type).append(" order by t.ordernum asc");
		List<Map> wellArtilleryData = pureDao.queryRecords(wellArtillerySql.toString());
		//激发参数 震源
		StringBuffer quakeSourceSql = new StringBuffer("select * from gp_ws_quake_source t");
		quakeSourceSql.append(" where t.project_info_no='").append(project_info_no).append("' and really_type=").append(really_type).append(" order by t.ordernum asc");
		List<Map> quakeSourceData = pureDao.queryRecords(quakeSourceSql.toString());
		//激发参数 气枪
		StringBuffer airGunSql = new StringBuffer("select * from gp_ws_air_gun t");
		airGunSql.append(" where t.project_info_no='").append(project_info_no).append("' and really_type=").append(really_type).append(" order by t.ordernum asc");
		List<Map> airGunData = pureDao.queryRecords(airGunSql.toString());
		//激发参数 井下扫描源
		StringBuffer scanSourceSql = new StringBuffer("select * from gp_ws_scan_source t");
		scanSourceSql.append(" where t.project_info_no='").append(project_info_no).append("' and really_type=").append(really_type).append(" order by t.ordernum asc");
		List<Map> scanSourceData = pureDao.queryRecords(scanSourceSql.toString());
		//激发参数 井下脉冲源
		StringBuffer pulseSourceSql = new StringBuffer("select * from gp_ws_pulse_source t");
		pulseSourceSql.append(" where t.project_info_no='").append(project_info_no).append("' and really_type=").append(really_type).append(" order by t.ordernum asc");
		List<Map> pulseSourceData = pureDao.queryRecords(pulseSourceSql.toString());
		
		
		
		responseMsg.setValue("wellArtilleryData", wellArtilleryData);
		responseMsg.setValue("quakeSourceData", quakeSourceData);
		responseMsg.setValue("airGunData", airGunData);
		responseMsg.setValue("scanSourceData", scanSourceData);
		responseMsg.setValue("pulseSourceData", pulseSourceData);
	
		
		return responseMsg;
	}
//	
//	/**
//	 * 获取三维施工方法
//	 * @throws Exception
//	 */
//	public ISrvMsg getWork3Method(ISrvMsg reqDTO) throws Exception {
//		UserToken user = reqDTO.getUserToken();
//		String project_info_no = reqDTO.getValue("projectInfoNo");
//		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
//		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
//		StringBuffer mainDataSql = new StringBuffer("select * from gp_ops_3dwa_design_data");
//		mainDataSql.append(" where project_info_no='").append(project_info_no).append("'");
//		
//		StringBuffer fromDataSql = new StringBuffer("select * from gp_ops_3dwa_design_data_from");
//		fromDataSql.append(" where project_info_no='").append(project_info_no).append("' and bsflag='0' ");
//		fromDataSql.append(" order by section_type,order_num");
//		
//		Map mainData = jdbcDAO.queryRecordBySQL(mainDataSql.toString());
//		List<Map> allFromData = jdbcDAO.queryRecords(fromDataSql.toString());
//		
//		List<Map> layoutData = new ArrayList<Map>();
//		List<Map> spData = new ArrayList<Map>();
//		List<Map> sourceData = new ArrayList<Map>();
//		List<Map> geophoneData = new ArrayList<Map>();
//		List<Map> instrumentData = new ArrayList<Map>();
//		
//		//数据段类型,1:观测系统;2:井炮参数;3:震源参数;4:检波器参数;5:仪器参数
//		if(allFromData != null){
//			for(int i=0; i<allFromData.size(); i++){
//				Map map = allFromData.get(i);
//				String sectionType = "" + map.get("section_type");
//				if("1".equals(sectionType)){
//					layoutData.add(map);
//				}else if("2".equals(sectionType)){
//					spData.add(map);
//				}else if("3".equals(sectionType)){
//					sourceData.add(map);
//				}else if("4".equals(sectionType)){
//					geophoneData.add(map);
//				}else if("5".equals(sectionType)){
//					instrumentData.add(map);
//				}
//			}			
//		}
//		
//		responseMsg.setValue("mainData", mainData);
//		responseMsg.setValue("layoutData", layoutData);
//		responseMsg.setValue("spData", spData);
//		responseMsg.setValue("sourceData", sourceData);
//		responseMsg.setValue("geophoneData", geophoneData);
//		responseMsg.setValue("instrumentData", instrumentData);
//		return responseMsg;
//	}
//	
//	/**
//	 * 获取项目施工方法
//	 * @throws Exception
//	 */
//	public String getProjectWorkMethod(String projectInfoNo) throws Exception {
//		String workmethod = "";
//		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
//		StringBuffer sb = new StringBuffer("select project_info_no,exploration_method from gp_task_project ");
//		sb.append(" where project_info_no ='").append(projectInfoNo).append("'");
//		
//		Map projectInfo = new HashMap();
//		projectInfo = jdbcDAO.queryRecordBySQL(sb.toString());
//		if(projectInfo != null){
//			workmethod = (String)projectInfo.get("exploration_method");
//		}
//		return workmethod;
//	}
//	
//	/**
//	 * 获取项目激发方式
//	 * @throws Exception
//	 */
//	public String getProjectExcitationMode(String projectInfoNo) throws Exception {
//		String build_method = "";
//		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
//		StringBuffer sb = new StringBuffer("select project_info_no,build_method from gp_task_project ");
//		sb.append(" where project_info_no ='").append(projectInfoNo).append("'");
//		
//		Map projectInfo = new HashMap();
//		projectInfo = jdbcDAO.queryRecordBySQL(sb.toString());
//		if(projectInfo != null){
//			build_method = (String)projectInfo.get("build_method");
//		}
//		return build_method;
//	}
}
