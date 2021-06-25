package designPattern.behavior.visitor;

/**
 * 描述:创建扩展了上述类的实体类。
 *
 * @author WuYanchang
 * @date 2021/6/25 15:35
 */

public class Monitor implements ComputerPart {

    @Override
    public void accept(ComputerPartVisitor computerPartVisitor) {
        computerPartVisitor.visit(this);
    }

}
