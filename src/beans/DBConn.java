package beans;

import java.sql.*;

public class DBConn {
    private static String driver = "com.mysql.jdbc.Driver";//默认驱动程序；
    private static String jdbcurl = "jdbc:mysql://127.0.0.1:3306/";//jdbcurl
    private static String database = "audiovisual";//数据库或数据源
    private static String userName = "root";//用户名
    private static String password = "786102508";//密码

    public DBConn() {    //自定义默认构造方法

    }

    public static Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName(driver);//注册驱动程序;
            connection = DriverManager.getConnection(jdbcurl + database + "?characterEncoding=UTF-8", userName, password);//建立连接；
        } catch (ClassNotFoundException e1) {
            e1.printStackTrace();
        } catch (SQLException e2) {
            e2.printStackTrace();
        }
        return connection;
    }

    public static void closeConnection(Connection connection) {//关闭连接；
        try {
            if (connection != null)
                connection.close();
            connection = null;
        } catch (SQLException e3) {
            e3.printStackTrace();
        }
    }

    public static void closePstmt(PreparedStatement pstmt) {//关闭执行语句；
        try {
            if (pstmt != null)
                pstmt.close();
            pstmt = null;
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void closeResultSet(ResultSet rs) {//关闭结果集语句；
        try {
            if (rs != null)
                rs.close();
            rs = null;
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String getDriver() {//获取驱动程序
        return driver;
    }

    public void setDriver(String driver) {
        this.driver = driver;
    }

    public String getDatabase() {
        return database;
    }

    public void setDatabase(String database) {
        this.database = database;
    }

    public String getJdbcurl() {
        return jdbcurl;
    }

    public void setJdbcurl(String url) {
        this.jdbcurl = url;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
