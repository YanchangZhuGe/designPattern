import java.io.File;
import java.io.UnsupportedEncodingException;
import java.util.regex.Matcher;

import com.cnpc.jcdp.util.AppCrypt;

/**   
 * @Title: Test.java
 * @Package 
 * @Description: TODO(��һ�仰�������ļ���ʲô)
 * @author wuhj 
 * @date 2014-4-21 ����7:35:29
 * @version V1.0   
 */
public class Test
{

	/**
	 * @throws UnsupportedEncodingException 
	 * @Title: main
	 * @Description: TODO(������һ�仰�����������������)
	 * @param @param args    �趨�ļ�
	 * @return void    ��������
	 * @throws
	 */
	public static void main(String[] args) throws UnsupportedEncodingException
	{ 
		// TODO Auto-generated method stub
//		String s = AppCrypt.decrypt("766C6BEDDE90663C");
//		String s1 = new String("装备意见改进完善工作安排".getBytes(),"UTF-8");
//		String s1 = "\\dsdfs.xls".replaceAll("/", Matcher.quoteReplacement(File.separator));/
		String s1 =  java.net.URLDecoder.decode("%E5%8F%B3%E8%84%91%CE%B1%E6%B3%A2%E9%9F%B3%E4%B9%901%EF%BC%88%E6%97%A5%E6%9C%AC%E5%88%B6%E4%BD%9C%EF%BC%89.mp3","utf-8");
		System.out.println(s1);

	}

}
