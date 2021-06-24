package designPattern.structural.decorator;

/**
 * 描述:创建实现了 Shape 接口的抽象装饰类。
 *
 * @author WuYanchang
 * @date 2021/6/24 20:38
 */

public abstract class ShapeDecorator implements Shape {
    protected Shape decoratedShape;

    public ShapeDecorator(Shape decoratedShape) {
        this.decoratedShape = decoratedShape;
    }

    public void draw() {
        decoratedShape.draw();
    }

}
