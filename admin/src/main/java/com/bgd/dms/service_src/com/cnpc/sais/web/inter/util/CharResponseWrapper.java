package com.cnpc.sais.web.inter.util;

import java.io.CharArrayWriter;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

public class CharResponseWrapper extends HttpServletResponseWrapper {

	private CharArrayWriter output;

    public String toString(){
    	String reback = output.toString();
    	output.close();
       return reback;
    }

    public CharResponseWrapper(HttpServletResponse response){
      super(response);
      output=new CharArrayWriter();
    }

    public PrintWriter getWriter(){
      return new PrintWriter(output);
    }
    
    public void close(){
    	output.close();
    }
	
}
