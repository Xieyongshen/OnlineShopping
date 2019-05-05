package beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;

public class ShopConn {
    public CategoryBean[] getCategories(){
        Connection connection = null;
        PreparedStatement pstmt=null;
        ResultSet rs=null;
        Collection list=new ArrayList();
        try{
            connection= DBConn.getConnection();
            pstmt=connection.prepareStatement("select * from category");//数据表addresslist
            rs=pstmt.executeQuery();
            while(rs.next()){
                CategoryBean category=new CategoryBean();
                category.setCategoryID(rs.getInt(1));
                category.setName(rs.getString(2));
                list.add(category);
            }
        }catch(SQLException e){
            e.printStackTrace();
        }finally{
            DBConn.closeResultSet(rs);
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        CategoryBean[] records=(CategoryBean[])list.toArray(new CategoryBean[0]);
        return records;
    }

    public ProductBean[] getProducts(int category){
        Connection connection = null;
        PreparedStatement pstmt=null;
        ResultSet rs=null;
        String sqlStr;
        if(category == 0){
            sqlStr="select * from product";
        }else{
            sqlStr="select * from product where category=" + category;
        }
        Collection list=new ArrayList();
        try{
            connection= DBConn.getConnection();
            pstmt=connection.prepareStatement(sqlStr);//数据表addresslist
            rs=pstmt.executeQuery();
            while(rs.next()){
                ProductBean product=new ProductBean();
                product.setProductID(rs.getInt(1));
                product.setName(rs.getString(2));
                product.setPrice(rs.getDouble(3));
                product.setDescription(rs.getString(4));
                product.setRemains(rs.getInt(5));
                product.setSold(rs.getInt(6));
                product.setCategory(rs.getInt(7));
                product.setUrl(rs.getString(8));
                list.add(product);
            }
        }catch(SQLException e){
            e.printStackTrace();
        }finally{
            DBConn.closeResultSet(rs);
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        ProductBean[] records=(ProductBean[])list.toArray(new ProductBean[0]);
        return records;
    }

    public ProductBean getAProduct(int id){ //查询商品信息
        Connection connection = null;
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        String sqlStr = "select * from product where idproduct="+id;
        ProductBean product = new ProductBean();
        try {
            connection = DBConn.getConnection();
            pstmt = connection.prepareStatement(sqlStr);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                product.setProductID(rs.getInt(1));
                product.setName(rs.getString(2));
                product.setPrice(rs.getDouble(3));
                product.setDescription(rs.getString(4));
                product.setRemains(rs.getInt(5));
                product.setSold(rs.getInt(6));
                product.setCategory(rs.getInt(7));
                product.setUrl(rs.getString(8));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConn.closeResultSet(rs);
            DBConn.closePstmt(pstmt);
            DBConn.closeConnection(connection);
        }
        return product;
    }
}
