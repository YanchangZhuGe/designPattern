package designPattern.behavior.interpreter;

/**
 * 描述:创建一个表达式接口。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:36
 */
public interface Expression {
    public boolean interpret(String context);
}
