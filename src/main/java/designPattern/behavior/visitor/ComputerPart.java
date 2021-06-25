package designPattern.behavior.visitor;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 15:34
 */
public interface ComputerPart {
    public void accept(ComputerPartVisitor computerPartVisitor);
}
