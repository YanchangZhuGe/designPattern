package com.bgp.dms.tempoQuartz;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

//������Ӧ���ݿ����
public class TempoZhzxDevMap {

	private static String TABLE = "tempo_zhzx_dev_map";

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
		String sqlString = tableName + "select t.xy_id,\r\n" + 
				"           t.org_type,\r\n" + 
				"           t.org_id,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.focus_x,\r\n" + 
				"           t.focus_y,\r\n" + 
				"           t.province,\r\n" + 
				"           s.org_abbreviation,\r\n" + 
				"           replace(s.short_name, '������˾', '') as short_name,\r\n" + 
				"           nvl(s.oa_paixv, 0) + 0 as oa_paixv\r\n" + 
				"      from pss_org_xy t\r\n" + 
				"      left join sys_organization s\r\n" + 
				"        on s.org_code = t.org_id\r\n" + 
				"     where t.org_type = '1'\r\n" + 
				"     order by nvl(s.oa_paixv, 0) + 0";

		jdbcTemplate.execute(sqlString);
	}

	public int select() {

		String sqString = "select * from " + TABLE;

		List<Map> list = jdbcDao.queryRecords(sqString.toString());

		return list.size();
	}

}
