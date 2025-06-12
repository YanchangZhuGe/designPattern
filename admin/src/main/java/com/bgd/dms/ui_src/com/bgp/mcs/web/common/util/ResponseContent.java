package com.bgp.mcs.web.common.util;

import java.io.Serializable;

public class ResponseContent implements Serializable {

	private String contentType;
	private byte[] content;
	public ResponseContent(String contentType, byte[] content) {
		super();
		this.contentType = contentType;
		this.content = content;
	}
	public ResponseContent() {
		super();
	}
	public String getContentType() {
		return contentType;
	}
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	public byte[] getContent() {
		return content;
	}
	public void setContent(byte[] content) {
		this.content = content;
	}
	
}
