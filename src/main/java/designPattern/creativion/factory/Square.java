package designPattern.creativion.factory;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/5/14 16:21
 */

public class Square implements Shape {

    @Override
    public void draw() {
        System.out.println("Inside Square::draw() method.");
    }
}
