package com.bgp.dms.tempoQuartz;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

//类名对应数据库表名
public class TempoZhzxDevDzyq {

	private static String TABLE = "tempo_zhzx_dev_dzyq";

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();

	// 插入数据
	public void insert() {

		this.delete();
		this.save();

		System.out.println("成功插入数据(" + TABLE + "): " + this.select() + "条");
	}

	// 删除表
	public void delete() {

		String sqString = "delete from " + TABLE + " ";
		jdbcDao.executeUpdate(sqString);
	}

	// 保存数据
	public void save() {

		String tableName = "  insert into " + TABLE + " ";
		String sqlString = tableName + " select '完好' as x_num,\r\n" + 
				"           aa.*,\r\n" + 
				"           (aa.闲置数量 + aa.在用数量 + aa.touseless_num + aa.待修数量 + aa.在修数量 +\r\n" + 
				"           aa.盘亏数量 + aa.未交回数量 + aa.毁损数量) as 总数量,\r\n" + 
				"           (aa.闲置数量 + aa.在用数量) as 完好数量\r\n" + 
				"      from (select tmp.*,\r\n" + 
				"                   nvl((select sum(dui.unuse_num)\r\n" + 
				"                         from gms_device_coll_account_dui dui\r\n" + 
				"                         left join gp_task_project p\r\n" + 
				"                           on p.project_info_no = dui.project_info_id\r\n" + 
				"                         left join gp_task_project_dynamic dy\r\n" + 
				"                           on dy.project_info_no = dui.project_info_id\r\n" + 
				"                        where dui.bsflag = '0'\r\n" + 
				"                          and p.bsflag != '1'\r\n" + 
				"                          and dy.bsflag != '1'\r\n" + 
				"                          and dui.device_id = tmp.device_id\r\n" + 
				"                          and tmp.sub_id is not null\r\n" + 
				"                          and dy.org_subjection_id like\r\n" + 
				"                              '%' || tmp.sub_id || '%'),\r\n" + 
				"                       0) +\r\n" + 
				"                   nvl((select sum(nvl(t.back_num, 0) - nvl(t.checked_num, 0))\r\n" + 
				"                         from gms_device_collbackapp_detail t\r\n" + 
				"                         left join gms_device_coll_account_dui dui\r\n" + 
				"                           on t.dev_acc_id = dui.dev_acc_id\r\n" + 
				"                         left join gms_device_collbackapp app\r\n" + 
				"                           on t.device_backapp_id = app.device_backapp_id\r\n" + 
				"                         left join gms_device_collectinfo c\r\n" + 
				"                           on c.device_id = dui.device_id\r\n" + 
				"                         left join gp_task_project p\r\n" + 
				"                           on p.project_info_no = dui.project_info_id\r\n" + 
				"                         left join gp_task_project_dynamic dy\r\n" + 
				"                           on dy.project_info_no = dui.project_info_id\r\n" + 
				"                        where dui.device_id = tmp.device_id\r\n" + 
				"                          and tmp.sub_id is not null\r\n" + 
				"                          and app.state = '9'\r\n" + 
				"                          and p.bsflag != '1'\r\n" + 
				"                          and dy.bsflag != '1'\r\n" + 
				"                          and app.bsflag = '0'\r\n" + 
				"                          and t.bsflag = '0'\r\n" + 
				"                          and app.backapptype = '4'\r\n" + 
				"                          and (c.dev_code like '01%' or\r\n" + 
				"                              c.dev_code like '02%' or\r\n" + 
				"                              c.dev_code like '03%' or\r\n" + 
				"                              c.dev_code like '05%')\r\n" + 
				"                          and dy.org_subjection_id like\r\n" + 
				"                              '%' || tmp.sub_id || '%'),\r\n" + 
				"                       0) +\r\n" + 
				"                   nvl((select sum(t.assign_num)\r\n" + 
				"                         from gms_device_appmix_main t\r\n" + 
				"                         left join gms_device_mixinfo_form m\r\n" + 
				"                           on t.device_mixinfo_id = m.device_mixinfo_id\r\n" + 
				"                         left join gp_task_project_dynamic dy\r\n" + 
				"                           on dy.project_info_no = m.project_info_no\r\n" + 
				"                        where t.dev_ci_code = tmp.device_id\r\n" + 
				"                          and m.state = '1'\r\n" + 
				"                          and m.bsflag = '0'\r\n" + 
				"                          and m.mix_type_id = 'S1405'\r\n" + 
				"                          and m.mixform_type = '7'\r\n" + 
				"                          and t.state = '0'\r\n" + 
				"                          and dy.org_subjection_id like\r\n" + 
				"                              '%' || tmp.sub_id || '%'),\r\n" + 
				"                       0) as 在用数量\r\n" + 
				"              from (select acc.type_id,\r\n" + 
				"                           acc.device_id,\r\n" + 
				"                           acc.dev_acc_id,\r\n" + 
				"                           acc.dev_unit,\r\n" + 
				"                           acc.dev_model as 设备型号,\r\n" + 
				"                           acc.dev_name as 设备名称,\r\n" + 
				"                           nvl(devb.inacc_num, 0) as 在账数量,\r\n" + 
				"                           nvl(teach.good_num, 0) + nvl(ms.wanhao_num, 0) as 闲置数量,\r\n" + 
				"                           nvl(teach.touseless_num, 0) +\r\n" + 
				"                           nvl(ms.touseless_num, 0) as touseless_num,\r\n" + 
				"                           nvl(teach.torepair_num, 0) + nvl(ms.weixiu_num, 0) as 待修数量,\r\n" + 
				"                           nvl(teach.repairing_num, 0) +\r\n" + 
				"                           nvl(ms.zaixiu_num, 0) as 在修数量,\r\n" + 
				"                           nvl(teach.tocheck_num, 0) as 盘亏数量,\r\n" + 
				"                           nvl(teach.noreturn_num, 0) as 未交回数量,\r\n" + 
				"                           nvl(teach.destroy_num, 0) + nvl(ms.huisun_num, 0) as 毁损数量,\r\n" + 
				"                           acc.ifcountry,\r\n" + 
				"                           ci.dev_code,\r\n" + 
				"                           l.coding_name as 设备类型,\r\n" + 
				"                           org.org_abbreviation as 所在单位,\r\n" + 
				"                           s.org_abbreviation,\r\n" + 
				"                           unitsd.coding_name as 计量单位,\r\n" + 
				"                           acc.usage_sub_id,\r\n" + 
				"                           acc.usage_org_id,\r\n" + 
				"                           case\r\n" + 
				"                             when acc.usage_org_id = 'C6000000005551' then\r\n" + 
				"                              'C105001005'\r\n" + 
				"                             when acc.usage_org_id = 'C6000000005538' then\r\n" + 
				"                              'C105001002'\r\n" + 
				"                             when acc.usage_org_id = 'C6000000005555' then\r\n" + 
				"                              'C105001003'\r\n" + 
				"                             when acc.usage_org_id = 'C6000000005543' then\r\n" + 
				"                              'C105001004'\r\n" + 
				"                             when acc.usage_org_id = 'C6000000005534' then\r\n" + 
				"                              'C105005004'\r\n" + 
				"                             when acc.usage_org_id = 'C6000000007537' then\r\n" + 
				"                              'C105063'\r\n" + 
				"                             when acc.usage_org_id = 'C6000000005547' then\r\n" + 
				"                              'C105005000'\r\n" + 
				"                             when acc.usage_org_id = 'C6000000005560' then\r\n" + 
				"                              'C105005001'\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000040' then\r\n" + 
				"                              'C105007'\r\n" + 
				"                             when acc.usage_org_id = 'C6000000008010' then\r\n" + 
				"                              'C105087' --西南物探分公司\r\n" + 
				"                             when acc.usage_org_id = 'C6000000008170' then\r\n" + 
				"                              'C105092' --大庆物探一公司\r\n" + 
				"                             when acc.usage_org_id = 'C6000000008171' then\r\n" + 
				"                              'C105093' --大庆物探二公司\r\n" + 
				"                             when acc.usage_org_id = 'C6000000008159' then\r\n" + 
				"                              'C105002102' --巴西项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000008169' then\r\n" + 
				"                              'C105002112' --北美项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000173' then\r\n" + 
				"                              'C105002045' --尼日尔项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000153' then\r\n" + 
				"                              'C105002046' --乍得项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000157' then\r\n" + 
				"                              'C105002048' --阿尔及利亚项目部     \r\n" + 
				"                             when acc.usage_org_id = 'C6000000000263' then\r\n" + 
				"                              'C105002006004' --印尼项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000146' then\r\n" + 
				"                              'C105002007001' --刚果项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000232' then\r\n" + 
				"                              'C105002007002' --尼日利亚项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000227' then\r\n" + 
				"                              'C105002008' --苏丹项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000255' then\r\n" + 
				"                              'C105002009002' --厄瓜多尔项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000007178' then\r\n" + 
				"                              'C105002115' --埃及项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000005724' then\r\n" + 
				"                              'C105002009006' --玻利维亚项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000007877' then\r\n" + 
				"                              'C105002090' --伊拉克南部项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000272' then\r\n" + 
				"                              'C105002043' --伊拉克北部项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000243' then\r\n" + 
				"                              'C105002044' --巴基斯坦项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000007899' then\r\n" + 
				"                              'C105002075004' --科威特项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000241' then\r\n" + 
				"                              'C105002075006' --阿曼项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000201' then\r\n" + 
				"                              'C105002076005' --乌兹别克斯坦项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000271' then\r\n" + 
				"                              'C105002076003' --土库曼斯坦项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000266' then\r\n" + 
				"                              'C105002076004' --哈萨克斯坦项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000007194' then\r\n" + 
				"                              'C105002093' --突尼斯项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000236' then\r\n" + 
				"                              'C105002075005' --沙特项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000007900' then\r\n" + 
				"                              'C105002075007' --阿联酋项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000008004' then\r\n" + 
				"                              'C105002099' --马来西亚项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000008005' then\r\n" + 
				"                              'C105002098' --摩洛哥项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000008007' then\r\n" + 
				"                              'C105002096' --缅甸项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000008008' then\r\n" + 
				"                              'C105002095' --加纳项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000211' then\r\n" + 
				"                              'C105002004000' --肯尼亚项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000288' then\r\n" + 
				"                              'C105002004005' --莫桑比克项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000199' then\r\n" + 
				"                              'C105002004006' --坦桑尼亚项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000007163' then\r\n" + 
				"                              'C105002004008' --埃塞俄比亚项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000000224' then\r\n" + 
				"                              'C105002006002' --泰国项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000008482' then\r\n" + 
				"                              'C105002114' --加勒比项目部\r\n" + 
				"                             when acc.usage_org_id = 'C6000000008167' then\r\n" + 
				"                              'C105002111' --泰国设备中心\r\n" + 
				"                             when acc.usage_org_id = 'C6000000005804' then\r\n" + 
				"                              'C105002032001' --迪拜设备中心\r\n" + 
				"                             else\r\n" + 
				"                              acc.usage_org_id\r\n" + 
				"                           end as sub_id\r\n" + 
				"                      from gms_device_coll_account acc\r\n" + 
				"                      left join comm_coding_sort_detail l\r\n" + 
				"                        on l.coding_code_id = acc.type_id\r\n" + 
				"                       and l.coding_sort_id like '5110000031'\r\n" + 
				"                      left join gms_device_coll_mapping mp\r\n" + 
				"                        on mp.device_id = acc.device_id\r\n" + 
				"                      left join sys_organization s\r\n" + 
				"                        on s.org_code = orgsubidtoshortid(acc.usage_sub_id)\r\n" + 
				"                      left join (select accb.dev_type,\r\n" + 
				"                                       accb.owning_org_id,\r\n" + 
				"                                       accb.ifcountry,\r\n" + 
				"                                       nvl(count(accb.dev_acc_id), 0) as inacc_num\r\n" + 
				"                                  from gms_device_account_b accb\r\n" + 
				"                                 where accb.bsflag = '0'\r\n" + 
				"                                   and accb.account_stat =\r\n" + 
				"                                       '0110000013000000003'\r\n" + 
				"                                 group by accb.dev_type,\r\n" + 
				"                                          accb.owning_org_id,\r\n" + 
				"                                          accb.ifcountry) devb\r\n" + 
				"                        on devb.dev_type = mp.dev_ci_code\r\n" + 
				"                       and acc.usage_org_id = devb.owning_org_id\r\n" + 
				"                       and acc.ifcountry = devb.ifcountry\r\n" + 
				"                      left join (select d.out_dev_id,\r\n" + 
				"                                       sum(nvl(d.wanhao_num, 0)) as wanhao_num,\r\n" + 
				"                                       sum(nvl(d.touseless_num, 0)) as touseless_num,\r\n" + 
				"                                       sum(nvl(d.weixiu_num, 0)) as weixiu_num,\r\n" + 
				"                                       sum(nvl(d.zaixiu_num, 0)) as zaixiu_num,\r\n" + 
				"                                       sum(nvl(d.huisun_num, 0)) as huisun_num\r\n" + 
				"                                  from gms_device_moveapp_detail d\r\n" + 
				"                                  left join gms_device_moveapp p\r\n" + 
				"                                    on p.moveapp_id = d.moveapp_id\r\n" + 
				"                                 where p.state = '1'\r\n" + 
				"                                   and p.bsflag = '0'\r\n" + 
				"                                   and p.move_type = '2'\r\n" + 
				"                                 group by d.out_dev_id) ms\r\n" + 
				"                        on acc.dev_acc_id = ms.out_dev_id\r\n" + 
				"                      left join gms_device_collectinfo ci\r\n" + 
				"                        on acc.device_id = ci.device_id\r\n" + 
				"                      left join comm_org_information org\r\n" + 
				"                        on acc.usage_org_id = org.org_id\r\n" + 
				"                       and org.bsflag = '0'\r\n" + 
				"                      left join comm_coding_sort_detail unitsd\r\n" + 
				"                        on acc.dev_unit = unitsd.coding_code_id\r\n" + 
				"                      left join gms_device_coll_account_tech teach\r\n" + 
				"                        on teach.dev_acc_id = acc.dev_acc_id\r\n" + 
				"                     where acc.bsflag = '0'\r\n" + 
				"                       and acc.usage_sub_id like 'C105%') tmp\r\n" + 
				"             where (tmp.dev_code like '01%' or tmp.dev_code like '02%' or\r\n" + 
				"                   tmp.dev_code like '03%' or tmp.dev_code like '05%')) aa\r\n" + 
				"     where (aa.闲置数量 + aa.在用数量 + aa.touseless_num + aa.待修数量 + aa.在修数量 +\r\n" + 
				"           aa.盘亏数量 + aa.未交回数量 + aa.毁损数量) > 0\r\n" + 
				"     order by 所在单位,\r\n" + 
				"              设备类型,\r\n" + 
				"              case\r\n" + 
				"                when 设备名称 = '电源站' then\r\n" + 
				"                 'A'\r\n" + 
				"                when 设备名称 = '交叉站' then\r\n" + 
				"                 'B'\r\n" + 
				"                when 设备名称 = '采集站' then\r\n" + 
				"                 'C'\r\n" + 
				"                else\r\n" + 
				"                 'D'\r\n" + 
				"              end ";

		jdbcTemplate.execute(sqlString);
	}

	public int select() {

		String sqString = "select * from " + TABLE;

		List<Map> list = jdbcDao.queryRecords(sqString.toString());

		return list.size();
	}

}
