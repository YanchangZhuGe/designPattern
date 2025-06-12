package com.bgp.gms.service.rm.dm;

import com.cnpc.jcdp.soa.msg.ISrvMsg;

/**
 * �豸��ؽӿڷ���
 */
public interface IWtcDevSrv {
		/**
		 * �������е�̨�豸���첨���豸����gms_device_mixinfo_form
		 * @param msg
		 * @param devType �豸���ͣ�DT:��̨ JBQ���첨�� COLL:��������
		 * @return  ���ص��䵥����
		 */
		public String saveDevMixForm(ISrvMsg msg,String devType)throws Exception;
		/**
		 * �������ⵥ̨���첨���豸����gms_device_hireapp
		 * @param msg
		 * @param 
		 * @return  ���������豸��������
		 */
		public String saveHireDevApp(ISrvMsg msg)throws Exception;
		/**
		 * �豸��ͣ�ƻ�����gms_device_osapp
		 * @param msg
		 * @param 
		 * @return  �����Ǳ���ͣ�ƻ�������
		 */
		public String saveDevOsApp(ISrvMsg msg)throws Exception;
		/**
		 * �豸ת�Ʊ���gms_device_move
		 * @param msg
		 * @param dcFlag �豸���ͣ�DT:��̨ COLL������
		 * @return  ����ת�Ƶ�������
		 */
		public String saveMovDevApp(ISrvMsg msg,String dcFlag)throws Exception;
		/**
		 * �豸������̨����gms_device_backapp
		 * @param msg
		 * @param 
		 * @return  �����豸������������
		 */
		public String saveBackDevApp(ISrvMsg msg)throws Exception;
		/**
		 * ���������豸����
		 * @param msg
		 * @param
		 * @return  �ɹ����ؿ�ֵ��ʧ�ܷ��ش�����
		 */
		public String saveDevArchive(ISrvMsg msg)throws Exception;
		/**
		 * ������Ŀת��ʽ��Ŀ�����޸��豸������Ŀ���
		 * @param msg
		 * @param
		 * @return  �ɹ����ؿ�ֵ��ʧ�ܷ��ش�����
		 */
		public String saveVirProDevArchive(ISrvMsg msg)throws Exception;
		/**
		 * ������Ŀת��ʽ��Ŀ�ж��豸�Ƿ�ȫ��ת��
		 * @param outProjectNo ת����Ŀ���
		 * @param
		 * @return  �ɹ�����true��ʧ�ܷ���flase
		 */
		public boolean opVirProDev(String outProjectNo)throws Exception;
		/**
		 * �������ⵥ̨�������������첨���豸����gms_device_hireapp
		 * @param msg
		 * @param 
		 * @return  ���������豸��������
		 */
		public String saveHireDevAppNew(ISrvMsg msg)throws Exception;
}
