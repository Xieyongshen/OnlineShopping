package servlets;

import beans.DBConn;
import beans.UserBean;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=GB2312");
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";
        UserBean user = new UserBean();
        if (action.equals("login")) {
            String username = request.getParameter("loginName");
            String password = request.getParameter("loginPassword");
            if (username == null) username = "";
            if (password == null) password = "";
            user = getUser(username, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("userID", user.getUserID());
                session.setAttribute("username", user.getName());
                response.sendRedirect("shop");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("loginErr", true);
                response.sendRedirect("index");
            }
        } else if (action.equals("register")) {
            String username = request.getParameter("regUserName");
            String password = request.getParameter("regPassword");
            String email = request.getParameter("regEmail");
            String phone = request.getParameter("regPhone");
            String QQ = request.getParameter("regQQ");
            if (username == null) username = "";
            if (password == null) password = "";
            if (email == null) email = "";
            if (phone == null) phone = "";
            if (QQ == null) QQ = "";
            user.setName(username);
            user.setPassword(password);
            user.setEmail(email);
            user.setPhone(phone);
            user.setQQ(QQ);
            if (createUser(user)) {
                HttpSession session = request.getSession();
                session.setAttribute("userID", user.getUserID());
                session.setAttribute("username", user.getName());
                response.sendRedirect("shop");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("regErr", true);
                response.sendRedirect("index");
            }
        } else if (action.equals("modify")) {
            String userID = (String) request.getSession().getAttribute("userID");
            String email = request.getParameter("userEmail");
            String phone = request.getParameter("userPhone");
            String address = request.getParameter("userAddress");
            String QQ = request.getParameter("userQQ");
            String recipient = request.getParameter("userRecipient");
            user.setUserID(userID);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            user.setQQ(QQ);
            user.setRecipient(recipient);
            if (updateUser(user)) {
                request.getSession().setAttribute("statusFlag", 1);
                response.sendRedirect("user");
            }else{
                request.getSession().setAttribute("statusFlag", 2);
                response.sendRedirect("user");
            }
        } else {
            HttpSession session = request.getSession();
            session.removeAttribute("userID");
            session.removeAttribute("username");
            response.sendRedirect("index");
        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    public UserBean getUser(String username, String password) {//用户登录检测
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection connection = null;
        UserBean result = null;
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement("select * from user where username=? and password=?");
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                result = new UserBean();
                result.setUserID(rs.getString(1));
                result.setName(rs.getString(2));
                result.setEmail(rs.getString(4));
                result.setPhone(rs.getString(5));
                result.setAddress(rs.getString(6));
                result.setQQ(rs.getString(7));
                result.setRecipient(rs.getString(8));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closeResultSet(rs);
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        return result;
    }

    public boolean createUser(UserBean record) {//用户注册
        Connection connection = null;
        PreparedStatement pstmt = null;
        String insStr = "insert into user(`idUser`, `username`, `password`, `email`, `phone`, `QQ`) values (?,?,?,?,?,?);";
        if (record == null) return false;
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement(insStr);
            pstmt.setString(1, record.getUserID());
            pstmt.setString(2, record.getName());
            pstmt.setString(3, record.getPassword());
            pstmt.setString(4, record.getEmail());
            pstmt.setString(5, record.getPhone());
            pstmt.setString(6, record.getQQ());
            pstmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        return true;
    }

    public boolean updateUser(UserBean user) {
        Connection connection = null;
        if (user == null) return false;
        PreparedStatement pstmt = null;
        String updStr = "update user set email=?,phone=?,address=?,QQ=?,recipient=?";
        updStr = updStr + " where idUser='" + user.getUserID() + "'";
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement(updStr);
            pstmt.setString(1, user.getEmail());
            pstmt.setString(2, user.getPhone());
            pstmt.setString(3, user.getAddress());
            pstmt.setString(4, user.getQQ());
            pstmt.setString(5, user.getRecipient());
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
