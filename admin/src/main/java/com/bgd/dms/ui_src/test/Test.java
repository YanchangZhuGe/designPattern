package test;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONArray;

/**   
 * @Title: Test.java
 * @Package test
 * @Description: TODO(用一句话描述该文件做什么)
 * @author wuhj 
 * @date 2014-12-2 下午3:15:37
 * @version V1.0   
 */
abstract class Test
{

	/**
	 * @Title: main
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param args    设定文件
	 * @return void    返回类型
	 * @throws
	 */
	public static void main(String[] args)
	{
		// TODO Auto-generated method stub
		List ls = new ArrayList();
		ls.add("{ id:1, pId:0, name:'1', t:'id=1', open:true}");
		ls.add("{ id:11, pId:1, name:'12', t:'id=11'}");
		ls.add("{ id:12, pId:1, name:'13', t:'id=12'}");
		ls.add("{ id:13, pId:1, name:'14', t:'id=13'}");
		ls.add("{ id:2, pId:0, name:'2', t:'id=2', open:true}");
		ls.add("{ id:21, pId:2, name:'21', t:'id=21'}");
		ls.add("{ id:22, pId:2, name:'22', t:'id=22'}");
		ls.add("{ id:23, pId:2, name:'23', t:'id=23'}");
		ls.add("{ id:3, pId:0, name:'3', t:'id=3' }");
		ls.add("{ id:31, pId:3, name:'31', t:'id=31', open:true}");
		String s = JSONArray.fromCollection(ls).toString();
		System.out.println(s);
	}

}
