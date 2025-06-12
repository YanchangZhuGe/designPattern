package com.bgp.dms.tempoQuartz;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

//������Ӧ���ݿ����
public class TempoZhzxDevJbq {

	private static String TABLE = "tempo_zhzx_dev_jbq";

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();

	// ��������
	public void insert() {

		this.delete();
		this.save();

		System.out.println("�ɹ���������(" + TABLE + "): " + this.select() + "��");
	}

	// ɾ����
	public void delete() {

		String sqString = "delete from " + TABLE + " ";
		jdbcDao.executeUpdate(sqString);
	}

	// ��������
	public void save() {

		String tableName = "  insert into " + TABLE + " ";
		String sqlString = tableName + " with all_wtc as\r\n" + 
				"     (select tmp.*\r\n" + 
				"        from (select acc.owning_org_id,\r\n" + 
				"                     suborg.org_subjection_id,\r\n" + 
				"                     acc.usage_org_id,\r\n" + 
				"                     acc.dev_acc_id,\r\n" + 
				"                     acc.dev_unit,\r\n" + 
				"                     nvl(acc.total_num, 0) ������,\r\n" + 
				"                     nvl(acc.unuse_num, 0) as ��������,\r\n" + 
				"                     acc.dev_name,\r\n" + 
				"                     acc.dev_model,\r\n" + 
				"                     nvl(acc.use_num, 0) ��������,\r\n" + 
				"                     acc.ifcountry,\r\n" + 
				"                     nvl(acc.other_num, 0) ��������,\r\n" + 
				"                     nvl(devb.inacc_num, 0) as ��������,\r\n" + 
				"                     ci.dev_code,\r\n" + 
				"                     ci.dev_name as dev_type,\r\n" + 
				"                     usageorg.org_abbreviation as usage_org_name,\r\n" + 
				"                     unitsd.coding_name as unit_name,\r\n" + 
				"                     case\r\n" + 
				"                       when suborg.org_subjection_id like 'C105001005%' then\r\n" + 
				"                        '����ľ��̽��'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105001002%' then\r\n" + 
				"                        '�½���̽��'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105001003%' then\r\n" + 
				"                        '�¹���̽��'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105001004%' then\r\n" + 
				"                        '�ຣ��̽��'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105005004%' then\r\n" + 
				"                        '������̽��'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105005000%' then\r\n" + 
				"                        '������̽��'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105005001%' then\r\n" + 
				"                        '������̽��'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105007%' then\r\n" + 
				"                        '������̽��'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105063%' then\r\n" + 
				"                        '�ɺ���̽��'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105006%' then\r\n" + 
				"                        'װ������'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105002%' then\r\n" + 
				"                        '���ʿ�̽��ҵ��'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105003%' then\r\n" + 
				"                        '�о�Ժ'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105008%' then\r\n" + 
				"                        '�ۺ��ﻯ��'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105087%' then\r\n" + 
				"                        '������̽�ֹ�˾'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105092%' then\r\n" + 
				"                        '������̽һ��˾'\r\n" + 
				"                       when suborg.org_subjection_id like 'C105093%' then\r\n" + 
				"                        '������̽����˾'\r\n" + 
				"                       else\r\n" + 
				"                        ''\r\n" + 
				"                     end as owning_org_name,\r\n" + 
				"                     acc.usage_sub_id\r\n" + 
				"                from gms_device_coll_account acc\r\n" + 
				"                left join gms_device_collectinfo ci\r\n" + 
				"                  on acc.device_id = ci.device_id\r\n" + 
				"                left join gms_device_coll_mapping mp\r\n" + 
				"                  on mp.device_id = acc.device_id\r\n" + 
				"                left join comm_org_information usageorg\r\n" + 
				"                  on acc.usage_org_id = usageorg.org_id\r\n" + 
				"                 and usageorg.bsflag = '0'\r\n" + 
				"                left join comm_org_subjection suborg\r\n" + 
				"                  on acc.owning_org_id = suborg.org_id\r\n" + 
				"                 and suborg.bsflag = '0'\r\n" + 
				"                left join comm_coding_sort_detail unitsd\r\n" + 
				"                  on acc.dev_unit = unitsd.coding_code_id\r\n" + 
				"                left join (select accb.dev_type,\r\n" + 
				"                                 accb.owning_org_id,\r\n" + 
				"                                 accb.ifcountry,\r\n" + 
				"                                 nvl(count(accb.dev_acc_id) * 100, 0) as inacc_num\r\n" + 
				"                            from gms_device_account_b accb\r\n" + 
				"                           where accb.bsflag = '0'\r\n" + 
				"                             and accb.account_stat = '0110000013000000003'\r\n" + 
				"                           group by accb.dev_type,\r\n" + 
				"                                    accb.owning_org_id,\r\n" + 
				"                                    accb.ifcountry) devb\r\n" + 
				"                  on devb.dev_type = mp.dev_ci_code\r\n" + 
				"                 and acc.ifcountry = devb.ifcountry\r\n" + 
				"                 and acc.owning_org_id = devb.owning_org_id\r\n" + 
				"               where acc.bsflag = '0'\r\n" + 
				"                 and (acc.owning_sub_id like 'C105%' or\r\n" + 
				"                     acc.usage_sub_id like 'C105%')) tmp\r\n" + 
				"       where (tmp.dev_code like '04%' or tmp.dev_code like '06%')\r\n" + 
				"       order by case\r\n" + 
				"                  when tmp.usage_sub_id like 'C105002%' then\r\n" + 
				"                   'B'\r\n" + 
				"                  else\r\n" + 
				"                   'A'\r\n" + 
				"                end,\r\n" + 
				"                tmp.dev_model,\r\n" + 
				"                tmp.usage_org_name,\r\n" + 
				"                tmp.dev_acc_id)\r\n" + 
				"    select '���' as x_num,\r\n" + 
				"           ga.dev_acc_id,\r\n" + 
				"           ga.dev_name,\r\n" + 
				"           ga.dev_model,\r\n" + 
				"           wtc.ifcountry,\r\n" + 
				"           wtc.owning_org_name,\r\n" + 
				"           wtc.�������� as ��������,\r\n" + 
				"           wtc.������ as ������,\r\n" + 
				"           wtc.�������� as ��������,\r\n" + 
				"           wtc.�������� as ��������,\r\n" + 
				"           wtc.�������� as ��������,\r\n" + 
				"           --nvl(ga.other_num, 0) as ��������,\r\n" + 
				"           --nvl(ga.total_num, 0) as ������,\r\n" + 
				"           --nvl(ga.unuse_num, 0) as ��������,\r\n" + 
				"           --nvl(ga.use_num, 0) as ��������,\r\n" + 
				"           nvl(gt.good_num, 0) as �������,\r\n" + 
				"           nvl(gt.tocheck_num, 0) as �̿�����,\r\n" + 
				"           nvl(gt.touseless_num, 0) as touseless_num,\r\n" + 
				"           --nvl(devb.inacc_num, 0) as ��������,\r\n" + 
				"           nvl(gt.torepair_num, 0) as ��������,\r\n" + 
				"           nvl(gt.destroy_num, 0) as ��������,\r\n" + 
				"           nvl(gt.repairing_num, 0) as ��������,\r\n" + 
				"           gc1.dev_name as dev_type,\r\n" + 
				"           usageorg.org_abbreviation as usage_org_name,\r\n" + 
				"           unitsd.coding_name as unit_name,\r\n" + 
				"           ga.dev_position\r\n" + 
				"      from gms_device_coll_account ga\r\n" + 
				"     right join all_wtc wtc\r\n" + 
				"        on wtc.dev_acc_id = ga.dev_acc_id\r\n" + 
				"      left join gms_device_collectinfo gc1\r\n" + 
				"        on ga.device_id = gc1.device_id\r\n" + 
				"      left join gms_device_coll_mapping mp\r\n" + 
				"        on mp.device_id = ga.device_id\r\n" + 
				"      left join comm_org_information usageorg\r\n" + 
				"        on ga.usage_org_id = usageorg.org_id\r\n" + 
				"       and usageorg.bsflag = '0'\r\n" + 
				"      left join comm_coding_sort_detail unitsd\r\n" + 
				"        on ga.dev_unit = unitsd.coding_code_id\r\n" + 
				"      left join (select accb.dev_type,\r\n" + 
				"                        accb.owning_org_id,\r\n" + 
				"                        accb.ifcountry,\r\n" + 
				"                        nvl(count(accb.dev_acc_id) * 100, 0) as inacc_num\r\n" + 
				"                   from gms_device_account_b accb\r\n" + 
				"                  where accb.bsflag = '0'\r\n" + 
				"                    and accb.account_stat = '0110000013000000003'\r\n" + 
				"                  group by accb.dev_type, accb.owning_org_id, accb.ifcountry) devb\r\n" + 
				"        on devb.dev_type = mp.dev_ci_code\r\n" + 
				"       and ga.ifcountry = devb.ifcountry\r\n" + 
				"       and ga.owning_org_id = devb.owning_org_id\r\n" + 
				"      left join gms_device_coll_account_tech gt\r\n" + 
				"        on gt.dev_acc_id = ga.dev_acc_id\r\n" + 
				"      left join gms_device_collectinfo ci\r\n" + 
				"        on ga.device_id = ci.device_id ";

		jdbcTemplate.execute(sqlString);
	}

	public int select() {

		String sqString = "select * from " + TABLE;

		List<Map> list = jdbcDao.queryRecords(sqString.toString());

		return list.size();
	}

}
