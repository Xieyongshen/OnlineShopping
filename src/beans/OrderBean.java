package beans;

import java.util.ArrayList;
import java.util.UUID;

public class OrderBean {
    private String orderID;
    private String userID;
    private ArrayList<OrderItemBean> orderList = new ArrayList<>();
    private double total;
    private String createTime;
    private String completeTime;
    private int status;

    public OrderBean(){
        UUID uuid = UUID.randomUUID();
        this.orderID = uuid.toString();
    }

    public void setOrderID(String orderID) {
        this.orderID = orderID;
    }

    public String getOrderID() {
        return orderID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public void addOrderItem(OrderItemBean item) {
        this.orderList.add(item);
        this.total += item.getSum();
    }

    public ArrayList<OrderItemBean> getOrderList() {
        return orderList;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public double getTotal() {
        return total;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        if(createTime.length() > 19) createTime = createTime.substring(0,19);
        this.createTime = createTime;
    }

    public String getCompleteTime() {
        return completeTime;
    }

    public void setCompleteTime(String completeTime) {
        if(completeTime.length() > 19) completeTime = completeTime.substring(0,19);
        this.completeTime = completeTime;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
