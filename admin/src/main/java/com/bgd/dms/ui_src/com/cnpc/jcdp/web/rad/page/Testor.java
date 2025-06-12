/**
 * 
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;

/**
 * @author Administrator
 *
 */
public class Testor {

	/**
	 * @param args
	 */
	public static void main(String[] args)throws Exception{
		// TODO Auto-generated method stub
		String exp = "<a href=javascript:popWindow('editFunc.pmd?id={func_id}')>{func_code}</a>";
		exp = exp.replaceAll("popWindow\\u0028'", "link2self("+"/");
		System.out.println(exp);
	}

}
