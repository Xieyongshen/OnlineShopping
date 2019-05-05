package beans;

import java.util.UUID;

public class UserBean {
    private String userID;//表示编号；
    private String name;//用户名
    private String password;//密码
    private String email;//电子邮件；
    private String phone;//联系电话
    private String address;//通信地址；
    private String qq;//QQ；
    private String recipient;//收件人；
    private int adminFlag;//管理员标志符

    public UserBean() {
        UUID uuid = UUID.randomUUID();
        this.userID = uuid.toString();
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getUserID() {
        return userID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getQQ() {
        return qq;
    }

    public void setQQ(String qq) {
        this.qq = qq;
    }

    public String getRecipient() {
        return recipient;
    }

    public void setRecipient(String recipient) {
        this.recipient = recipient;
    }

    public int getAdminFlag() {
        return adminFlag;
    }

    public void setAdminFlag(int adminFlag) {
        this.adminFlag = adminFlag;
    }
}
