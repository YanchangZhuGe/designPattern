package com.cnpc.jcdp.web.rad.util;

import org.apache.commons.lang.StringUtils;
import org.jsoup.nodes.Element;
import org.jsoup.parser.Tag;

public class DocUtil {
	public static Element createScriptEm(String src){
		Element script = new Element(Tag.valueOf("script"),"");
		script.attr("type", "text/javascript");
		if(StringUtils.isNotEmpty(src)){
			script.attr("src", src);
		}
		return script;
	}
}
