package designPattern.behavior.interpreter;

/**
 * 描述:创建实现了上述接口的实体类。
 *
 * @author WuYanchang
 * @date 2021/6/25 9:36
 */

public class OrExpression implements Expression {

    private Expression expr1 = null;
    private Expression expr2 = null;

    public OrExpression(Expression expr1, Expression expr2) {
        this.expr1 = expr1;
        this.expr2 = expr2;
    }

    @Override
    public boolean interpret(String context) {
        return expr1.interpret(context) || expr2.interpret(context);
    }

}
