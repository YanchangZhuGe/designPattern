package com.bgp.mcs.web.common.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

public class ResponseWrapper extends HttpServletResponseWrapper {

	private ByteArrayOutputStream buffer=null;
	private ServletOutputStream out=null;
	private PrintWriter writer=null;
	private String contentType=null;
	
	public ResponseWrapper(HttpServletResponse resp) throws IOException{
		super(resp);
		buffer=new ByteArrayOutputStream();//�����洢���ݵ���
		out=new WapperedOutputStream(buffer);
		writer=new PrintWriter(new OutputStreamWriter(buffer,this.getCharacterEncoding()));
		contentType = resp.getContentType();
	}
	//���ظ����ȡoutputstream�ķ���
	@Override
	public ServletOutputStream getOutputStream()throws IOException{
		return out;
	}
	//���ظ����ȡwriter�ķ���
	@Override
	public PrintWriter getWriter() throws UnsupportedEncodingException{
		return writer;
	}
	//���ظ����ȡflushBuffer�ķ���
	@Override
	public void flushBuffer()throws IOException{
		if(out!=null){
			out.flush();
		}
		if(writer!=null){
			writer.flush();
		}
	}
	@Override
	public void reset(){
		buffer.reset();
	}
	public byte[] getResponseData()throws IOException{
		//��out��writer�е�����ǿ�������WapperedResponse��buffer���棬����ȡ��������
		flushBuffer();
		return buffer.toByteArray();
	}
	
	public String getContentType() {
		return contentType;
	}
	
	// ������Ӧ���ݶ�Ӧ�����ڻ���Ȳ���
	public ResponseContent toResponseContent()throws IOException{
		ResponseContent c = new ResponseContent();
		c.setContentType(super.getContentType());
		c.setContent(getResponseData());
		return c;
	}
	
	//�ڲ��࣬��ServletOutputStream���а�װ
	private class WapperedOutputStream extends ServletOutputStream{
		private ByteArrayOutputStream bos=null;
		public WapperedOutputStream(ByteArrayOutputStream stream) throws IOException{
			bos=stream;
		}
		@Override
		public void write(int b) throws IOException{
			bos.write(b);
		}
	}
}
