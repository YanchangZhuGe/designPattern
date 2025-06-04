package com.bgp.dms.assess.IServ;

import java.util.List;
import java.util.Map;

import com.bgp.dms.assess.model.AssessBorad;
import com.bgp.dms.assess.model.AssessInfo;

/**
 * ������������ά���ӿڶ���
 * 
 * @author ������
 * 
 */
public interface IAssessNodeServ {
	public Map<String, Object> findHeadByID(String headID);
	public AssessBorad createBoradBySheetID(String sheetID);
	public AssessInfo findAssessBySheetID(AssessInfo assessInfo);
	/**
	 * ������������
	 * 
	 * @param assessInfo
	 *            ��������
	 */
	public void saveAssess(AssessInfo assessInfo);

	/**
	 * ���¿�������
	 * 
	 * @param assessInfo
	 *            ��������
	 */
	public void updateAssess(AssessInfo assessInfo);

	/**
	 * �߼�ɾ����������
	 * ��ͬʱ�߼�ɾ�����ӽڵ�
	 * @param assessInfoID
	 *            �������ݱ��
	 */
	public void deleteAssesById(String assessInfoID);

	/**
	 * ��ѯ��������
	 * �����Ҵ˽ڵ���ϼ��ڵ㼯�ϡ��¼��ڵ㼯��
	 * @return
	 */
	public AssessInfo findAssessByID(String assessInfoID);

	/**
	 * ���ݸ��ڵ��ѯ�¼��������ݽڵ㼯
	 * 
	 * @param superiorID
	 * @return
	 */
	public List<AssessInfo> findChildAssessListByID(String assessInfoID);
	public List<AssessInfo> findChildAssessListByName(String assessName);

	/**
	 * ��ѯ�¼��������ݽڵ㼯
	 * 
	 * @param superiorID
	 *            �ϼ��������ݱ��
	 * @return
	 */
	public List<AssessInfo> findLeafListBySuperiorID(String superiorID);

	/**
	 * ��ѯģ���Ӧ��Ҷ�����˽ڵ㼯��
	 * 
	 * @param templateId
	 *            ģ����
	 * @return
	 */
	public List<AssessInfo> findLeafListByTemplateId(String templateID);

	/**
	 * ��ѯ���п��˸��ڵ�
	 * 
	 * @return
	 */
	public List<AssessInfo> findRootList();

	/**
	 * �ж��Ƿ�ΪҶ���ڵ�
	 * 
	 * @param assessInfo
	 * @return
	 */
	public boolean checkIsLeaf(AssessInfo assessInfo);

	/**
	 * �ж��Ƿ�Ϊ�����ڵ�
	 * 
	 * @param assessInfo
	 * @return
	 */
	public boolean checkIsRoot(AssessInfo assessInfo);

	/**
	 * �ж��Ƿ�Ϊ������ͷ���
	 * 
	 * @param assessInfo
	 * @return
	 */
	public boolean checkIsRowHeader(AssessInfo assessInfo);

	/**
	 * �ж��Ƿ�Ϊexcelά�ȵ�������ͷ���
	 * 
	 * @param assessInfo
	 * @return
	 */
	public boolean checkIsColHeader(AssessInfo assessInfo);

	/**
	 * �ж��Ƿ�Ϊexcelά�ȵ�sheet���ڵ�
	 * 
	 * @param assessInfo
	 * @return
	 */
	public boolean checkIsSheetHeader(AssessInfo assessInfo);

	/**
	 * ��ѯ��Ŀ¼������excelά�ȵ�sheet�ڵ㼯��
	 * 
	 * @param rootID
	 * @return
	 */
	public List<AssessInfo> getSheetListByRootID(String rootID);

	/**
	 * ���ɿ��˽ڵ���
	 * 
	 * @param assessInfo
	 * @return
	 */
	public String createAssessNodeCode(List<AssessInfo> superiorNodes, int nodeLevel);

