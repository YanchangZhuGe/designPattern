package com.bgp.dms.tempoQuartz;

public class TempoDevQuartz {

	// ��ʱ��ȡ�豸����
	public void insert() {
		// ������Ӧ���ݿ����
		
		//ָ������_�豸_����Ҫ��_��˾
		TempoZhzxDevGlysGs tempoZhzxDevGlysGs = new TempoZhzxDevGlysGs();
		tempoZhzxDevGlysGs.insert();
		
		//ָ������_�豸_����Ҫ��_װ������
		TempoZhzxDevGlysZb tempoZhzxDevGlysZb = new TempoZhzxDevGlysZb();
		tempoZhzxDevGlysZb.insert();
		
		//ָ������_�豸_����Ҫ��_��˾_��̽��
		TempoZhzxDevGlysGsWtc tempoZhzxDevGlysGsWtc = new TempoZhzxDevGlysGsWtc();
		tempoZhzxDevGlysGsWtc.insert();
		
		//ָ������_�豸_����Ҫ��_װ��_��̽��
		TempoZhzxDevGlysZbWtc tempoZhzxDevGlysZbWtc = new TempoZhzxDevGlysZbWtc();
		tempoZhzxDevGlysZbWtc.insert();
		
		//ָ������_�豸_�豸������
		TempoZhzxDevLyl tempoZhzxDevLyl = new TempoZhzxDevLyl();
		tempoZhzxDevLyl.insert();
		
		//ָ������_�豸_�豸�����
		TempoZhzxDevWhl tempoZhzxDevWhl = new TempoZhzxDevWhl();
		tempoZhzxDevWhl.insert();
		
		//ָ������_�豸_��ͼ
		TempoZhzxDevMap tempoZhzxDevMap = new TempoZhzxDevMap();
		tempoZhzxDevMap.insert();
		
		//ָ������_�豸_̨��
		TempoZhzxDevTz tempoZhzxDevTz = new TempoZhzxDevTz();
		tempoZhzxDevTz.insert();
		
		//ָ������_�豸_��������
		TempoZhzxDevDzyq tempoZhzxDevDzyq = new TempoZhzxDevDzyq();
		tempoZhzxDevDzyq.insert();
		
		//ָ������_�豸_�첨��
		TempoZhzxDevJbq tempoZhzxDevJbq = new TempoZhzxDevJbq();
		tempoZhzxDevJbq.insert();

		//ָ������_�豸_�豸����
		TempoZhzxDevShcz tempoZhzxDevShcz = new TempoZhzxDevShcz();
		tempoZhzxDevShcz.insert();
	}
}
