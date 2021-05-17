package designPattern.creativion.abstractFactory;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/5/17 9:58
 */

public class FactoryProducer {
    public static AbstractFactory getFactory(String choice){
        if(choice.equalsIgnoreCase("SHAPE")){
            return new ShapeFactory();
        } else if(choice.equalsIgnoreCase("COLOR")){
            return new ColorFactory();
        }
        return null;
    }

}
