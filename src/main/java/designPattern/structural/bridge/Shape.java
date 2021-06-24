package designPattern.structural.bridge;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/24 15:50
 */

public abstract class Shape {
    protected DrawAPI drawAPI;
    protected Shape(DrawAPI drawAPI){
        this.drawAPI = drawAPI;
    }
    public abstract void draw();
}
