package com.bgp.gms.service.rm.dm.util;

import java.util.List;
import java.util.Map;

/**
 * hessian service�ӿ���
 * @author liyongfeng
 *
 */
public interface DevRFIDWebSrv {

	public String testSvr(String name);
	public String testMap(Map<String,Object> m);
	
	/**
	 * �ն˵�¼service
	 * @param username ��¼�û���
	 * @param password ��¼����
	 * @return �����û����������Ϣ
	 */
	public UserInfo clientLogin(String username,String password);
	
	/**
	 * ����豸����ӳ���ϵ
	 * @return �����豸������sap�豸����ӳ��ù�ϵ�����ݣ������ն��������ͱ������
	 */
	public List<DevTypeMapping> getDevTypeMapping();
	
	/**
	 * ���ɵ�ǰ�����豸̨������ѹ���ļ����������ļ�������ɺ���Ҫ����deleteDevAccountDataFile�������������ļ�ɾ��
	 * @return ���ɵ�ѹ���ļ����ƣ��磺123.zip������ʱ��Ҫ��Ӧ��url�����/rm/dm/rfidData���磺http://localhost/gms3/rm/dm/rfidData/123.zip
	 */
	public String createDevAccountDataFile();
	
	/**
	 * �����ļ���ɾ�����ɵ�ѹ���ļ�
	 * @param filename ѹ���ļ����ƣ��磺123.zip
	 */
	public void deleteDevAccountDataFile(String filename);
	
	/**
	 * ����ָ���ֿ�ĳ��ⵥ��״̬Ϊδ��ɵĳ��ⵥ
	 * @param orgid ����ֿ�id
	 * @return ���ⵥ
	 */
	public List<RFIDDevOutFormDTO> downloadOutForm(String orgid);
	
	/**
	 * ���ݳ��ⵥid���س��ⵥ�ӱ�����
	 * @param outformid ���ⵥid
	 * @return ���ⵥ�ӱ�����
	 */
	public List<RFIDDevOutFormSub> downloadOutFormSub(String outformid);
	
	/**
	 * ���ݳ��ⵥid���ܳ��ⵥ��̨��ϸ����
	 * @param outformid ���ⵥid
	 * @return ���ⵥ��̨��ϸ����
	 */
	public List<RFIDDevOutFormSubDetail> downloadOutFormSubDetail(String outformid);
	
	/**
	 * �ϴ����ⵥ��ϸ����
	 * @param outFormId ���ⵥID
	 * @param detailData ���ⵥ��ϸ
	 * @return {uploadsum(�ϴ�����):10,successsum(�ɹ����ղ��������):8,errorsum(δ�ɹ����������������ظ���):2,'�ɼ�վFDU/WP 428'(���ⵥ�ӱ��еĳ����豸��������):'8|2'(�����|����)}
	 */
	public Map<String,Object> uploadOutDetail(String outFormId,List<RFIDDevOut> detailData,String userid);
	
	/**
	 * �ϴ�RFID���豸�İ�����
	 * @param data
	 * @return
	 */
	public Map<String,Object> uploadRFIDBind(List<RFIDBind> data,String orgid);
	
	/**
	 * �������ڻ���������ⵥ����
	 * @param orgid
	 * @return
	 */
	public List<RFIDDevInFormDTO> downloadInForm(String orgid);
	
	/**
	 * ������ⵥ�ӱ�����
	 * @param inFormId ��ⵥ����id
	 * @return
	 */
	public List<RFIDDevInFormSub> downloadInFormSub(String inFormId);
	
	/**
	 * ������ⵥ��ϸ�豸����
	 * @param inFormId ��ⵥid
	 * @return
	 */
	public List<RFIDDevInFormSubDetail> downloadInFormSubDetail(String inFormId);
	
	/**
	 * �ϴ���ⵥ��ϸ����
	 * @param outFormId ��ⵥID
	 * @param detailData ��ⵥ��ϸ
	 * @return {flag:0/1,msg:��ʾ��Ϣ,uploadsum(�ϴ�����):10,successsum(�ɹ����ղ��������):8,errorsum(δ�ɹ����������������ظ���):2,'�ɼ�վFDU/WP 428'(��ⵥ�ӱ��еĳ����豸��������):'8|2'(�����|����)}
	 */
	public Map<String,Object> uploadInDetail(String inFormId,List<RFIDDevIn> detailData,String userid);
	
