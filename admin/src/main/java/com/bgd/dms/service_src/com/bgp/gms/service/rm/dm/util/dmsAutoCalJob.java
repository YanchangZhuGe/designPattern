package com.bgp.gms.service.rm.dm.util;

import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.MapUtils;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.quartz.QuartzJobBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.util.DateUtil;


/**
 * DMS系统定时器
 * @author Administrator
 *
 */
public class dmsAutoCalJob extends QuartzJobBean {
	
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	@SuppressWarnings("unchecked")
	@Override
	protected void executeInternal(JobExecutionContext arg0)
			throws JobExecutionException {
		System.out.println("===============================>>");
		//自动写入新的保养计划
		saveOrUpdatePlanInfo();
		}
	
	
	/**
	 * 自动写入新的保养计划
	 * 
	 */
	public void saveOrUpdatePlanInfo() {
		StringBuffer querySql = new StringBuffer();
		String nowdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd");
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		querySql.append("select mp.fk_dev_acc_id,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,"
				+ " pla.plan_date - sysdate date1,pla.plan_date"
				+ " from gms_device_maintenance_plan mp"
				+ " left join (select mp.fk_dev_acc_id, min(mp.plan_date) plan_date"
				+ " from gms_device_maintenance_plan mp"
				+ " left join gms_device_account acc on mp.fk_dev_acc_id =acc.dev_acc_id"
				+ " where acc.bsflag = '0' and mp.plan_date - sysdate < 1 and mp.plan_date - sysdate > -1 "
				+ " group by mp.fk_dev_acc_id) pla on pla.fk_dev_acc_id = mp.fk_dev_acc_id"
				+ " left join gms_device_account acc on mp.fk_dev_acc_id = acc.dev_acc_id"
				+ " left join dms_device_keeping t on t.dev_id = mp.fk_dev_acc_id where acc.bsflag = '0'"
				+ " and acc.project_info_no is null and mp.fk_dev_acc_id is not null"
				+ " and pla.plan_date is not null and t.bsflag = '0'"
				+ " and exists (select 1 from (select b.dev_id,max(b.keeping_date) as keeping_date,max(b.create_date) as create_date"   
				+ " from dms_device_keeping b group by b.dev_id "
				+ " ) x where x.create_date = t.create_date and x.dev_id = t.dev_id)"
				+ " and t.thing_type = 1 and pla.plan_date - sysdate < 1 " //pla.plan_date = to_date('"+nowdate+"','yyyy-MM-dd')"
				+ " group by mp.fk_dev_acc_id, acc.dev_name, acc.dev_model, acc.self_num, acc.license_num, acc.dev_sign, pla.plan_date ");
		Map mixMap = jdbcDao.queryRecordBySQL(querySql.toString());
		if (MapUtils.isNotEmpty(mixMap)) {
			String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
			String dev_id = mixMap.get("fk_dev_acc_id").toString();
			String plan_date = "add_months(to_date('"+nowdate+"','yyyy-MM-dd'),3)";
			String date = "to_date('"+currentdate+"','yyyy-MM-dd HH24:mi:ss')";
			String addsql = "INSERT INTO gms_device_maintenance_plan (maintenance_id, fk_dev_acc_id, plan_date, create_date) "
					+ "VALUES ('"+iuuid+"','"+dev_id+"',"+plan_date+","+date+")";
			System.out.println(addsql);
			jdbcDao.executeUpdate(addsql);
		}
	}

}
