package designPattern.extend.compositeEntity;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/29 15:09
 */

public class Client {
    private CompositeEntity compositeEntity = new CompositeEntity();

    public void printData(){
        for (int i = 0; i < compositeEntity.getData().length; i++) {
            System.out.println("Data: " + compositeEntity.getData()[i]);
        }
    }

    public void setData(String data1, String data2){
        compositeEntity.setData(data1, data2);
    }
}
