package designPattern.behavior.interpreter;

/**
 * 描述:创建实现了上述接口的实体类。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:36
 */

public class TerminalExpression implements Expression {

    private String data;

    public TerminalExpression(String data) {
        this.data = data;
    }

    @Override
    public boolean interpret(String context) {
        if (context.contains(data)) {
            return true;
        }
        return false;
    }

}
