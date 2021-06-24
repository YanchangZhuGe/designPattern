package designPattern.structural.proxy;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/24 20:50
 */

public class ProxyImage  implements Image{

    private RealImage realImage;
    private String fileName;

    public ProxyImage(String fileName){
        this.fileName = fileName;
    }

    @Override
    public void display() {
        if(realImage == null){
            realImage = new RealImage(fileName);
        }
        realImage.display();
    }

}
