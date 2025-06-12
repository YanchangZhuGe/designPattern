/**
 * 
 */
package com.bgp.gms.service.op.srv;

import java.util.*;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;

/**
 * @author ���챪
 * 
 *         2013-03-04
 * 
 *         used for ������Ŀ��������Ҫ�ĸ���ָ��ֵ�����ڹ�ʽ����
 */

@SuppressWarnings("rawtypes")
public class ProjectEvaluationUtil {

	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();

	/**
	 * ʵ���˹��ɱ��ܺ�
	 * 
	 * @param projectInfoNo
	 */

	public double getActualHumanCost(String projectInfoNo) {
		double value=1;
		String sql = "select sum(cost_detail_money)  cost_detail_money from view_op_target_actual_money_s where project_info_no='"
				+ projectInfoNo + "' and node_code ='S01001001'";
		Map map = pureDao.queryRecordBySQL(sql);
		if(map!=null){
			value = getDoubleFromStringMap(map, "cost_detail_money");
		}
		return value;
	}

	/**
	 * ʵ����ɲɼ���ֵ������
	 * 
	 * @param projectInfoNo
	 */
	public double getProjectActualValueWorkLoad(String projectInfoNo) {
		double value=1;
		StringBuffer sql = new StringBuffer(
				"with op_price as (select max((case NODE_CODE when 'S01021' then price_unit else 0 end)) - max((case NODE_CODE when 'S01022' then price_unit else 0 end)) ");
		sql.append(" price_unit, project_info_no  from bgp_op_price_project_info where bsflag='0' group by project_info_no) ");
		sql.append(" select to_number(to_char(sum(decode(gd.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002', ");
		sql.append(" gd.finish_2d_workload) * pi.price_unit / 10000),'99999999.00')) w_price from rpt_gp_daily gd ");
		sql.append(" left outer join op_price pi on gd.project_info_no = pi.project_info_no  ");
		sql.append(" where gd.bsflag = '0' and gd.project_info_no = '"
				+ projectInfoNo + "'");
		Map map = pureDao.queryRecordBySQL(sql.toString());
		if(map!=null){
			value = getDoubleFromStringMap(map, "w_price");
		}
		return value;
	}
	
	/**
	 * ��(ʵ��Ա������*ʵ��ʩ������)
	 * 
	 * @param projectInfoNo
	 */
	public double getHumanActualWorkDays(String projectInfoNo) {
		double value=1;
		StringBuffer sql = new StringBuffer(
				"select  sum(nvl(d.actual_end_date,sysdate)-nvl(d.actual_start_date,sysdate)) actual_days, ");
		sql.append(" sum(nvl(d.plan_end_date,sysdate)-nvl(d.plan_start_date,sysdate)) plan_days ");
		sql.append(" from bgp_human_prepare_human_detail d left join bgp_human_prepare p  ");
		sql.append(" on d.prepare_no = p.prepare_no  and p.bsflag = '0' and p.prepare_status='2' ");
		sql.append(" where d.bsflag = '0' and p.project_info_no='"
				+ projectInfoNo + "'");
		Map map = pureDao.queryRecordBySQL(sql.toString());
		if(map!=null){
			value = getDoubleFromStringMap(map, "actual_days");
		}
		return value;
	}
	
	/**
	 * ��(�ƻ�Ա������*�ƻ�ʩ������)
	 * 
	 * @param projectInfoNo
	 */
	public double getHumanActualPlanDays(String projectInfoNo) {
		double value=1;
		StringBuffer sql = new StringBuffer(
				"select  sum(nvl(d.actual_end_date,sysdate)-nvl(d.actual_start_date,sysdate)) actual_days, ");
		sql.append(" sum(nvl(d.plan_end_date,sysdate)-nvl(d.plan_start_date,sysdate)) plan_days ");
		sql.append(" from bgp_human_prepare_human_detail d left join bgp_human_prepare p  ");
		sql.append(" on d.prepare_no = p.prepare_no  and p.bsflag = '0' and p.prepare_status='2' ");
		sql.append(" where d.bsflag = '0' and p.project_info_no='"
				+ projectInfoNo + "'");
		Map map = pureDao.queryRecordBySQL(sql.toString());
		if(map!=null){
			value = getDoubleFromStringMap(map, "plan_days");
		}
		return value;
	}
	
