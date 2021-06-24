package designPattern.structural.facade;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/24 20:43
 */

public class Square implements Shape {

    @Override
    public void draw() {
        System.out.println("Square::draw()");
    }

}
