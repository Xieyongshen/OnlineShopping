package beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;

public class OrderConn {
    public OrderBean[] getOrders(){
        Connection connection = null;
        PreparedStatement pstmt=null;
        ResultSet rs=null;
        String sqlStr = "select * from `order`";
        Collection list=new ArrayList();
        try{
            connection= DBConn.getConnection();
            pstmt=connection.prepareStatement(sqlStr);//数据表addresslist
            rs=pstmt.executeQuery();
            while(rs.next()){
                OrderBean order = new OrderBean();
                order.setOrderID(rs.getString(1));
                order.setUserID(rs.getString(2));
                OrderItemBean[] items = queryOrderItems(order.getOrderID());
                for (OrderItemBean item : items) {
                    order.addOrderItem(item);
                }
                order.setTotal(rs.getDouble(3));
                order.setCreateTime(rs.getString(4));
                order.setCompleteTime(rs.getString(5));
                order.setStatus(rs.getInt(6));
                list.add(order);
            }
        }catch(SQLException e){
            e.printStackTrace();
        }finally{
            DBConn.closeResultSet(rs);
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        OrderBean[] orders=(OrderBean[])list.toArray(new OrderBean[0]);
        return orders;
    }

    public OrderBean[] queryOrders(String userID) {//查询用户对应所有订单
        Connection connection = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Collection list = new ArrayList();
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement("select * from `order` where userID='" + userID + "'");
            rs = pstmt.executeQuery();
            while (rs.next()) {
                OrderBean order = new OrderBean();
                order.setOrderID(rs.getString(1));
                order.setUserID(userID);
                OrderItemBean[] items = queryOrderItems(order.getOrderID());
                for (OrderItemBean item : items) {
                    order.addOrderItem(item);
                }
                order.setTotal(rs.getDouble(3));
                order.setCreateTime(rs.getString(4));
                order.setCompleteTime(rs.getString(5));
                order.setStatus(rs.getInt(6));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closeResultSet(rs);
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        OrderBean[] orders = (OrderBean[]) list.toArray(new OrderBean[0]);
        return orders;
    }

    private OrderItemBean[] queryOrderItems(String orderID) {//查询所有订单项
        Connection connection = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Collection list = new ArrayList();
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement("select * from orderitem where orderID='" + orderID + "'");
            rs = pstmt.executeQuery();
            while (rs.next()) {
                OrderItemBean item = new OrderItemBean();
                item.setId(rs.getInt(1));
                item.setProductID(rs.getInt(2));
                item.setCount(rs.getInt(3));
                item.setOrderID(orderID);
                item.setSum(rs.getDouble(5));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closeResultSet(rs);
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        OrderItemBean[] items = (OrderItemBean[]) list.toArray(new OrderItemBean[0]);
        return items;
    }

    public boolean searchInOrder(OrderBean order, String searchStr) {
        if(searchStr == null || searchStr.length() == 0) return true;
        ArrayList<OrderItemBean> items = order.getOrderList();
        ShopConn connShop = new ShopConn();
        for (OrderItemBean item : items) {
            int productID = item.getProductID();
            String productName = connShop.getAProduct(productID).getName();
            if(productName.contains(searchStr)){
                return true;
            }
        }
        return false;
    }
}
