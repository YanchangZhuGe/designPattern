package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;

/**
 * <p>
 * 
 * </p>
 *
 * @author wyc
 * @since 2022-05-05
 */
@TableName("student_info_gen")
public class StudentInfoGenDO {

    /**
     * 学生id
     */
    private String id;

    /**
     * 学号编码
     */
    private String code;

    /**
     * 学生姓名
     */
    private String name;

    /**
     * 所属班级id
     */
    private String classId;

    /**
     * 性别 0-女; 1-男
     */
    private Integer sex;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    public String getClassId() {
        return classId;
    }

    public void setClassId(String classId) {
        this.classId = classId;
    }
    public Integer getSex() {
        return sex;
    }

    public void setSex(Integer sex) {
        this.sex = sex;
    }

    @Override
    public String toString() {
        return "StudentInfoGenDO{" +
            "id=" + id +
            ", code=" + code +
            ", name=" + name +
            ", classId=" + classId +
            ", sex=" + sex +
        "}";
    }
}