	/**
	 * ʵ���������
	 * 
	 * @param projectInfoNo
	 */
	public double getActualSP(String project_info_no) {
		double value=1;
		/*String sql = "select sum(daily_finishing_sp) finishing_sp from rpt_gp_daily where bsflag='0' and project_info_no='"
				+ projectInfoNo + "'";
		Map map = pureDao.queryRecordBySQL(sql);*/
		
		StringBuffer sb = new StringBuffer();
		sb.append("select sum(t.daily_acquire_sp_num)-(-sum(t.daily_jp_acquire_shot_num))-(-sum(t.daily_qq_acquire_shot_num)) sp_num from gp_ops_daily_report t")
		.append(" where t.bsflag ='0' and t.project_info_no = '").append(project_info_no).append("'");
		Map map = pureDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			value = getDoubleFromStringMap(map, "sp_num");
		}
		return value;
	}

	/**
	 * �첨����
	 * 
	 * @param projectInfoNo
	 */
	public double getActualPointNum(String projectInfoNo) {
		double value=1;
		/*String sql = "select sum(point_num) point_num from rpt_gp_daily where bsflag='0' and project_info_no='"
			+ projectInfoNo + "'";
		Map map = pureDao.queryRecordBySQL(sql);*/
		
		StringBuffer sb = new StringBuffer();
		sb.append("select sum(t.daily_survey_geophone_num) geophone_num from gp_ops_daily_report t")
		.append(" where t.bsflag ='0' and t.project_info_no = '").append(projectInfoNo).append("'");
		Map map = pureDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			value = getDoubleFromStringMap(map, "geophone_num");
		}
		return value;
	}

	/**
	 * ְ������
	 * 
	 * @param projectInfoNo
	 */
	public double getActualHumanWorkers(String project_info_no) {
		double value=1;
		/*String sql = "select count(1) nums  from view_human_project_relation  "
				+ "where employee_gz is not null and project_info_no = '"
				+ projectInfoNo + "' and employee_gz like '0110000019%'";
		Map map = pureDao.queryRecordBySQL(sql);*/
		StringBuffer sb = new StringBuffer("");
		sb.append("select (select count(*) from view_human_project_relation t where (t.EMPLOYEE_GZ='0110000019000000001' or t.EMPLOYEE_GZ='0110000019000000002')")
		.append(" and t.project_info_no = '").append(project_info_no).append("') actual,(select count(*) from view_human_project_relation t ")
		.append(" where (t.EMPLOYEE_GZ='0110000059000000005' or t.EMPLOYEE_GZ='0110000019000000001' or t.employee_gz='0110000019000000002') and t.project_info_no = '")
		.append(project_info_no).append("') total from dual");
		Map map = pureDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			value = getDoubleFromStringMap(map, "actual");
		}
		return value;
	}

	/**
	 * Ա������
	 * 
	 * @param projectInfoNo
	 */
	public double getActualHumanEmployees(String project_info_no) {
		double value=1;
		/*String sql = "select count(1) nums  from view_human_project_relation  "
				+ "where employee_gz is not null and project_info_no = '"
				+ projectInfoNo + "' and employee_gz like '0110000059%'";
		Map map = pureDao.queryRecordBySQL(sql);*/
		StringBuffer sb = new StringBuffer("");
		sb.append("select (select count(*) from view_human_project_relation t where (t.EMPLOYEE_GZ='0110000019000000001' or t.EMPLOYEE_GZ='0110000019000000002')")
		.append(" and t.project_info_no = '").append(project_info_no).append("') actual,(select count(*) from view_human_project_relation t ")
		.append(" where (t.EMPLOYEE_GZ='0110000059000000005' or t.EMPLOYEE_GZ='0110000019000000001' or t.employee_gz='0110000019000000002') and t.project_info_no = '")
		.append(project_info_no).append("') total from dual");
		Map map = pureDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			value = getDoubleFromStringMap(map, "total");
		}
		return value;
	}

	/**
	 * ��еʹ�÷�
	 * 
	 * @param projectInfoNo
	 */
	public double getMachineMoney(String projectInfoNo) {
		double value=1;
		String sql = "select sum(cost_detail_money)  cost_detail_money from view_op_target_actual_money_s where project_info_no='"
				+ projectInfoNo + "' and node_code ='S01001004'";
		Map map = pureDao.queryRecordBySQL(sql);
		if(map!=null){
			value = getDoubleFromStringMap(map, "cost_detail_money");
		}
		return value;
	}
	
	/**
	 * ��(Ͷ��װ���ʲ�ԭֵ/240��*ʵ��ʹ������)
	 * 
	 * @param projectInfoNo
	 */
	public double getDeviceValueIntactByDays(String projectInfoNo) {
		double value=1;
		String sql = "select sum(nvl(acc.asset_value,0)/240*to_number(nvl(dui.actual_out_time,trunc(sysdate,'dd'))-trunc(dui.actual_in_time,'dd'))) as zhanyongfei "
				+ "from gms_device_account_dui dui join gms_device_account acc on dui.fk_dev_acc_id=acc.dev_acc_id "
				+ "where project_info_id='" + projectInfoNo + "'";
		Map map = pureDao.queryRecordBySQL(sql);
		if(map!=null){
			value = getDoubleFromStringMap(map, "zhanyongfei");
		}
		return value;
	}
	
	/**
	 * ������������
	 * 
	 * @param projectInfoNo
	 */
	public double getInstrumentDays(String projectInfoNo) {
		double value = 1;
		// TODO ������������������Ŀǰû��Դͷ
		return value;
	}

	/**
	 * ���õ����ܷŵ�����
	 * 
	 * @param projectInfoNo
	 */
	public double getAlternateChannelSP(String projectInfoNo) {
		double value = 1;
		// TODO ���㱸�õ����ܷŵ�������Ŀǰû��Դͷ
		return value;
	}

	/**
	 * ��Ŀʵ��ƽ����Ч
	 * 
	 * @param projectInfoNo
	 */
	public double getActualDailyEff(String projectInfoNo) {
		double value = 1;
		String sql = "select sum(daily_finishing_sp)/count(1)  daily_eff from rpt_gp_daily where bsflag='0' and work_status='�ɼ�' and project_info_no='"
				+ projectInfoNo + "'";
		Map map = pureDao.queryRecordBySQL(sql);
		if(map!=null){
			value = getDoubleFromStringMap(map, "daily_eff");
		}
		return value;
	}

	/**
	 * ��ĿԤ��ƽ����Ч
	 * 
	 * @param projectInfoNo
	 */
	public double getPlanDailyEff(String projectInfoNo) {
		double value = 1;
		String sql = "select gd.design_sp_num/decode(nvl((gp.acquire_end_time-gp.acquire_start_time),1),0,1,nvl((gp.acquire_end_time-gp.acquire_start_time),1)) daily_eff from  "
				+ "gp_task_project gp inner join  gp_task_project_dynamic gd on gp.project_info_no  = gd.project_info_no and gd.bsflag='0' and gp.bsflag='0' and gp.project_info_no='"
				+ projectInfoNo + "'";
		Map map = pureDao.queryRecordBySQL(sql);
		if(map!=null){
			value = getDoubleFromStringMap(map, "daily_eff");
		}
		return value;
	}
	
	
	/**
	 * ʵ����������
	 * 
	 * @param projectInfoNo
	 */
	public double getActualWorkerDays(String project_info_no) {
		double value = 1;
		StringBuffer sb = new StringBuffer();
		sb.append("select count(*) produce_date from(select s.daily_no ,s.if_build from gp_ops_daily_report t")
		.append(" join gp_ops_daily_produce_sit s on t.daily_no = s.daily_no and s.bsflag ='0'")
		.append(" where t.bsflag ='0' and s.if_build in('1','2','3','4','5','6','9','e')")
		.append(" and t.project_info_no = '").append(project_info_no).append("' group by s.daily_no ,s.if_build)");
		Map map = pureDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			value = getDoubleFromStringMap(map, "produce_date");
		}
		return value;
	}
	/**
	 * ��Ȼ����
	 * 
	 * @param projectInfoNo
	 */
	public double getAllWorkerDays(String project_info_no) {
		double value = 1;
		StringBuffer sb = new StringBuffer();
		sb.append("select (max(t.produce_date)-min(t.produce_date)-(-1)) produce_date from gp_ops_daily_report t")
		.append(" where t.bsflag ='0' and t.project_info_no = '").append(project_info_no).append("'");
		Map map = pureDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			value = getDoubleFromStringMap(map, "produce_date");
		}
		return value;
	}
	/**
	 * ʵ�ʳɱ�
	 * 
	 * @param projectInfoNo
	 */
	public double getActualCost(String projectInfoNo) {
		double value = 1;
		String sql = "select sum(cost_detail_money)  cost_detail_money from view_op_target_actual_money_s where project_info_no='"
				+ projectInfoNo + "' and node_code ='S01001'";
		Map map = pureDao.queryRecordBySQL(sql);
		if(map!=null){
			value = getDoubleFromStringMap(map, "cost_detail_money");
		}
		return value;
	}
	/**
	 * Ŀ��ɱ�
	 * 
	 * @param projectInfoNo
	 */
	public double getPlanCost(String projectInfoNo) {
		double value = 1;
		String sql = "select sum(cost_detail_money) cost_detail_money from view_op_target_plan_money_s where project_info_no='"
				+ projectInfoNo + "' and node_code ='S01001'";
		Map map = pureDao.queryRecordBySQL(sql);
		if(map!=null){
			value = getDoubleFromStringMap(map, "cost_detail_money");
		}
		return value;
	}
	
	/**
	 * ȼ�϶��������ܼ�ֵ��
	 * 
	 * @param projectInfoNo
	 */
	public double getActualOilCost(String projectInfoNo) {
		double value = 1;
		String sql = "select sum(cost_detail_money)  cost_detail_money from view_op_target_actual_money_s where project_info_no='"
				+ projectInfoNo + "' and node_code ='S01001006004'";
		Map map = pureDao.queryRecordBySQL(sql);
		if(map!=null){
			value = getDoubleFromStringMap(map, "cost_detail_money");
		}
		return value;
	}
	/**
	 * ��Ŀ�������������ܼ�ֵ��
	 * 
	 * @param projectInfoNo
	 */
	public double getActualOtherMaterialCost(String projectInfoNo) {
		double value = 1;
		String sql = "select sum(cost_detail_money)  cost_detail_money from view_op_target_actual_money_s where project_info_no='"
				+ projectInfoNo + "' and node_code ='S01001006002'";
		Map map = pureDao.queryRecordBySQL(sql);
		if(map!=null){
			value = getDoubleFromStringMap(map, "cost_detail_money");
		}
		return value;
	}
	/**
	 * ����ֱ�ӷ�����
	 * 
	 * @param projectInfoNo
	 */
	public double getActualOtherDirectCost(String projectInfoNo) {
		double value = 1;
		String sql = "select sum(cost_detail_money)  cost_detail_money from view_op_target_actual_money_s where project_info_no='"
				+ projectInfoNo + "' and node_code ='S01001003'";
		Map map = pureDao.queryRecordBySQL(sql);
		if(map!=null){
			value = getDoubleFromStringMap(map, "cost_detail_money");
		}
		return value;
	}
	/**
	 * ��Ŀʩ���⳥��
	 * 
	 * @param projectInfoNo
	 */
	public double getActualConstructionCompensationCost(String projectInfoNo) {
		double value = 1;
		String sql = "select sum(cost_detail_money)  cost_detail_money from view_op_target_actual_money_s where project_info_no='"
				+ projectInfoNo + "' and node_code ='S01001002001004'";
		Map map = pureDao.queryRecordBySQL(sql);
		if(map!=null){
			value = getDoubleFromStringMap(map, "cost_detail_money");
		}
		return value;
	}
	
	
	/**
	 * �ɼ��豸����ԭֵ
	 * 
	 * @param projectInfoNo
	 */
	public double getCollectDamageCost(String projectInfoNo) {
		double value=1;
		//TODO �ɼ��豸����ԭֵ��û������Դͷ
		return value;
	}
	/**
	 * �ɼ��豸ԭֵ����
	 * 
	 * @param projectInfoNo
	 */
	public double getCollectCost(String projectInfoNo) {
		double value = 1;
		//TODO ��Ŀʵ��Ͷ��ɼ��豸ԭֵ������û������Դͷ
		return value;
	}
	
	
	
	

	public double getDoubleFromStringMap(Map map, String keyName) {
		String svalue=(String) map.get(keyName);
		if(svalue==null||"".equals(svalue))
			return 0;
		else
			return Double.parseDouble(svalue);
	}

	@SuppressWarnings("unchecked")
	public Map getFormulaValueIntoMap(Map map,String projectInfoNo){
		map.put("{ʵ���˹��ɱ��ܺ�}", getActualHumanCost(projectInfoNo));
		map.put("{��Ŀʵ����ɲɼ���ֵ������}", getProjectActualValueWorkLoad(projectInfoNo));
		
		//map.put("{��(Ա������*ʵ��ʩ������)}", getHumanActualWorkDays(projectInfoNo));//��λ������Ͷ���˹���
		map.put("{��λ������Ͷ���˹���}", getHumanActualWorkDays(projectInfoNo));//{��(Ա������*ʵ��ʩ������)}
		
		//map.put("{��(Ԥ��Ա������*Ͷ�����*30��)}", getHumanActualPlanDays(projectInfoNo));//�˹�ʱЧ��
		map.put("{�˹�ʱЧ��}", getHumanActualPlanDays(projectInfoNo));//{��(Ԥ��Ա������*Ͷ�����*30��)}
		
		map.put("{ʵ���������}", getActualSP(projectInfoNo));
		map.put("{�첨����}", getActualPointNum(projectInfoNo));
		map.put("{ְ������}", getActualHumanWorkers(projectInfoNo));
		map.put("{Ա������}", getActualHumanEmployees(projectInfoNo));
		
		//map.put("{��(Ͷ��װ���ʲ�ԭֵ/240��*ʵ��ʹ������)}", getDeviceValueIntactByDays(projectInfoNo)); //��λ��ֵ��װ��Ͷ��ϵ������λʵ�﹤����װ��Ͷ��ϵ��
		map.put("{��λ��ֵ��װ��Ͷ��ϵ��}", getDeviceValueIntactByDays(projectInfoNo)); //{��(Ͷ��װ���ʲ�ԭֵ/240��*ʵ��ʹ������)}
		map.put("{��λʵ�﹤����װ��Ͷ��ϵ��}", getDeviceValueIntactByDays(projectInfoNo)); //{��(Ͷ��װ���ʲ�ԭֵ/240��*ʵ��ʹ������)}
		
		map.put("{��еʹ�÷�}", getMachineMoney(projectInfoNo));
		map.put("{������������}", getInstrumentDays(projectInfoNo));
		map.put("{���õ����ܷŵ�����}", getAlternateChannelSP(projectInfoNo));
		map.put("{��Ŀʵ��ƽ����Ч}", getActualDailyEff(projectInfoNo));
		map.put("{��ĿԤ��ƽ����Ч}", getPlanDailyEff(projectInfoNo));
		map.put("{ʵ����������}", getActualWorkerDays(projectInfoNo));
		map.put("{��Ȼ����}", getAllWorkerDays(projectInfoNo));
		map.put("{ʵ�ʳɱ�}", getActualCost(projectInfoNo));
		map.put("{Ŀ��ɱ�}", getPlanCost(projectInfoNo));
		map.put("{��Ŀȼ�϶��������ܼ�ֵ��}", getActualOilCost(projectInfoNo));
		map.put("{��Ŀ�������������ܼ�ֵ��}", getActualOtherMaterialCost(projectInfoNo));
		map.put("{����ֱ�ӷ�����}", getActualOtherDirectCost(projectInfoNo));
		map.put("{��Ŀʩ���⳥��}", getActualConstructionCompensationCost(projectInfoNo));
		map.put("{�ɼ��豸����ԭֵ}", getCollectDamageCost(projectInfoNo));
		map.put("{��Ŀʵ��Ͷ��ɼ��豸ԭֵ����}", getCollectCost(projectInfoNo));
		
		return map;
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) { 
		//\\{[a-zA-Z-]+\\} 
		String str = "(275.0*43.0)/{��(Ԥ��Ա������*Ͷ�����*30��)}";
		String code = "(Ԥ��Ա������\\*Ͷ�����\\*30��)";
		String value = "3173.0";
		str = str.replaceAll(code, value);
		System.out.println(str);
	}

}
