package com.bgp.mcs.service.qua.service;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WFCommonBean;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WFVarBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class QualityChartSrv extends BaseService {

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	/**
	 * 仪表盘  --> 仪表盘 --> 项目过滤
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg qualityChart(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null){
			project_info_no= "";
		}
		String name = reqDTO.getValue("name");
		if(name==null){
			name = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append(" select t.qualified_radio qualified ,t.firstlevel_radio first ,t.waster_radio waster ,t.all_miss_radio miss ")
		.append(" from bgp_pm_quality_index t")
		.append(" where t.bsflag='0' and t.project_info_no ='").append(project_info_no).append("'");
		List list = pureJdbcDao.queryRecords(sb.toString());
		double middle = 100 ;
		double upperLimit = 100;
		double lowerLimit = 0;
		if(name !=null && name.trim().equals("qualified") ){
			upperLimit = 100;
			lowerLimit = 99;
		}else if(name !=null && name.trim().equals("first")){
			upperLimit = 100;
			lowerLimit = 60;
		}else{
			upperLimit = 3;
			lowerLimit = 0;
		}
		if(list!=null && list.size()>0){
			Map temp = (Map)list.get(0);
			if(temp!=null){
				if(temp.get(name)!=null && !temp.get(name).toString().trim().equals("")){
					middle = Double.valueOf((String)temp.get(name));
				}
			}
		}
		sb = new StringBuffer();
		//TODO 
		//计算 单个项目的 总炮、合格炮、一级炮、废炮、空炮
		sb.append(" select sum(nvl(t.daily_acquire_sp_num,0)-(-nvl(t.daily_jp_acquire_shot_num,0))-(-nvl(t.daily_qq_acquire_shot_num,0)))total ,sum(nvl(t.daily_acquire_firstlevel_num,0)) first , ")
		.append(" decode(sum(nvl(t.daily_acquire_qualified_num,0)),0,sum(nvl(t.daily_acquire_firstlevel_num,0))-(-sum(nvl(t.collect_2_class,0))),sum(nvl(t.daily_acquire_qualified_num,0))) qualified , ")
		.append(" sum(nvl(t.collect_waster_num,0)) waster ,sum(nvl(t.collect_miss_num,0)) miss from gp_ops_daily_report t ")
		.append(" where t.bsflag='0' and t.audit_status ='3' and t.project_info_no ='").append(project_info_no).append("'");
		if(name!=null && name.equals("first")){
			sb = new StringBuffer();
			sb.append(" select sum(nvl(t.daily_acquire_firstlevel_num,0)-(-nvl(t.collect_2_class,0))-(-nvl(t.collect_waster_num,0))-(-nvl(t.collect_miss_num,0)))total ,sum(nvl(t.daily_acquire_firstlevel_num,0)) first , ")
			.append(" decode(sum(nvl(t.daily_acquire_qualified_num,0)),0,sum(nvl(t.daily_acquire_firstlevel_num,0))-(-sum(nvl(t.collect_2_class,0))),sum(nvl(t.daily_acquire_qualified_num,0))) qualified , ")
			.append(" sum(nvl(t.collect_waster_num,0)) waster ,sum(nvl(t.collect_miss_num,0)) miss from gp_ops_daily_report t ")
			.append(" where t.bsflag='0' and t.audit_status ='3' and t.project_info_no ='").append(project_info_no).append("'");
		}
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		double value = 0;
		double total = 0;
		double result = 0;
		if(map!=null){
			if(map.get(name)!=null && !map.get(name).toString().trim().equals("")){
				value = Double.valueOf((String)map.get(name));
			}
			if(map.get("total")!=null && !map.get("total").toString().trim().equals("")){
				total = Double.valueOf((String)map.get("total"));
			}
			if(total!=0){
				result = value/total*100;
				if( result < middle ){
					lowerLimit = (int)result -1;
					if(lowerLimit<0){
						lowerLimit =0;
					}
					upperLimit = (int)middle + 1 ;
					if(upperLimit >100){
						upperLimit = 100;
					}
				}else if( result > middle ){
					lowerLimit = (int)middle -1;
					if(lowerLimit < 0){
						lowerLimit = 0;
					}
					upperLimit = (int)result + 1 ;
					if(upperLimit > 100){
						upperLimit = 100;
					}
				}
			}
		}
		String left ="FF654F";
		String right ="8BBA00"; 
		if(name!=null && !name.trim().equals("qualified") && !name.trim().equals("first")){
			left ="8BBA00";
			right ="FF654F";
		}
		sb = new StringBuffer();
		sb.append("<Chart autoScale ='1' origW='400' origH='300' bgColor='AEC0CA,FFFFFF' lowerLimit='").append((int)lowerLimit).append("' upperLimit='").append((int)upperLimit).append("' majorTMHeight='8' showGaugeBorder='1' rotateYAxisName='0' ")
		.append(" gaugeStartAngle='180' gaugeEndAngle='0' palette='1' numberSuffix='%25' tickValueDistance='20' showValue='1' adjustTM='0' majorTMNumber='11' minorTMNumber='0' yAxisNameWidth='16' chartLeftMargin='50' chartRightMargin ='50'")
		.append(" autoScale='1' baseFontSize ='12' decimals ='3'><colorRange><color minValue='").append((int)lowerLimit).append("' maxValue='").append(middle).append("' code='").append(left).append("' />")
		.append(" <color minValue='").append(middle).append("' maxValue='").append((int)upperLimit).append("' code='").append(right).append("'/></colorRange>")
		.append(" <dials><dial value='").append(result).append("' rearExtension='10'/>")
		.append(" </dials><styles><definition><style name='DialStyle' type='font' font='Verdana' size='42' color='CCCCCC' bold='1' /> </definition> ")
		.append(" <application><apply toObject='Value' styles=' DialStyle ' />  </application></styles></Chart>");
		String Str = sb.toString();
		//Str = java.net.URLEncoder.encode(Str,"UTF-8");
		msg.setValue("Str", Str);
		System.out.println(sb.toString());
		msg.setValue("total", total);
		msg.setValue("name", value);
		return msg;
	}
	/**
	 * 仪表盘  --> 柱状图 --> 项目过滤
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg wellChart(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null){
			project_info_no= "";
		}
		StringBuffer str = new StringBuffer();
		str.append("<chart caption='' yAxisMaxValue ='4' yAxisValuesStep ='1' numberPrefix='' baseFontSize ='12' rotateYAxisName='0' yAxisNameWidth='16'")
		.append(" seriesNameInToolTip='0' sNumberSuffix='' yAxisName='"+java.net.URLEncoder.encode("检查数量","UTF-8")+"' ")
		.append(" showValues='1' plotSpacePercent='0' maxColWidth ='50' xAxisName='' bgColor='AEC0CA,FFFFFF' adjustDiv ='1' numDivLines='3'>");
		StringBuffer sb = new StringBuffer();
		sb.append("select distinct t.record_name ,sum(nvl(t.record_num,0))record_num from bgp_qua_record_summary t")
		.append(" where t.bsflag='0' and t.object_name like'钻井%' ")
		.append(" and t.project_info_no='").append(project_info_no).append("'group by t.record_name");
		List list = pureJdbcDao.queryRecords(sb.toString());
		if(list==null || list.size()<=0){
			sb = new StringBuffer();
			sb.append("select t.coding_name record_name ,'0' record_num from comm_coding_sort_detail t where t.bsflag='0' and t.coding_sort_id='5000100103'");
			list = pureJdbcDao.queryRecords(sb.toString());
		}
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				if(map!=null){
					String record_name = (String)map.get("record_name");
					String record_num = (String)map.get("record_num");
					str.append(" <set label='").append(java.net.URLEncoder.encode(record_name,"UTF-8")).append("' value='").append(record_num).append("' />");
				}
			}
		}
		str.append(" <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' />")
		.append(" <style type='font' name='SubCaptionFont' bold='0' /></definition><application>")
		.append(" <apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles></chart>");
		String Str = str.toString();
		//Str = java.net.URLEncoder.encode(Str,"UTF-8");
		msg.setValue("Str", Str);
		return msg;
	}
	/**
	 * 仪表盘  --> 折线图  --> 项目过滤
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg lineChart(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null){
			project_info_no= "";
		}
		StringBuffer str = new StringBuffer();
		str.append("<chart caption='' yAxisMaxValue ='4' yAxisValuesStep ='1' numberPrefix='' baseFontSize ='12' rotateYAxisName='0' yAxisNameWidth='16'")
		.append(" seriesNameInToolTip='0' sNumberSuffix='' yAxisName='"+java.net.URLEncoder.encode("检查数量","UTF-8")+"' ")
		.append(" showValues='1' plotSpacePercent='0' maxColWidth ='50' xAxisName='' bgColor='AEC0CA,FFFFFF' adjustDiv ='1' numDivLines='3'>");
		StringBuffer sb = new StringBuffer();
		sb.append("select distinct t.record_name ,sum(nvl(t.record_num,0))record_num from bgp_qua_record_summary t")
		.append(" where t.bsflag='0' and (t.object_name like'放线%' or t.object_name like'放（收）线%') ")
		.append(" and t.project_info_no='").append(project_info_no).append("'group by t.record_name");
		List list = pureJdbcDao.queryRecords(sb.toString());
		if(list==null || list.size()<=0){
			sb = new StringBuffer();
			sb.append("select t.coding_name record_name ,'0' record_num from comm_coding_sort_detail t where t.bsflag='0' and t.coding_sort_id='5000100104'");
			list = pureJdbcDao.queryRecords(sb.toString());
		}
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				if(map!=null){
					String record_name = (String)map.get("record_name");
					String record_num = (String)map.get("record_num");
					str.append(" <set label='").append(java.net.URLEncoder.encode(record_name,"UTF-8")).append("' value='").append(record_num).append("' />");
				}
			}
		}
		str.append(" <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' />")
		.append(" <style type='font' name='SubCaptionFont' bold='0' /></definition><application>")
		.append(" <apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles></chart>");
		String Str = str.toString();
		//Str = java.net.URLEncoder.encode(Str,"UTF-8");
		msg.setValue("Str", Str);
		return msg;
	}
	/**
	 * 仪表盘  --> 柱状图  --> 项目过滤
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg shotChart(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null){
			project_info_no= "";
		}
		StringBuffer str = new StringBuffer();
		str.append("<chart caption='' yAxisMaxValue ='4' yAxisValuesStep ='1' numberPrefix='' baseFontSize ='12' rotateYAxisName='0' yAxisNameWidth='16'")
		.append(" seriesNameInToolTip='0' sNumberSuffix='' yAxisName='"+java.net.URLEncoder.encode("检查数量","UTF-8")+"' ")
		.append(" showValues='1' plotSpacePercent='0' maxColWidth ='50' xAxisName='' bgColor='AEC0CA,FFFFFF' adjustDiv ='1' numDivLines='3'>");
		StringBuffer sb = new StringBuffer();
		sb.append("select distinct t.record_name ,sum(nvl(t.record_num,0)) record_num from bgp_qua_record_summary t")
		.append(" where t.bsflag='0' and t.object_name like'测量%' ")  //单炮
		.append(" and t.project_info_no='").append(project_info_no).append("'group by t.record_name");
		List list = pureJdbcDao.queryRecords(sb.toString());
		if(list==null || list.size()<=0){
			sb = new StringBuffer();
			//sb.append("select t.coding_name record_name ,'0' record_num from comm_coding_sort_detail t where t.bsflag='0' and t.coding_sort_id='5000100100'");  //单炮
			sb.append("select t.coding_name record_name ,'0' record_num from comm_coding_sort_detail t where t.bsflag='0' and t.coding_sort_id='5000100101'");
			list = pureJdbcDao.queryRecords(sb.toString());
		}
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				if(map!=null){
					String record_name = (String)map.get("record_name");
					String record_num = (String)map.get("record_num");
					str.append(" <set label='").append(java.net.URLEncoder.encode(record_name,"UTF-8")).append("' value='").append(record_num).append("' />");
				}
			}
		}
		str.append(" <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' />")
		.append(" <style type='font' name='SubCaptionFont' bold='0' /></definition><application>")
		.append(" <apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles></chart>");
		String Str = str.toString();
		//Str = java.net.URLEncoder.encode(Str,"UTF-8");
		System.out.println(Str);
		msg.setValue("Str", Str);
		return msg;
	}
	
	/**
	 * 仪表盘  --> 仪表盘 --> 组织机构过滤
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg chartByOrg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String org_subjection_id = reqDTO.getValue("org_subjection_id");
		if(org_subjection_id ==null || org_subjection_id.trim().equals("")){
			org_subjection_id = user.getSubOrgIDofAffordOrg();
		}
		String wtc = reqDTO.getValue("wtc");
		String name = reqDTO.getValue("name");
		if(name==null){
			name = "";
		}
		double middle = Double.parseDouble(reqDTO.getValue("middle"));
		
		StringBuffer sb = new StringBuffer();
		//TODO
		//计算 组织机构 的总炮、合格炮、一级炮、废炮、空炮
		sb.append("select sum(nvl(t.daily_acquire_sp_num,0)-(-nvl(t.daily_jp_acquire_shot_num,0))-(-nvl(t.daily_qq_acquire_shot_num,0)))total ,sum(nvl(t.daily_acquire_firstlevel_num,0)) first , ")
		.append(" decode(sum(nvl(t.daily_acquire_qualified_num,0)),0,sum(nvl(t.daily_acquire_firstlevel_num,0))-(-sum(nvl(t.collect_2_class,0))),sum(nvl(t.daily_acquire_qualified_num,0))) qualified , ")
		.append(" sum(nvl(t.collect_waster_num,0)) waster ,sum(nvl(t.collect_miss_num,0)) miss from gp_ops_daily_report t")
		.append(" join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0' ")
		.append(" join gp_task_project_dynamic d on p.project_info_no = d.project_info_no")
		.append(" and p.exploration_method = d.exploration_method and d.bsflag='0' ")
		.append(" where t.bsflag='0' and t.audit_status ='3' and t.org_subjection_id like '").append(org_subjection_id).append("%'"); //and p.project_status='3' 正在施工
		if(name!=null && name.equals("first")){
			sb = new StringBuffer();
			sb.append("select sum(nvl(t.daily_acquire_firstlevel_num,0)-(-nvl(t.collect_2_class,0))-(-nvl(t.collect_waster_num,0))-(-nvl(t.collect_miss_num,0)))total ,sum(nvl(t.daily_acquire_firstlevel_num,0)) first ,")
			.append(" decode(sum(nvl(t.daily_acquire_qualified_num,0)),0,sum(nvl(t.daily_acquire_firstlevel_num,0))-(-sum(nvl(t.collect_2_class,0))),sum(nvl(t.daily_acquire_qualified_num,0))) qualified , ")
			.append(" sum(nvl(t.collect_waster_num,0)) waster ,sum(nvl(t.collect_miss_num,0)) miss from gp_ops_daily_report t")
			.append(" join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0' ")
			.append(" join gp_task_project_dynamic d on p.project_info_no = d.project_info_no")
			.append(" and p.exploration_method = d.exploration_method and d.bsflag='0' ")
			.append(" where t.bsflag='0' and t.audit_status ='3' and t.org_subjection_id like '").append(org_subjection_id).append("%'"); //and p.project_status='3' 正在施工
		}
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		double value = 0;
		double total = 0;
		double result = 0;
		double upperLimit = 100;
		double lowerLimit = 0;
		if(name !=null && name.trim().equals("qualified") ){
			upperLimit = 100;
			lowerLimit = 99;
		}else if(name !=null && name.trim().equals("first")){
			upperLimit = 100;
			lowerLimit = 60;
		}else{
			upperLimit = 3;
			lowerLimit = 0;
		}
		if(map!=null){
			if(map.get(name)!=null && !map.get(name).toString().trim().equals("")){
				value = Double.valueOf((String)map.get(name));
			}
			if(map.get("total")!=null && !map.get("total").toString().trim().equals("")){
				total = Double.valueOf((String)map.get("total"));
			}
			if(total!=0){
				result = value/total*100;
				if( result < middle ){
					lowerLimit = (int)result;
					if(lowerLimit<0){
						lowerLimit =0;
					}
					upperLimit = (int)middle + 1 ;
					if(upperLimit >100){
						upperLimit = 100;
					}
				}else if( result > middle ){
					lowerLimit = (int)middle;
					if(lowerLimit < 0){
						lowerLimit = 0;
					}
					upperLimit = (int)result + 1 ;
					if(upperLimit > 100){
						upperLimit = 100;
					}
				}
			}
		}
		String left ="FF654F";
		String right ="8BBA00";
		if(name!=null && !name.trim().equals("qualified") && !name.trim().equals("first")){
			left ="8BBA00";
			right ="FF654F";
		}
		sb = new StringBuffer();
		sb.append("<Chart bgColor='AEC0CA,FFFFFF' lowerLimit='").append(lowerLimit).append("' upperLimit='").append(upperLimit).append("' baseFontSize ='12'")//tickValueDistance='30'
		.append(" gaugeStartAngle='180' gaugeEndAngle='0' numberSuffix='%25' showValue='1' adjustTM='0' majorTMNumber='11' minorTMNumber='0' chartLeftMargin='50' chartRightMargin ='50' ") //
		.append(" showShadow= '1' rotateYAxisName='0' yAxisNameWidth='16' palette='2' chartBottomMargin='45' autoScale ='1' origW='400' origH='300' decimals ='3'");//autoScale ='1' origW='100' origH='100'
		if(name!=null && name.trim().equals("qualified")){
			if(wtc==null || wtc.trim().equals("")){
				sb.append(" clickURL='JavaScript:orgDetail(1)'>");
			}else {
				sb.append(" clickURL='JavaScript:wtcDetail(1)'>");
			}
		}else{
			if(wtc==null || wtc.trim().equals("")){
				sb.append(" clickURL='JavaScript:orgDetail(2)'>");
			}else {
				sb.append(" clickURL='JavaScript:wtcDetail(2)'>");
			}
		}
		sb.append(" <colorRange><color minValue='").append((int)lowerLimit).append("' maxValue='").append(middle).append("' code='").append(left).append("'/>")
		.append(" <color minValue='").append(middle).append("' maxValue='").append((int)upperLimit).append("' code='").append(right).append("'/></colorRange>")
		.append(" <dials><dial value='").append(String.valueOf(result)).append("' rearExtension='10' />")  
		.append(" </dials> <styles><definition><style name='DialStyle' type='font' font='Verdana' size='42' color='CCCCCC' bold='1' /> </definition> ")
		.append(" <application><apply toObject='Value' styles=' DialStyle ' />  </application></styles></Chart> ");
		String Str = sb.toString();
		//Str = java.net.URLEncoder.encode(Str,"UTF-8");
		msg.setValue("Str", Str);
		System.out.println("chartByOrg="+sb.toString());
		msg.setValue("total", total);
		msg.setValue("name", value);
		return msg;
	}
	/**
	 * 仪表盘  --> 柱状图 （合格品） --> 组织机构过滤
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg wellChartByOrg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer();
		//TODO
		// 各物探处 合格品
		sb.append(" select tt.*,round((case when tt.total is null then 0 else tt.qualified/tt.total*100 end),2) qualified_percent ")
		.append(" from(select t.org_short_name eps_name ,t.org_abbreviation org_name ,t.org_id ,r.* ,t.order_num from bgp_comm_org_wtc t  ")
		.append(" left join(select sub.org_subjection_id ,sum(nvl(rr.daily_acquire_firstlevel_num,0))first ,sum(nvl(rr.collect_waster_num,0)) waster ,sum(nvl(rr.collect_miss_num,0)) miss , ")
		.append(" decode(sum(nvl(rr.daily_acquire_qualified_num,0)),0,sum(nvl(rr.daily_acquire_firstlevel_num,0))-(-sum(nvl(rr.collect_2_class,0))),sum(nvl(rr.daily_acquire_qualified_num,0))) qualified , ")
		.append(" sum(nvl(rr.daily_acquire_sp_num,0)-(-nvl(rr.daily_jp_acquire_shot_num,0))-(-nvl(rr.daily_qq_acquire_shot_num,0)))total  ")
		.append(" from gp_ops_daily_report rr join gp_task_project p on rr.project_info_no = p.project_info_no and p.bsflag='0'  ")
		.append(" join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and p.exploration_method = d.exploration_method and d.bsflag='0' ")
		.append(" join bgp_comm_org_wtc sub on rr.org_subjection_id like concat(sub.org_subjection_id,'%') and sub.bsflag ='0' ")
		.append(" where rr.bsflag='0' and rr.audit_status ='3' group  by sub.org_subjection_id )r on t.org_subjection_id = r.org_subjection_id where t.bsflag='0')tt order by tt.order_num ");
		List list = pureJdbcDao.queryRecords(sb.toString());
		if(list==null || list.size()<=0){
			sb = new StringBuffer();
			sb.append("select t.org_short_name eps_name ,t.org_id , sub.org_subjection_id ,'0' qualified_percent ,t.org_abbreviation org_name ")
			.append(" from bgp_comm_org_wtc t join comm_org_subjection sub on t.org_id = sub.org_id and sub.bsflag='0' ")
			.append(" where t.bsflag='0' order by t.order_num");
			list = pureJdbcDao.queryRecords(sb.toString());
		}
		StringBuffer str = new StringBuffer();
		str.append("<chart caption='' palette='10' animation='1' formatNumberScale='10' numberPrefix='' yAxisMinValue='99' yAxisMaxValue='100' baseFontSize ='12' rotateYAxisName='0' yAxisNameWidth='16'")
		.append(" slantLabels='0' seriesNameInToolTip='0' sNumberSuffix='1' yAxisName='"+java.net.URLEncoder.encode("合格品率","UTF-8")+"' numberSuffix='"+java.net.URLEncoder.encode("%25","UTF-8")+"' useRoundEdges='1' ")
		.append(" showValues='1' plotSpacePercent='"+java.net.URLEncoder.encode("10%","UTF-8")+"'  xAxisName='' bgColor='AEC0CA,FFFFFF' showBorder='0' adjustDiv='0' numDivLines='9'>");
		
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				if(map!=null){
					String org_subjection_id = (String)map.get("org_subjection_id");
					String eps_name = (String)map.get("eps_name");
					String org_name = (String)map.get("org_name");
					String qualified = (String)map.get("qualified_percent");
					if(qualified!=null && qualified.trim().equals("0") ){
						qualified = "";
					}
					str.append(" <set label='").append(java.net.URLEncoder.encode(eps_name, "UTF-8")).append("' value='").append(qualified).append("' link=\"JavaScript:projectQualified('").append(org_subjection_id).append("','").append(java.net.URLEncoder.encode(java.net.URLEncoder.encode(org_name, "GBK"), "UTF-8")).append("')\" />");
				}
			}
		}
		str.append(" <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' />")
		.append(" <style type='font' name='SubCaptionFont' bold='0' /></definition><application>")
		.append(" <apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles>")
		.append(" <trendlines ><line startValue='99.6' displayValue='"+java.net.URLEncoder.encode("99.6%","UTF-8")+"' color='666666' valueOnRight='1' thickness ='2' dashed='1' showOnTop ='1' dashLen ='8' dashGap ='5'/></trendlines>")
		.append("</chart>");
		String Str = str.toString();
		//Str = java.net.URLEncoder.encode(Str,"UTF-8");
		msg.setValue("Str", Str);
		System.out.println(Str);
		return msg;
	}
	/**
	 * 仪表盘  --> 柱状图 （一级品）--> 组织机构过滤
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg firstChartByOrg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer();
		//TODO
		// 各物探处 一级炮
		sb.append(" select tt.*,round((case when tt.total is null then 0 else tt.first/tt.total*100 end),2) first_percent ")
		.append(" from(select t.org_short_name eps_name ,t.org_abbreviation org_name ,t.org_id ,r.* ,t.order_num from bgp_comm_org_wtc t  ")
		.append(" left join(select sub.org_subjection_id ,sum(nvl(rr.daily_acquire_firstlevel_num,0))first ,sum(nvl(rr.collect_waster_num,0)) waster ,sum(nvl(rr.collect_miss_num,0)) miss , ")
		.append(" decode(sum(nvl(rr.daily_acquire_qualified_num,0)),0,sum(nvl(rr.daily_acquire_firstlevel_num,0))-(-sum(nvl(rr.collect_2_class,0))),sum(nvl(rr.daily_acquire_qualified_num,0))) qualified , ")
		.append(" sum(nvl(rr.daily_acquire_qualified_num,0)-(-nvl(rr.collect_2_class,0))-(-nvl(rr.collect_waster_num,0))-(-nvl(rr.collect_miss_num,0)))total  ")
		.append(" from gp_ops_daily_report rr join gp_task_project p on rr.project_info_no = p.project_info_no and p.bsflag='0'  ")
		.append(" join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and p.exploration_method = d.exploration_method and d.bsflag='0' ")
		.append(" join bgp_comm_org_wtc sub on rr.org_subjection_id like concat(sub.org_subjection_id,'%') and sub.bsflag ='0' ")
		.append(" where rr.bsflag='0' and rr.audit_status ='3' group  by sub.org_subjection_id )r on t.org_subjection_id = r.org_subjection_id where t.bsflag='0')tt order by tt.order_num ");
		List list = pureJdbcDao.queryRecords(sb.toString());
		if(list==null || list.size()<=0){
			sb = new StringBuffer();
			sb.append("select t.org_short_name eps_name ,t.org_id , sub.org_subjection_id ,'0' first_percent ,t.org_abbreviation org_name ")
			.append("  from bgp_comm_org_wtc t join comm_org_subjection sub on t.org_id = sub.org_id and sub.bsflag='0' ")
			.append(" where t.bsflag='0' order by t.order_num");
			list = pureJdbcDao.queryRecords(sb.toString());
		}
		StringBuffer str = new StringBuffer();
		str.append("<chart palette='1' animation='1' formatNumberScale='0' numberPrefix='' yAxisMaxValue='100' baseFontSize ='12' rotateYAxisName='0' yAxisNameWidth='16'")
		.append(" slantLabels='1' seriesNameInToolTip='1' sNumberSuffix='' yAxisName='"+java.net.URLEncoder.encode("一级品率","UTF-8")+"' numberSuffix='"+java.net.URLEncoder.encode("%25","UTF-8")+"' useRoundEdges='1' ")
		.append(" showValues='1' plotSpacePercent='"+java.net.URLEncoder.encode("10%","UTF-8")+"' xAxisName='' bgColor='AEC0CA,FFFFFF' yAxisNamePadding ='0' adjustDiv='0' numDivLines='9'>");
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				if(map!=null){
					String org_subjection_id = (String)map.get("org_subjection_id");
					String eps_name = (String)map.get("eps_name");
					String org_name = (String)map.get("org_name");
					String qualified = (String)map.get("first_percent");
					if(qualified!=null && qualified.trim().equals("0") ){
						qualified = "";
					}
					str.append(" <set label='").append(java.net.URLEncoder.encode(eps_name, "UTF-8")).append("' value='").append(qualified).append("' link=\"JavaScript:projectFirst('").append(org_subjection_id).append("','").append(java.net.URLEncoder.encode(java.net.URLEncoder.encode(eps_name, "GBK"), "UTF-8")).append("')\" />");
				}
			}
		}
		str.append(" <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' />")
		.append(" <style type='font' name='SubCaptionFont' bold='0' /></definition><application>")
		.append(" <apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles>")
		.append(" <trendlines ><line startValue='80' displayValue='"+java.net.URLEncoder.encode("80%","UTF-8")+"' color='666666' valueOnRight='1' thickness ='2' dashed='1' showOnTop ='1' dashLen ='8' dashGap ='5'/></trendlines>")
		.append("</chart>");
		String Str = str.toString();
		msg.setValue("Str", Str);
		log.info(Str);
		return msg;
	}
	/**
	 * 仪表盘  --> 柱状图 --> 综合物化探 单项目仪表盘
	 * @author xiaqiuyu
	 * @date 2013-10-13
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg zhwhtChart(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_type = user.getProjectType();
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null){
			project_info_no= "";
		}
		String coding_code_id = reqDTO.getValue("coding_code_id");
		if(coding_code_id==null){
			coding_code_id= "";
		}
		StringBuffer str = new StringBuffer();
		str.append("<chart caption='' yAxisMaxValue ='4' yAxisValuesStep ='1' numberPrefix='' baseFontSize ='12' rotateYAxisName='0' yAxisNameWidth='16'")
		.append(" seriesNameInToolTip='0' sNumberSuffix='' yAxisName='"+java.net.URLEncoder.encode("检查数量","UTF-8")+"' ")
		.append(" showValues='1' plotSpacePercent='0' maxColWidth ='50' xAxisName='' bgColor='AEC0CA,FFFFFF' adjustDiv ='1' numDivLines='3'>");
		StringBuffer sb = new StringBuffer();
		sb.append("select distinct t.record_name ,sum(nvl(t.record_num,0))record_num from bgp_qua_record_summary t where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' and t.task_id =(")
		.append(" select id from bgp_p6_activity pa where pa.bsflag ='0' and pa.object_id =(select dp.activity_object_id from gp_ops_daily_report_zb dp ")
		.append(" where dp.bsflag ='0' and dp.project_info_no ='"+project_info_no+"' and dp.exploration_method ='").append(coding_code_id).append("' and rownum =1)) group by t.record_name");
		
		List list = pureJdbcDao.queryRecords(sb.toString());
		if(list==null || list.size()<=0){
			if(project_type!=null && project_type.trim().equals("5000100004000000009")){//综合物化探的业务
				sb = new StringBuffer();
				
				/*读取项目质量检查计划保存的质量检查项*/
				sb.append("select s.detail_name record_name ,'0' record_num from bgp_qua_coding_sort s where s.bsflag ='0' and s.sort_id like '50001001%' ")
				.append(" and s.project_info_no='"+project_info_no+"' and s.sort_name like '%'||( ")
				.append(" select sd.coding_name from comm_coding_sort_detail sd where sd.bsflag ='0' and sd.coding_code_id=( ")
				.append(" select decode(d.superior_code_id,'0',d.coding_code_id,d.superior_code_id) from comm_coding_sort_detail d  ")
				.append(" where d.bsflag ='0' and d.coding_sort_id ='5110000056' and d.coding_code_id ='"+coding_code_id+"'))||'%' ");
				list = pureJdbcDao.queryRecords(sb.toString());
				if(list==null || list.size()<=0){//读取项目质量检查计划保持的质量检查项,为空，读取设置中的质量检查项
					sb = new StringBuffer();
					sb.append("select d.coding_name record_name ,'0' record_num from comm_coding_sort s  ")
					.append(" left join comm_coding_sort_detail d on s.coding_sort_id = d.coding_sort_id and d.bsflag ='0' ")
					.append(" where s.bsflag ='0' and s.spare2='5000100004000000009' and s.coding_sort_name like '%'||( ")
					.append(" select sd.coding_name from comm_coding_sort_detail sd where sd.bsflag ='0' and sd.coding_code_id=( ")
					.append(" select decode(d.superior_code_id,'0',d.coding_code_id,d.superior_code_id) from comm_coding_sort_detail d  ")
					.append(" where d.bsflag ='0' and d.coding_sort_id ='5110000056' and d.coding_code_id ='"+coding_code_id+"'))||'%' ");
					list = pureJdbcDao.queryRecords(sb.toString());
				}
			}else{//不会执行到这
				sb = new StringBuffer();
				sb.append("select t.coding_name record_name ,'0' record_num from comm_coding_sort_detail t where t.bsflag='0' and t.coding_sort_id='"+coding_code_id+"'");
				list = pureJdbcDao.queryRecords(sb.toString());
			}
		}
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				if(map!=null){
					String record_name = (String)map.get("record_name");
					String record_num = (String)map.get("record_num");
					str.append(" <set label='").append(java.net.URLEncoder.encode(record_name,"UTF-8")).append("' value='").append(record_num).append("' />");
				}
			}
		}
		str.append(" <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' />")
		.append(" <style type='font' name='SubCaptionFont' bold='0' /></definition><application>")
		.append(" <apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles></chart>");
		String Str = str.toString();
		//Str = java.net.URLEncoder.encode(Str,"UTF-8");
		msg.setValue("Str", Str);
		return msg;
	}
	/**
	 * 仪表盘  --> 柱状图 --> 井中 单项目仪表盘
	 * @author xiaqiuyu
	 * @date 2013-10-13
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg jzChart(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_type = user.getProjectType();
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null){
			project_info_no= "";
		}
		String object_name = reqDTO.getValue("object_name");
		if(object_name==null){
			object_name= "null";
		}
		object_name = java.net.URLDecoder.decode(object_name,"UTF-8");
		String coding_sort_id = reqDTO.getValue("coding_sort_id");
		if(coding_sort_id==null){
			coding_sort_id= "";
		}
		StringBuffer str = new StringBuffer();
		str.append("<chart caption='' yAxisMaxValue ='4' yAxisValuesStep ='1' numberPrefix='' baseFontSize ='12' rotateYAxisName='0' yAxisNameWidth='16'")
		.append(" seriesNameInToolTip='0' sNumberSuffix='' yAxisName='"+java.net.URLEncoder.encode("检查数量","UTF-8")+"' ")
		.append(" showValues='1' plotSpacePercent='0' maxColWidth ='50' xAxisName='' bgColor='AEC0CA,FFFFFF' adjustDiv ='1' numDivLines='3'>");
		StringBuffer sb = new StringBuffer();
		if(object_name!=null && object_name.indexOf("放线")!=-1){
			sb.append("select distinct t.record_name ,sum(nvl(t.record_num,0))record_num from bgp_qua_record_summary t")
			.append(" where t.bsflag='0' and (t.object_name like'放线%' or t.object_name like'放（收）线%') ")
			.append(" and t.project_info_no='").append(project_info_no).append("'group by t.record_name");
		}else{
			sb.append("select distinct t.record_name ,sum(nvl(t.record_num,0))record_num from bgp_qua_record_summary t")
			.append(" where t.bsflag='0' and t.object_name like'"+object_name+"%' ")
			.append(" and t.project_info_no='").append(project_info_no).append("'group by t.record_name");
		}
		
		List list = pureJdbcDao.queryRecords(sb.toString());
		if(list==null || list.size()<=0){
			sb = new StringBuffer();
			sb.append("select t.coding_name record_name ,'0' record_num from comm_coding_sort_detail t where t.bsflag='0' and t.coding_sort_id='"+coding_sort_id+"'");
			list = pureJdbcDao.queryRecords(sb.toString());
		}
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				if(map!=null){
					String record_name = (String)map.get("record_name");
					String record_num = (String)map.get("record_num");
					str.append(" <set label='").append(java.net.URLEncoder.encode(record_name,"UTF-8")).append("' value='").append(record_num).append("' />");
				}
			}
		}
		str.append(" <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' />")
		.append(" <style type='font' name='SubCaptionFont' bold='0' /></definition><application>")
		.append(" <apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles></chart>");
		String Str = str.toString();
		//Str = java.net.URLEncoder.encode(Str,"UTF-8");
		log.info(Str);
		msg.setValue("Str", Str);
		return msg;
	}
	/**
	 * 仪表盘  --> 柱状图 --> 滩浅海 单项目仪表盘
	 * @author xiaqiuyu
	 * @date 2013-10-13
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg tqhChart(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_type = user.getProjectType();
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null){
			project_info_no= "";
		}
		String object_name = reqDTO.getValue("object_name");
		if(object_name==null){
			object_name= "null";
		}
		object_name = java.net.URLDecoder.decode(object_name,"UTF-8");
		String coding_sort_id = reqDTO.getValue("coding_sort_id");
		if(coding_sort_id==null){
			coding_sort_id= "";
		}
		StringBuffer str = new StringBuffer();
		str.append("<chart caption='' yAxisMaxValue ='4' yAxisValuesStep ='1' numberPrefix='' baseFontSize ='12' rotateYAxisName='0' yAxisNameWidth='16'")
		.append(" seriesNameInToolTip='0' sNumberSuffix='' yAxisName='"+java.net.URLEncoder.encode("检查数量","UTF-8")+"' ")
		.append(" showValues='1' plotSpacePercent='0' maxColWidth ='50' xAxisName='' bgColor='AEC0CA,FFFFFF' adjustDiv ='1' numDivLines='3'>");
		StringBuffer sb = new StringBuffer();
		if(object_name!=null && object_name.indexOf("放线")!=-1){
			sb.append("select distinct t.record_name ,sum(nvl(t.record_num,0))record_num from bgp_qua_record_summary t")
			.append(" where t.bsflag='0' and (t.object_name like'放线%' or t.object_name like'放（收）线%') ")
			.append(" and t.project_info_no='").append(project_info_no).append("'group by t.record_name");
		}else{
			sb.append("select distinct t.record_name ,sum(nvl(t.record_num,0))record_num from bgp_qua_record_summary t")
			.append(" where t.bsflag='0' and t.object_name like'"+object_name+"%' ")
			.append(" and t.project_info_no='").append(project_info_no).append("'group by t.record_name");
		}
		
		List list = pureJdbcDao.queryRecords(sb.toString());
		if(list==null || list.size()<=0){
			sb = new StringBuffer();
			sb.append("select t.coding_name record_name ,'0' record_num from comm_coding_sort_detail t where t.bsflag='0' and t.coding_sort_id='"+coding_sort_id+"'");
			list = pureJdbcDao.queryRecords(sb.toString());
		}
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				if(map!=null){
					String record_name = (String)map.get("record_name");
					String record_num = (String)map.get("record_num");
					str.append(" <set label='").append(java.net.URLEncoder.encode(record_name,"UTF-8")).append("' value='").append(record_num).append("' />");
				}
			}
		}
		str.append(" <styles><definition><style type='font' name='CaptionFont' size='15' color='666666' />")
		.append(" <style type='font' name='SubCaptionFont' bold='0' /></definition><application>")
		.append(" <apply toObject='caption' styles='CaptionFont' /><apply toObject='SubCaption' styles='SubCaptionFont' /></application></styles></chart>");
		String Str = str.toString();
		//Str = java.net.URLEncoder.encode(Str,"UTF-8");
		log.info(Str);
		msg.setValue("Str", Str);
		return msg;
	}
	/**
	 * 仪表盘 --> 项目过滤 -->综合物化探单项目
	 * @author xiaqiuyu
	 * @date 2013-11-26
	 */
	public ISrvMsg whtChart(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null){
			project_info_no= "";
		}
		String type = reqDTO.getValue("type");
		if(type==null){
			type = "";
		}
		String coding_code_id = reqDTO.getValue("coding_code_id");
		if(coding_code_id==null){
			coding_code_id = "";
		}
		StringBuffer sb = new StringBuffer();
		//合格品指标、一级品指标
		sb.append(" select t.qualified_radio qualified ,t.firstlevel_radio first ,t.waster_radio waster ,t.miss_radio miss from bgp_pm_quality_index t ")
		.append(" where t.bsflag='0' and t.project_info_no ='").append(project_info_no).append("' and t.exploration_method='").append(project_info_no).append("'");
		List list = pureJdbcDao.queryRecords(sb.toString());
		double middle = 100 ;
		double upperLimit = 100;
		double lowerLimit = 0;
		if(type !=null && type.trim().equals("qualified") ){
			upperLimit = 100;
			lowerLimit = 99;
		}else if(type !=null && type.trim().equals("first")){
			upperLimit = 100;
			lowerLimit = 60;
		}else{
			upperLimit = 3;
			lowerLimit = 0;
		}
		if(list!=null && list.size()>0){
			Map temp = (Map)list.get(0);
			if(temp!=null){
				if(temp.get(type)!=null && !temp.get(type).toString().trim().equals("")){
					middle = Double.valueOf((String)temp.get(type));
				}
			}
		}
		Map map = new HashMap();
		if(type!=null && type.equals("qualified")){
			sb = new StringBuffer();
			//合格品率 = 累计合格品/累计坐标点
			sb.append(" with daily_report as(select * from gp_ops_daily_report_wt t join gp_ops_daily_report_zb zb on t.daily_no_wt = zb.daily_no_wt and zb.bsflag ='0'")
			.append(" where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' and zb.exploration_method ='"+coding_code_id+"' ")//and t.audit_status ='3'
			.append(" order by zb.produce_date desc)select nvl(sum(dr.daily_conforming_products),0) qualified,")
			.append(" nvl(sum(dr.daily_coordinate_point),0) total from daily_report dr");
			map = pureJdbcDao.queryRecordBySQL(sb.toString());
		}else if(type!=null && type.equals("first")){
			sb = new StringBuffer();
			//一级品率 区分工序
			sb.append("select decode(d.superior_code_id,'0',d.coding_code_id,d.superior_code_id) coding_code_id from comm_coding_sort_detail d ")
			.append(" where d.bsflag ='0' and d.coding_sort_id ='5110000056' and d.coding_code_id ='"+coding_code_id+"'");
			map = pureJdbcDao.queryRecordBySQL(sb.toString());
			String code_id = map==null || map.get("coding_code_id")==null ?"":(String)map.get("coding_code_id");
			if(code_id!=null &&(code_id.trim().equals("5110000056000000001") || code_id.trim().equals("5110000056000000002")|| code_id.trim().equals("5110000056000000005"))){//重力、磁力、化学勘探     	一级品率 = 累计一级品/累计检查点
				sb = new StringBuffer();
				sb.append(" with daily_report as(select * from gp_ops_daily_report_wt t join gp_ops_daily_report_zb zb on t.daily_no_wt = zb.daily_no_wt and zb.bsflag ='0'")
				.append(" where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' and zb.exploration_method ='"+coding_code_id+"' ")//and t.audit_status ='3'
				.append(" order by zb.produce_date desc)select nvl(sum(dr.daily_first_grade),0) first,nvl(sum(dr.daily_check_point),0) total from daily_report dr");
				map = pureJdbcDao.queryRecordBySQL(sb.toString());
			}else if(code_id!=null &&(code_id.trim().equals("5110000056000000003") || code_id.trim().equals("5110000056000000004"))){// 人工场源  、天然场源   	一级品率 = 累计一级品/累计坐标点
				sb = new StringBuffer();
				sb.append(" with daily_report as(select * from gp_ops_daily_report_wt t join gp_ops_daily_report_zb zb on t.daily_no_wt = zb.daily_no_wt and zb.bsflag ='0'")
				.append(" where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' and zb.exploration_method ='"+coding_code_id+"' ")//and t.audit_status ='3'
				.append(" order by zb.produce_date desc)select nvl(sum(dr.daily_first_grade),0) first,nvl(sum(dr.daily_coordinate_point),0) total from daily_report dr");
				map = pureJdbcDao.queryRecordBySQL(sb.toString());
			}else if(code_id!=null && code_id.trim().equals("5110000056000000006")){//工程     	一级品率 = 最新日报录入
				sb = new StringBuffer();
				sb.append(" with daily_report as(select * from gp_ops_daily_report_wt t join gp_ops_daily_report_zb zb on t.daily_no_wt = zb.daily_no_wt and zb.bsflag ='0'")
				.append(" where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' and zb.exploration_method ='"+coding_code_id+"' ")//and t.audit_status ='3'
				.append(" order by zb.produce_date desc)select '100' total,")
				.append(" nvl(max((select r.daily_first_ratio from daily_report r where r.daily_first_ratio is not null and rownum =1)),0) first from daily_report dr");
				map = pureJdbcDao.queryRecordBySQL(sb.toString());
			}
		}
		sb = new StringBuffer();
		
		double value = 0;
		double total = 0;
		double result = 0;
		if(map!=null){
			if(map.get(type)!=null && !map.get(type).toString().trim().equals("")){
				value = Double.valueOf((String)map.get(type));
			}
			if(map.get("total")!=null && !map.get("total").toString().trim().equals("")){
				total = Double.valueOf((String)map.get("total"));
			}
			if(total!=0){
				result = value/total*100;
				if( result < middle ){
					lowerLimit = (int)result -1;
					if(lowerLimit<0){
						lowerLimit =0;
					}
					upperLimit = (int)middle + 1 ;
					if(upperLimit >100){
						upperLimit = 100;
					}
				}else if( result > middle ){
					lowerLimit = (int)middle -1;
					if(lowerLimit < 0){
						lowerLimit = 0;
					}
					upperLimit = (int)result + 1 ;
					if(upperLimit > 100){
						upperLimit = 100;
					}
				}
			}
		}
		String left ="FF654F";
		String right ="8BBA00"; 
		if(type!=null && !type.trim().equals("qualified") && !type.trim().equals("first")){
			left ="8BBA00";
			right ="FF654F";
		}
		sb = new StringBuffer();
		sb.append("<Chart autoScale ='1' origW='400' origH='300' bgColor='AEC0CA,FFFFFF' lowerLimit='").append((int)lowerLimit).append("' upperLimit='").append((int)upperLimit).append("' majorTMHeight='8' showGaugeBorder='1' rotateYAxisName='0' ")
		.append(" gaugeStartAngle='180' gaugeEndAngle='0' palette='1' numberSuffix='%25' tickValueDistance='20' showValue='1' adjustTM='0' majorTMNumber='11' minorTMNumber='0' yAxisNameWidth='16' chartLeftMargin='50' chartRightMargin ='50'")
		.append(" autoScale='1' baseFontSize ='12' decimals ='3'><colorRange><color minValue='").append((int)lowerLimit).append("' maxValue='").append(middle).append("' code='").append(left).append("' />")
		.append(" <color minValue='").append(middle).append("' maxValue='").append((int)upperLimit).append("' code='").append(right).append("'/></colorRange>")
		.append(" <dials><dial value='").append(result).append("' rearExtension='10'/>")
		.append(" </dials><styles><definition><style name='DialStyle' type='font' font='Verdana' size='42' color='CCCCCC' bold='1' /> </definition> ")
		.append(" <application><apply toObject='Value' styles=' DialStyle ' />  </application></styles></Chart>");
		msg.setValue("Str", sb.toString());
		log.info(sb.toString());
		return msg;
	}
}