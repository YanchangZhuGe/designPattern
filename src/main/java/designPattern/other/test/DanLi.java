package designPattern.other.test;

import org.springframework.util.StringUtils;


/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/9 16:39
 */

 class DanLi {

    /**
     * Class String is special cased within the Serialization Stream Protocol.
     *
     * A String instance is written into an ObjectOutputStream according to
     * <a href="{@docRoot}/../platform/serialization/spec/output.html">
     * Object Serialization Specification, Section 6.2, "Stream Elements"</a>
     */
    //编写用来解题的方法
    /**
     * Class String is special cased within the Serialization Stream Protocol.
     *
     * A String instance is written into an ObjectOutputStream according to
     * <a href="D:/Program Files/Java/jdk1.8.0_281/docs/api/../platform/serialization/spec/output.html">
     * Object Serialization Specification, Section 6.2, "Stream Elements"</a>
     */
    public static String compress(String s){
        String result = "";
        if (StringUtils.isEmpty(s)){
            result ="你输入为空!";
        }else if (s.contains(" ")){
            result ="请不要输入空格!";
        }else {
            int length = s.length();
            System.out.println("length: "+length);
            int count  = 0;

            for (int i= 1;i<=length;i++){
                String[] strings1 = s.split(s.substring(0,i));
                if (strings1.length==0){
                    System.out.println("切分到"+i);
                    count = i;
                    break;
                }

            }
            result = length/count + s.substring(0,count);
        }

        return result;
    }
}

class Test1 {
    public static void main(String[] args) {
        String s = "aaaaaa";
        String result = "";
        System.out.println(result);
    }
}
