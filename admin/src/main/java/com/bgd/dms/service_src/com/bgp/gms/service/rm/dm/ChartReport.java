package com.bgp.gms.service.rm.dm;

import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class ChartReport implements IChartReport {
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	@Override
	public List createDynamicReportChart() {
		// TODO Auto-generated method stub
		StringBuffer buffer = new StringBuffer();
		buffer.append("select in_count,ok_count,all_count,");
		buffer.append("(all_count-ok_count-in_count) as other_count,");
		buffer.append("case when APPLY_NUM-in_count<0 or APPLY_NUM is null then 0 ");
		buffer.append("  else APPLY_NUM-in_count end as APPLY_NUM,");
		buffer.append("  'ÔËÔØÉè±¸' as title");
		buffer.append(" from ");
		buffer.append("(");
		buffer.append("select ");
		buffer.append("(");
		buffer.append("select count(*) as in_count ");
		buffer.append("from gms_device_account acc ");
		buffer.append("where acc.bsflag = '0'");
		buffer.append("and acc.ifproduction = '5110000186000000001' ");
		buffer.append("and (acc.owning_sub_id like 'C105008042%' or ");
		buffer.append("acc.owning_sub_id like 'C105008013%') ");
		buffer.append("and acc.license_num is not null ");
		buffer.append("and acc.using_stat = '0110000007000000001' ");
		buffer.append(") as in_count,( ");
		buffer.append("select count(*) ok_count ");
		buffer.append("from gms_device_account acc ");
		buffer.append(" where acc.bsflag = '0' ");
		buffer.append("and acc.ifproduction = '5110000186000000001' ");
		buffer.append("and (acc.owning_sub_id like 'C105008042%' or ");
		buffer.append("acc.owning_sub_id like 'C105008013%') ");
		buffer.append("and acc.license_num is not null ");
		buffer.append("and acc.using_stat = '0110000007000000002' ");
		buffer.append("and acc.tech_stat = '0110000006000000001' ");
		buffer.append(") as ok_count, (select count(*) as all_count ");
		buffer.append("from gms_device_account acc ");
		buffer.append("where acc.bsflag = '0' ");
		buffer.append("and acc.ifproduction = '5110000186000000001' ");
		buffer.append(" and (acc.owning_sub_id like 'C105008042%' or ");
		buffer.append(" acc.owning_sub_id like 'C105008013%') ");
		buffer.append(" and acc.license_num is not null) as all_count, ");
		buffer.append("( ");
		buffer.append("select sum(app.apply_num) as apply_count  ");
		buffer.append("from GMS_DEVICE_ALLAPP_DETAIL app ");
		buffer.append(" join ( ");
		buffer.append(" select * ");
		buffer.append("from gms_device_account acc ");
		buffer.append("where acc.bsflag = '0' ");
		buffer.append(" and acc.ifproduction = '5110000186000000001' ");
		buffer.append("and acc.license_num is not null ");
		buffer.append(" ) tt ");
		buffer.append(" on app.dev_ci_code=tt.dev_type ");
		buffer.append("left join gp_task_project_dynamic t  ");
		buffer.append("on app.project_info_no=t.project_info_no ");
		buffer.append("where t.org_subjection_id like 'C105008%' ");
		buffer.append(" ) as APPLY_NUM ");
		buffer.append("from dual ");
		buffer.append(" )");
		List<Map> list = jdbcDao.queryRecords(buffer.toString());
		return list;
	}

}
