/**
 * 
 */
package com.cnpc.jcdp.web.rad.util;

/**
 * @author rechete
 *
 */
public class RADConst {
	public static String WEB_ROOT = "";
	
	public static int DEFAULT_MEMO_ROWS = 2;
	public static int DEFAULT_MEMO_COLS = 40;
	public static int POP_WINDOW_HEIGHT = 400;
	
	/**
	 * �б��ѯҳ�����ҳ��ķ�ʽ���������ڣ���ҳ��ת
	 */	
	public enum PAGER_OPEN_TYPE{
		POP,LINK;
	}
	
	/**
	 * �б��ѯҳ��Ĳ�ѯ������ʽ:����������
	 */
	public enum QUERY_CDT_TYPE{
		FORM,SELECT;
	}	
	
	/**
	 * ��¼ѡ������:����ѡ��radiobutton������ѡ��checkbox
	 */
	public enum RECORD_SEL_TYPE{
		RadioButton,Checkbox;
	}	
	
	//�б�����:��ͨ�б���ϵѡ���б����ѡ���б����ӱ�1���ӱ��б�
	public enum LISTTYPE  {List2View,List2Sel,List2Link,List2Compose};
	

	
	public interface TitleType{
		public final int TAB = 0;//��ǩ��
		public final int Hint = 1;//��ʾ��
		public final int SUB_Hint = 2;//��ϸ��
	}
	
	public interface PMDAction{
		//�Ե���ĵ�CRU
		public final String S_C = "S_C";
		public final String S_U = "S_U";
		public final String S_R = "S_R";
		//���ӱ���ͬһҳ���CRU
		public final String C_C = "C_C";
		public final String C_U = "C_U";
		public final String C_R = "C_R";	
		//���ӱ�1
		public final String M_S = "M_S";
		//��ѡҳ��
		public final String L2S = "L2S";
		//��ѡҳ��for�������
		public final String L2L = "L2L";
	}	
}
