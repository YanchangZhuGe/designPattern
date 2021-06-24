package designPattern.structural.decorator;

/**
 * 描述:创建扩展了 ShapeDecorator 类的实体装饰类。
 *
 * @author WuYanchang
 * @date 2021/6/24 20:38
 */

public class RedShapeDecorator extends ShapeDecorator {

    public RedShapeDecorator(Shape decoratedShape) {
        super(decoratedShape);
    }

    @Override
    public void draw() {
        decoratedShape.draw();
        setRedBorder(decoratedShape);
    }

    private void setRedBorder(Shape decoratedShape) {
        System.out.println("Border Color: Red");
    }

}
