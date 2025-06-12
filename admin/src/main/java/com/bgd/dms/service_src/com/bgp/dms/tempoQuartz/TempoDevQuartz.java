package com.bgp.dms.tempoQuartz;

public class TempoDevQuartz {

	// 定时抽取设备数据
	public void insert() {
		// 类名对应数据库表名
		
		//指挥中心_设备_管理要素_公司
		TempoZhzxDevGlysGs tempoZhzxDevGlysGs = new TempoZhzxDevGlysGs();
		tempoZhzxDevGlysGs.insert();
		
		//指挥中心_设备_管理要素_装备服务处
		TempoZhzxDevGlysZb tempoZhzxDevGlysZb = new TempoZhzxDevGlysZb();
		tempoZhzxDevGlysZb.insert();
		
		//指挥中心_设备_管理要素_公司_物探处
		TempoZhzxDevGlysGsWtc tempoZhzxDevGlysGsWtc = new TempoZhzxDevGlysGsWtc();
		tempoZhzxDevGlysGsWtc.insert();
		
		//指挥中心_设备_管理要素_装备_物探处
		TempoZhzxDevGlysZbWtc tempoZhzxDevGlysZbWtc = new TempoZhzxDevGlysZbWtc();
		tempoZhzxDevGlysZbWtc.insert();
		
		//指挥中心_设备_设备利用率
		TempoZhzxDevLyl tempoZhzxDevLyl = new TempoZhzxDevLyl();
		tempoZhzxDevLyl.insert();
		
		//指挥中心_设备_设备完好率
		TempoZhzxDevWhl tempoZhzxDevWhl = new TempoZhzxDevWhl();
		tempoZhzxDevWhl.insert();
		
		//指挥中心_设备_地图
		TempoZhzxDevMap tempoZhzxDevMap = new TempoZhzxDevMap();
		tempoZhzxDevMap.insert();
		
		//指挥中心_设备_台账
		TempoZhzxDevTz tempoZhzxDevTz = new TempoZhzxDevTz();
		tempoZhzxDevTz.insert();
		
		//指挥中心_设备_地震仪器
		TempoZhzxDevDzyq tempoZhzxDevDzyq = new TempoZhzxDevDzyq();
		tempoZhzxDevDzyq.insert();
		
		//指挥中心_设备_检波器
		TempoZhzxDevJbq tempoZhzxDevJbq = new TempoZhzxDevJbq();
		tempoZhzxDevJbq.insert();

		//指挥中心_设备_设备处置
		TempoZhzxDevShcz tempoZhzxDevShcz = new TempoZhzxDevShcz();
		tempoZhzxDevShcz.insert();
	}
}
