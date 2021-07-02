package designPattern.other.jdk8;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/2 14:51
 */

public class js {
    public static void main(String args[]) {

        ScriptEngineManager scriptEngineManager = new ScriptEngineManager();
        ScriptEngine nashorn = scriptEngineManager.getEngineByName("nashorn");

        String name = "Runoob";
        Integer result = null;

        try {
            nashorn.eval("print('" + name + "')");
            result = (Integer) nashorn.eval("10 + 2");

        } catch (ScriptException e) {
            System.out.println("执行脚本错误: " + e.getMessage());
        }

        System.out.println(result.toString());
    }
}
