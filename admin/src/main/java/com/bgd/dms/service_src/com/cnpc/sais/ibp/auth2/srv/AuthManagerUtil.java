package com.cnpc.sais.ibp.auth2.srv;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.cnpc.jcdp.common.TreeNodeData;
import com.cnpc.sais.ibp.auth.pojo.PAuthMenu;

@SuppressWarnings("unchecked")
public class AuthManagerUtil {
	public static TreeNodeData getNodeFromPAuthMenu(PAuthMenu menu,String charset){
		TreeNodeData node = new TreeNodeData();
		node.setName(menu.getMenuCName());
		node.setId(menu.getMenuId());
		node.setUrl(menu.getMenuUrl());
		node.setIsLeaf(menu.getIsLeaf());
		if("1".equals(node.getIsLeaf())){
			String url = node.getUrl();
			if(url==null || url.trim().equals(""))
				node.setUrl("../blank.htm");
			else{
				if(url.startsWith(".")) url = url.substring(1);
				if(url.startsWith("/")) url = url.substring(1);
				url = "../"+url;
				node.setUrl(url);
			}
		}		
		node.setHint(menu.getMenuHint());
		node.setImgUrl(menu.getImgUrl());
		return node;
	}
	public static  String  format(String s  , Object... objs){
		Pattern p  = Pattern.compile("\\{(\\d+)\\}");
		Matcher m = p.matcher(s);
		int length = objs.length;
		while(m.find()){
			int index = Integer.parseInt(m.group(m.groupCount()));
			if(index < length)
				s = s.replace(m.group(), objs[index].toString());
		}
		return s;
	} 

	public static  <T> T trim2Default(String s , T t){
		s = StringUtils.trimToEmpty(s);
		if("".equals(s)){
			return t;
		}else{
			return (T) s;
		}
	}
}