	/**
	 * ��ȡexcelά�ȵ��������ϼ�Ŀ¼
	 * 
	 * @param assessInfoID
	 * @return
	 */
	public AssessInfo findSuperiorRowHeaderInfoByID(String assessInfoID);

	/**
	 * �ж��Ƿ����excelά�ȵ��������ϼ�Ŀ¼
	 * 
	 * @param assessInfoID
	 * @return
	 */
	public boolean isExistSuperiorRowHeaderInfoByID(String assessInfoID);

	/**
	 * ��ȡexcelά�ȵ��������ϼ�Ŀ¼
	 * 
	 * @param assessInfoID
	 * @return
	 */
	public AssessInfo findSuperiorColHeaderInfoByID(String assessInfoID);

	/**
	 * �ж��Ƿ����excelά�ȵ��������ϼ�Ŀ¼
	 * 
	 * @param assessInfoID
	 * @return
	 */
	public boolean isExistSuperiorColHeaderInfoByID(String assessInfoID);

	/**
	 * �����˽ڵ����Ʋ�ѯ���˽ڵ�
	 * 
	 * @param assessInfoName
	 * @param level TODO
	 * @return
	 */
	public AssessInfo findAssessByName(String assessInfoName, int level);

	/**
	 * Ҷ���ڵ�����¼�Ŀ¼�󣬾ͱ�Ϊ֧���ڵ�
	 * 
	 * @param assessInfoID
	 */
	public void changeLeafToBranch(String assessInfoID);

	/**
	 * ֧���ڵ�������Ҷ���ڵ�ɾ���󣬾ͱ����Ҷ���ڵ�
	 * 
	 * @param assessInfoID
	 */
	public void changeBranchToLeaf(String assessInfoID);

	/**
	 * ���ݸ��ڵ���Ҹ����ڵ�
	 * 
	 * @param rootID
	 * @return
	 */
	public AssessInfo findRootAssess(String rootID);

	/**
	 * ��������sheet���ڵ㣬��nodetypesΪ s �ڵ�
	 * 
	 * @return
	 */
	public List<AssessInfo> findAllSheetList();

	/**
	 * ���ݸ����ڵ�id���Ҵ˸����ڵ�������sheet���ڵ�
	 * 
	 * @param rootID
	 * @return
	 */
	public List<AssessInfo> findAllSheetListByRootID(String rootID);

	/**
	 * ����sheet���ڵ���Ҹ�sheet���ڵ�������������ͷ�ڵ�
	 * 
	 * @param sheetID
	 * @return
	 */
	public List<AssessInfo> findAllColHeadListBysheetID(String sheetID);

	/**
	 * ����sheet���ڵ���Ҹ�sheet���ڵ�������������ͷ�ڵ�
	 * 
	 * @param sheetID
	 * @return
	 */
	public List<AssessInfo> findAllRowHeadListBysheetID(String sheetID);

	/**
	 * ����sheet���ڵ���Ҹ�sheet���ڵ�
	 * 
	 * @param sheetID
	 * @return
	 */
	public AssessInfo findSheetAssessByID(String sheetID);

	public AssessInfo findColHeaderByID(String colHeaderID);

	public AssessInfo findRowHeaderByID(String rowHeaderID);

	/**
	 * �����м���Ӧ��ϵ�����Ҹ��ڵ�����
	 * @param assessInfoID
	 * @return
	 */
	public List<AssessInfo> findSuperiorAssessInfosByID(String assessInfoID);
	/**
	 * �����м���Ӧ��ϵ�����Ҹ��ڵ�����
	 * @param assessInfoID
	 * @return
	 */
	public List<AssessInfo> findSuperiorAssessInfosByName(String assessInfoID);
	/**
	 * �������ڵ����
	 * @return
	 */
	public String createRootNodeCode();
	public List findContentByLineID(String lineID);
}