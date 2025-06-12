/**
 * STL模板请求参数
 */
package com.cnpc.jcdp.web.rad.util;

import com.cnpc.jcdp.cfg.ConfigHandler;

/**
 * @author rechete
 *
 */
public class PMDRequest {
	private String reqType;//QueryList,Add,Modify
	private String style;//模板风格
	private String fileName;//模板文件
	private String pagerAction;//edit2View
	private ConfigHandler tlHd;
	private String tptId;//模板id
	

	public String getTptId() {
		return tptId;
	}
	public void setTptId(String tptId) {
		this.tptId = tptId;
	}
	public String getReqType() {
		return reqType;
	}
	public void setReqType(String reqType) {
		this.reqType = reqType;
	}
	public String getStyle() {
		return style;
	}
	public void setStyle(String style) {
		this.style = style;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public ConfigHandler getTlHd() {
		return tlHd;
	}
	public void setTlHd(ConfigHandler tlHd) {
		this.tlHd = tlHd;
	}
	public String getPagerAction() {
		return pagerAction;
	}
	public void setPagerAction(String pagerAction) {
		this.pagerAction = pagerAction;
	}
}
