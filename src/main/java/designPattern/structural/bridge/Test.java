package designPattern.structural.bridge;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/24 15:51
 */

public class Test {
    public static void main(String[] args) {
        Shape redCircle = new Circle(100,100, 10, new RedCircle());
        Shape greenCircle = new Circle(100,100, 10, new GreenCircle());

        redCircle.draw();
        greenCircle.draw();
    }
}
