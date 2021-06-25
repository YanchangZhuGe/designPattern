package designPattern.behavior.visitor;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 15:35
 */

public class Monitor   implements ComputerPart {

    @Override
    public void accept(ComputerPartVisitor computerPartVisitor) {
        computerPartVisitor.visit(this);
    }

}
