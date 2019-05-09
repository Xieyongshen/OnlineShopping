package servlets;

import beans.*;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ShopServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=GB2312");
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";
        if (action.equals("order")) {
            Cookie[] cookies = request.getCookies();
            String cartStr = "[]";
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("cart")) {
                    cartStr = URLDecoder.decode(cookie.getValue(), "utf-8");
                    break;
                }
            }
            Gson gson = new Gson();
            Type type = new TypeToken<List<CartItemBean>>() {
            }.getType();
            List<CartItemBean> cart = gson.fromJson(cartStr, type);
            OrderBean order = new OrderBean();
            for (CartItemBean cartItem : cart) {
                OrderItemBean orderItem = new OrderItemBean();
                orderItem.setProductID(cartItem.getId());
                orderItem.setCount(cartItem.getCount());
                orderItem.setOrderID(order.getOrderID());
                orderItem.setSum(cartItem.getPrice() * cartItem.getCount());
                order.addOrderItem(orderItem);
            }
            String userID = (String) request.getSession().getAttribute("userID");
            order.setUserID(userID);
            if (createOrder(order)) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("cart")) {
                        cookie.setValue(null);
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                        break;
                    }
                }
                request.getSession().setAttribute("statusFlag", 3);
                response.sendRedirect("user");
            } else {
                request.getSession().setAttribute("statusFlag", 4);
                response.sendRedirect("cart");
            }
        } else if (action.equals("add")) {
            String categoryStr = request.getParameter("productCate");
            String name = request.getParameter("productName");
            String desc = request.getParameter("productDesc");
            String priceStr = request.getParameter("productPrice");
            String remainsStr = request.getParameter("productRemains");
            int category = Integer.parseInt(categoryStr);
            double price = Double.parseDouble(priceStr);
            int remains = Integer.parseInt(remainsStr);
            ProductBean product = new ProductBean();
            product.setCategory(category);
            product.setName(name);
            product.setDescription(desc);
            product.setPrice(price);
            product.setRemains(remains);
            if (createProduct(product)) {
                request.getSession().setAttribute("statusFlag", 5);
                response.sendRedirect("manage");
            } else {
                request.getSession().setAttribute("statusFlag", 6);
                response.sendRedirect("manage");
            }
        } else if (action.equals("update")) {
            String idStr = request.getParameter("productID");
            String categoryStr = request.getParameter("productCate");
            String name = request.getParameter("productName");
            String desc = request.getParameter("productDesc");
            String priceStr = request.getParameter("productPrice");
            String remainsStr = request.getParameter("productRemains");
            int id = Integer.parseInt(idStr);
            int category = Integer.parseInt(categoryStr);
            double price = Double.parseDouble(priceStr);
            int remains = Integer.parseInt(remainsStr);
            ProductBean product = new ProductBean();
            product.setProductID(id);
            product.setCategory(category);
            product.setName(name);
            product.setDescription(desc);
            product.setPrice(price);
            product.setRemains(remains);
            if (updateProduct(product)) {
                request.getSession().setAttribute("statusFlag", 7);
                response.sendRedirect("manage");
            } else {
                request.getSession().setAttribute("statusFlag", 8);
                response.sendRedirect("manage");
            }
        } else if (action.equals("delete")) {
            String idStr = request.getParameter("productID");
            int id = Integer.parseInt(idStr);
            if (deleteProduct(id)) {
                request.getSession().setAttribute("statusFlag", 9);
                response.sendRedirect("manage");
            } else {
                request.getSession().setAttribute("statusFlag", 10);
                response.sendRedirect("manage");
            }
        } else if (action.equals("send")) {
            String idStr = request.getParameter("orderID");
            if(sendOrder(idStr)){
                request.getSession().setAttribute("statusFlag", 11);
                response.sendRedirect("manage");
            } else {
                request.getSession().setAttribute("statusFlag", 12);
                response.sendRedirect("manage");
            }
        } else {
            response.sendRedirect("error");
        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private boolean createOrder(OrderBean order) {//订单创建
        if (order == null) return false;
        Connection connection = null;
        PreparedStatement pstmt = null;
        String orderID = order.getOrderID();
        String userID = order.getUserID();
        ArrayList<OrderItemBean> orderList = order.getOrderList();
        double total = order.getTotal();
        String orderStr = "insert into `order`(`idOrder`, `userID`, `orderTotal`) values ('" + orderID + "','" + userID + "','" + total + "');";
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement(orderStr);
            pstmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        for (OrderItemBean item : orderList) {
            createOrderItem(item);
        }
        return true;
    }

    private void createOrderItem(OrderItemBean orderItem) {
        if (orderItem == null) return;
        Connection connection = null;
        PreparedStatement pstmt = null;
        String insStr = "insert into orderitem(`productID`, `itemCount`, `orderID`, `itemSum`) values (?,?,?,?);";
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement(insStr);
            pstmt.setInt(1, orderItem.getProductID());
            pstmt.setInt(2, orderItem.getCount());
            pstmt.setString(3, orderItem.getOrderID());
            pstmt.setDouble(4, orderItem.getSum());
            pstmt.execute();
            sellProduct(orderItem.getProductID(), orderItem.getCount());
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
    }

    private void sellProduct(int productID, int count) {
        if (productID <= 0) return;
        Connection connection = null;
        PreparedStatement pstmt = null;
        String updStr = "update product set `remains`=`remains`-?, `sold`=`sold`+? where idproduct=?";
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement(updStr);
            pstmt.setInt(1, count);
            pstmt.setInt(2, count);
            pstmt.setInt(3, productID);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
    }

    private boolean createProduct(ProductBean product) {
        if (product == null) return false;
        Connection connection = null;
        PreparedStatement pstmt = null;
        String sqlStr = "insert into product(`idproduct`, `name`, `price`, `description`, `remains`, `category`, `url`) values (?,?,?,?,?,?,?);";
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement(sqlStr);
            pstmt.setInt(1, product.getProductID());
            pstmt.setString(2, product.getName());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setString(4, product.getDescription());
            pstmt.setInt(5, product.getRemains());
            pstmt.setInt(6, product.getCategory());
            pstmt.setString(7, product.getUrl());
            pstmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        return true;
    }

    private boolean updateProduct(ProductBean product) {
        Connection connection = null;
        if (product == null) return false;
        PreparedStatement pstmt = null;
        String updStr = "update product set name=?,price=?,description=?,remains=?,category=?";
        updStr = updStr + " where idproduct='" + product.getProductID() + "'";
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement(updStr);
            pstmt.setString(1, product.getName());
            pstmt.setDouble(2, product.getPrice());
            pstmt.setString(3, product.getDescription());
            pstmt.setInt(4, product.getRemains());
            pstmt.setInt(5, product.getCategory());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        return true;
    }

    private boolean deleteProduct(int productID) {
        Connection connection = null;
        if (productID <= 0) return false;
        PreparedStatement pstmt = null;
        String delStr = "delete from product where idproduct=?";
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement(delStr);
            pstmt.setInt(1, productID);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        return true;
    }

    private boolean sendOrder(String orderID) {
        Connection connection = null;
        if (orderID == null) return false;
        PreparedStatement pstmt = null;
        String updStr = "update `order` set status=1 where idOrder=?";
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement(updStr);
            pstmt.setString(1, orderID);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        return true;
    }
}
