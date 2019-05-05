package beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserConn {
    public UserBean queryAUser(String userID) {//查询用户信息
        Connection connection = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        UserBean user = new UserBean();
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement("select * from user where idUser='" + userID + "'");
            rs = pstmt.executeQuery();
            if (rs.next()) {
                user.setUserID(userID);
                user.setName(rs.getString(2));
                user.setEmail(rs.getString(4));
                user.setPhone(rs.getString(5));
                user.setAddress(rs.getString(6));
                user.setQQ(rs.getString(7));
                user.setRecipient(rs.getString(8));
                user.setAdminFlag(rs.getInt(9));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closeResultSet(rs);
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        return user;
    }

    public boolean examineAdmin(String userID){//检查用户是否为管理员
        Connection connection = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        boolean isAdmin = false;
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement("select adminFlag from user where idUser='" + userID + "'");
            rs = pstmt.executeQuery();
            if (rs.next()) {
                int adminFlag = rs.getInt(1);
                if(adminFlag == 1) isAdmin = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closeResultSet(rs);
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        return isAdmin;
    }

    public String getUsername(String userID){//获取用户名称
        Connection connection = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        String username = "";
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement("select username from user where idUser='" + userID + "'");
            rs = pstmt.executeQuery();
            if(rs.next()){
                username=rs.getString(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closeResultSet(rs);
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        return username;
    }
}
