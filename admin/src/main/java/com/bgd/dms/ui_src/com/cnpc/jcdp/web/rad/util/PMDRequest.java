/**
 * STLģ���������
 */
package com.cnpc.jcdp.web.rad.util;

import com.cnpc.jcdp.cfg.ConfigHandler;

/**
 * @author rechete
 *
 */
public class PMDRequest {
	private String reqType;//QueryList,Add,Modify
	private String style;//ģ����
	private String fileName;//ģ���ļ�
	private String pagerAction;//edit2View
	private ConfigHandler tlHd;
	private String tptId;//ģ��id
	

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
