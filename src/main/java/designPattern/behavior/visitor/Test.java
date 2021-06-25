package designPattern.behavior.visitor;

/**
 * 描述:使用 ComputerPartDisplayVisitor 来显示 Computer 的组成部分。
 *
 * @author WuYanchang
 * @date 2021/6/25 15:36
 */

public class Test {
    public static void main(String[] args) {

        ComputerPart computer = new Computer();
        computer.accept(new ComputerPartDisplayVisitor());
    }

}
