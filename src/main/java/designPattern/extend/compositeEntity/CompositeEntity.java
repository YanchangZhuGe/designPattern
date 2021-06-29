package designPattern.extend.compositeEntity;

/**
 * 描述:创建组合实体。
 *
 * @author WuYanchang
 * @date 2021/6/29 15:09
 */

public class CompositeEntity {
    private CoarseGrainedObject cgo = new CoarseGrainedObject();

    public void setData(String data1, String data2) {
        cgo.setData(data1, data2);
    }

    public String[] getData() {
        return cgo.getData();
    }
}