	/**
	 * �����ֵ����ͻ�ÿ�ʹ�õ��ֵ�����
	 * @param enumType �ֵ�����
	 * @return
	 */
	public List<EnumEntity> downloadEnum(String enumType);
	
	/**
	 * ����orgid��������ά�޵�   �������޵�λ  liug  union �Ѿ������˵�����ά�޵�
	 * @param orgid �������id(���ұ���״̬�����޵� ������)
	 * @return
	 */
	public List<GmsDeviceCollRepairSend> downloadVendorRepairForm(String orgid);
	
	/**
	 * ����orgid��������ά�޵�  �������޵�λ  liug  union �Ѿ������˵�����ά�޵�
	 * @param orgid �������id
	 * @return
	 */
	public List<GmsDeviceCollRepairform> downloadSelfRepairForm(String orgid);
	
	/**
	 * ����ά�޵�����������ά�޵�   �������޵�λ  liug  union �Ѿ������˵�����ά�޵�
	 * @param rtnid ά�޷�����ID
	 * @return
	 */
	public List<GmsDeviceCollRepairSend> downloadVendorRepairFormByRtnId(String rtnid);
	
	/**
	 * ����ά�޵�����������ά�޵�  �������޵�λ  liug  union �Ѿ������˵�����ά�޵�
	 * @param rtnid ά�޷�����ID
	 * @return
	 */
	public List<GmsDeviceCollRepairform> downloadSelfRepairFormByRtnId(String rtnid);
	
	/**
	 * ����orgid����ά�޷�����  
	 * @param ogrid ���ջ���id
	 * @return   //�������޵�λ ����ά�޷�����
	 */
	public List<GmsDeviceDolRepForm> downloadReturnRepairForm(String ogrid);
	
	/**
	 * �ϴ�����ά�޵���ϸ����
	 * @param formId ά�޵�id
	 * @param data ��ϸ����
	 * @return {'flag':'0/1','msg':'������ʾ��Ϣ',uploadsum(�ϴ�����):10,successsum(�ɹ����ղ��������):8,errorsum(δ�ɹ����������������ظ���):2}
	 */
	public Map<String,Object> uploadVendorRepairFormDetail(String formId,List<GmsDeviceCollSendSub> data);
	
	/**
	 * �ϴ�����ά�޵���ϸ����
	 * @param formId ά�޵�id
	 * @param data ��ϸ����
	 * @return {'flag':'0/1','msg':'������ʾ��Ϣ',uploadsum(�ϴ�����):10,successsum(�ɹ����ղ��������):8,errorsum(δ�ɹ����������������ظ���):2}
	 */
	public Map<String,Object> uploadSelfRepairFormDetail(String formId,List<GmsDeviceCollRepairSub> data);
	
	/**
	 * �ϴ�ά�޷�����ϸ����
	 * @param formId ������ID
	 * @return {'flag':'0/1','msg':'������ʾ��Ϣ',uploadsum(�ϴ�����):10,successsum(�ɹ����ղ��������):8,errorsum(δ�ɹ����������������ظ���):2}
	 */
	public Map<String,Object> uploadReturnRepairFormDetail(String formId,List<GmsDeviceColRepDetail> data);
	
	/**
	 * ����id��������ά�޵� ��ϸ
	 * @param ά�޵�id
	 * @return
	 */
	public List<GmsDeviceCollSendSub> downloadVendorRepairFormSub(String id);
	
	/**
	 * ����id��������ά�޵� ��ϸ
	 * @param id ά�޵�id
	 * @return
	 */
	public List<GmsDeviceCollRepairSub> downloadSelfRepairFormSub(String id);
	
	/**
	 * ����id����ά�޷����� ��ϸ
	 * @param id ������id
	 * @return   
	 */
	public List<GmsDeviceColRepDetail> downloadReturnRepairFormSub(String id);
	
	/**
	 * ��÷�������ǰʱ��
	 * @return 2014-8-24 17:30:51
	 */
	public String getServerTime();
}
