package designPattern.extend.compositeEntity;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/29 15:08
 */

public class CoarseGrainedObject {
    DependentObject1 do1 = new DependentObject1();
    DependentObject2 do2 = new DependentObject2();

    public void setData(String data1, String data2){
        do1.setData(data1);
        do2.setData(data2);
    }

    public String[] getData(){
        return new String[] {do1.getData(),do2.getData()};
    }
}
