package com.bgp.dms.tempoQuartz;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

//������Ӧ���ݿ����
public class TempoZhzxDevGlysZbWtc {

	private static String TABLE = "tempo_zhzx_dev_glys_zb_wtc";

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
		String sqlString = tableName + " select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_ndghyls t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_kgys t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_bygl t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_sbkq t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_drdj t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_yzjl t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_sbfh t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_sgys t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_zyczspj t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_tzsbgl t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_dzyqpk t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_dzyqsh t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_sbwx t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_sbjc t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_rcjc t\r\n" + 
				"    union all\r\n" + 
				"    select t.һ������Ҫ��,\r\n" + 
				"           t.��������Ҫ��,\r\n" + 
				"           t.org_code,\r\n" + 
				"           t.org_name,\r\n" + 
				"           t.score_value,\r\n" + 
				"           t.����\r\n" + 
				"      from v_glys_sbbfgl t";

		jdbcTemplate.execute(sqlString);
	}

	public int select() {

		String sqString = "select * from " + TABLE;

		List<Map> list = jdbcDao.queryRecords(sqString.toString());

		return list.size();
	}

}
