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
		buffer=new ByteArrayOutputStream();//真正存储数据的流
		out=new WapperedOutputStream(buffer);
		writer=new PrintWriter(new OutputStreamWriter(buffer,this.getCharacterEncoding()));
		contentType = resp.getContentType();
	}
	//重载父类获取outputstream的方法
	@Override
	public ServletOutputStream getOutputStream()throws IOException{
		return out;
	}
	//重载父类获取writer的方法
	@Override
	public PrintWriter getWriter() throws UnsupportedEncodingException{
		return writer;
	}
	//重载父类获取flushBuffer的方法
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
		//将out、writer中的数据强制输出到WapperedResponse的buffer里面，否则取不到数据
		flushBuffer();
		return buffer.toByteArray();
	}
	
	public String getContentType() {
		return contentType;
	}
	
	// 生成响应内容对应，用于缓存等操作
	public ResponseContent toResponseContent()throws IOException{
		ResponseContent c = new ResponseContent();
		c.setContentType(super.getContentType());
		c.setContent(getResponseData());
		return c;
	}
	
	//内部类，对ServletOutputStream进行包装
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
