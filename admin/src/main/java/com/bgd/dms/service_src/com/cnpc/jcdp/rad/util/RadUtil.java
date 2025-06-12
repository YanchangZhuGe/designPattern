/**
 * 
 */
package com.cnpc.jcdp.rad.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.jms.JMSException;
import javax.jms.ObjectMessage;

import net.sf.json.JSONObject;

import com.cnpc.jcdp.cache.JcdpObjPool;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.mq.JcdpMQUtil;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.webapp.util.MVCConstants.MVCConfig;
import com.cnpc.sais.cbc.code.IBusiEncoder;;

/**
 * @author rechete
 *
 */
public class RadUtil {
	private static IBusiEncoder encoder;
	
	private static synchronized IBusiEncoder getBusiEncoder()throws Exception{
		if(encoder==null){
			encoder = (IBusiEncoder)Class.forName("com.cnpc.sais.cbc.code.util.BusiEncodeUtil").newInstance();
		}
		return encoder;
	}

	public static void main(String[] args)throws Exception{
		String sql = "DELETE FROM TABLE WHERE A='{id}' AND C=1";
		Pattern pattern = Pattern.compile("\\u007Bid}");
		Matcher matcher = pattern.matcher(sql);
		sql = sql.replaceAll("\\u007Bid}", "9");
		System.out.println(sql);
	}
	
	/**
	 * Ajax提交时，对汉字转码(页面提交前需先encode两次)
	 * 对于自动编码的，用编码值替换
	 * @param params
	 * @throws UnsupportedEncodingException
	 */
	public static void decodeParams(Map params)throws Exception{
		Object[] keys = params.keySet().toArray();
		for(int i=0;i<params.size();i++){
			Object obj = params.get(keys[i]);
			if(obj!=null){
				String value = obj.toString();		
				if(value.indexOf("+")>=0) value = value.replace("+","%2B");
				if(value.indexOf("%")>=0) value = URLDecoder.decode(value,"UTF-8");		
				if(value.startsWith("[SAIS_AUTOCODE]"))
					value = getBusiEncoder().getNextCode(value.substring(15));
				params.put(keys[i],value );
			}			
		}			
	}
	
	
	public static void fillFileParam(Map fileParam,WSFile file){
		byte[] b = file.getFileData();
		fileParam.put("file_content",b);
		fileParam.put("file_name", file.getFilename());
		fileParam.put("file_size", file.getFilesize());			
	}
}
