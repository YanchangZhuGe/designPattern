package com.cnpc.sais.web.inter.util;
import java.text.MessageFormat; 
import java.util.regex.*;

/** 
* 
* 通过正则表达式来实现字符串替换（2008-08-21） 
* 可以实现动态地赋值替换、可以实现对匹配值的部分替换。 
* 例子查看main()函数 
* @version 1.0  coolmasoft.com 
* @author coolma 
* 
* 
*/ 
@SuppressWarnings("unused")
public class RegularReplace 
{

    private String content; 
   
	private String regexp; 
    private String format; 
    Matcher m =null; 
    StringBuffer buf = new StringBuffer(); 
    MessageFormat fmt =null; 
    boolean b=false; 
    Object[] values=null; 
    int pointer=0; 
    public RegularReplace(String content,String regexp) 
    { 
        this(content,regexp,""); 
    } 
    public RegularReplace(String content,String regexp,String format) 
    { 
        this.content=content; 
        this.regexp=regexp; 
        this.format=format; 
        m=Pattern.compile(regexp).matcher(content); 
        fmt = new MessageFormat(format); 
        pointer=0; 
    } 
    public void reset() 
    { 
        m.reset(); 
        buf = new StringBuffer(); 
        pointer=0; 
    } 
    public String replaceAll(String newvalue) 
    { 
        return m.replaceAll(newvalue); 
    } 
    public String replaceAll(int group,String newvalue) 
    { 
        reset(); 
         while(find()) 
         { 
             setGroup(group,newvalue); 
             replace(); 
         } 
         return getResult(); 
    } 
    public boolean find() 
    { 
        boolean b= m.find(); 
        values=new Object[m.groupCount()+1]; 
        return b; 
    } 
    public void replace(Object[] obj) 
    {   
        // System.out.println(format); 
        replace( fmt.format(obj));// 
    } 
    public void replace(String s) 
    {     
        //m.appendReplacement(buf, s);// 
        buf.append( content.substring(pointer,m.start())); 
        buf.append(s ); 
        pointer=m.end(); 
    } 
    public int groupCount() 
    { 
      return m.groupCount(); 
    } 
    public String getGroup(int i){
    	return m.group(i);
    }
    public void setGroup(int i ,Object o) 
    { 
        values[i]=o; 
    } 
    public void replace() 
    { 
        //先排除重叠的group 
        for(int i=1;i< values.length;i++) 
        { 
            if(values[i]==null) continue; 
            int start=m.start(i); 
            for(int k=0;k<i;k++) 
            { 
                if(values[k]==null) continue; 
                if(start>=m.start(k)&& start<m.end(k)) 
                { 
                    values[i]=null; //设置为空，则不管这个group 
                    break; 
                } 
            } 
        } 
        for(int i=0;i< values.length;i++) 
        { 
            if(values[i]==null) continue; 
            int start=m.start(i); 
            int end= m.end(i-1) - m.end(i) == 2  ? m.end(i-1) : m.end(i);
            buf.append( content.substring(pointer,start)); 
            buf.append(values[i] ); 
            pointer=end; 
        } 
    } 
    public String getResult() 
    { 
        if(!b) 
        { 
            //m.appendTail(buf); 
            buf.append(content.substring(pointer)); 
            b=true; 
        } 
        return buf.toString(); 
    } 
}
