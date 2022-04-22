package designPattern.behavior.visitor;

/**
 * 描述:定义一个表示访问者的接口。
 *
 * @author WuYanchang
 * @date 2021/6/25 15:35
 */

public interface ComputerPartVisitor {
    public void visit(Computer computer);

    public void visit(Mouse mouse);

    public void visit(Keyboard keyboard);

    public void visit(Monitor monitor);
}
