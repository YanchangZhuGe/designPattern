package designPattern.structural.proxy;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/24 20:50
 */

public class RealImage implements Image {

    private String fileName;

    public RealImage(String fileName){
        this.fileName = fileName;
        loadFromDisk(fileName);
    }

    @Override
    public void display() {
        System.out.println("Displaying " + fileName);
    }

    private void loadFromDisk(String fileName){
        System.out.println("Loading " + fileName);
    }

}
