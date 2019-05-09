<%@ page import="beans.CategoryBean" %>
<%@ page import="beans.ProductBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="head.jsp" %>
    <title>
        商品列表 -
        <jsp:useBean id="connShop" scope="session" class="beans.ShopConn"/>
        <%
            String categoryStr = request.getParameter("category");
            String categoryName = "全部商品";
            int curCategory = categoryStr == null ? 0 : Integer.parseInt(categoryStr);
            CategoryBean[] categories = connShop.getCategories();
            if (curCategory >= categories.length) {
                out.println("该分类不存在");
            } else {
                if (categories != null && curCategory != 0) {
                    categoryName = categories[curCategory - 1].getName();
                }
                if (categoryName != null) {
                    out.println(categoryName);
                }
            }
        %>
    </title>
    <style type="text/css">
        .shop-category {
            height: 43px;
            border-bottom: 3px solid #9966CC;
        }

        .shop-category ul {
            width: 1100px;
            margin: 0 auto;
            padding: 0;
            text-align: left;
        }

        .shop-category ul li {
            font-size: 14px;
            line-height: 40px;
            padding: 0 15px;
            margin-left: -1px;
            white-space: nowrap;
            list-style-type: none;
            display: inline-block;
        }

        .shop-category a {
            color: #323232;
            display: inline-block;
        }

        .shop-category a:hover {
            color: #9966CC;
        }

        .shop-category a.all {
            width: 200px;
            height: 40px;
            margin-right: 17px;
            text-align: left;
            color: #ffffff;
            background: #9966CC;
            position: relative;
        }

        .shop-category a.active {
            color: #9966CC;
        }

        .shop-products {
            width: 1100px;
            margin: 0 auto;
            padding: 0;
            display: flex;
            flex-direction: row;
            flex-wrap: wrap;
        }

        .product-item {
            width: 252px;
            height: 362px;
            margin-top: 20px;
            margin-right: 20px;
            border: 1px solid #ddd;
            box-shadow: 1px 1px 3px #dcdcdc;
        }

        .product-img {
            width: 250px;
            height: 250px;
            background: #fcf8e3;
        }

        .product-price {
            height: 30px;
            color: #9966CC;
            font-size: 18px;
            line-height: 30px;
            margin-top: 10px;
            padding: 0 10px;
        }

        .product-name {
            height: 40px;
            font-size: 12px;
            line-height: 20px;
            padding: 0 15px;
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
            overflow: hidden;
        }

        .product-name a {
            color: #323232;
        }

        .product-name a:hover {
            color: #9966CC;
        }

        .product-sold {
            color: #888888;
            font-size: 12px;
            line-height: 30px;
            padding: 0 15px;
        }

        .product-empty {
            width: 100%;
            color: #ababab;
            font-size: 30px;
            line-height: 100px;
            text-align: center;
            margin-top: 50px;
        }
    </style>
</head>
<body>
<%@ include file="navBar.jsp" %>
<%@ include file="searchBar.jsp" %>
<div class="page-shop">
    <div class="shop-category">
        <ul>
            <a class="all" href='shop?category=0'>
                <li>全部分类</li>
            </a>
            <%
                if (categories != null) {
                    for (int i = 0; i < categories.length; i++) {
                        String extraClass = "";
                        if(curCategory == categories[i].getCategoryID()) extraClass = "active";
                        out.println("<a href='shop?category=" + categories[i].getCategoryID() + "' class='" + extraClass + "'><li>" + categories[i].getName() + "</li></a>");
                    }
                }
            %>
        </ul>
    </div>
    <div class="shop-products">
        <%
            String searchStr = request.getParameter("searchStr");
            if(searchStr == null) searchStr = "";
            ProductBean[] products = connShop.getProducts(curCategory);
            if (products != null) {
                for (int i = 0; i < products.length; i++) {
                    if(products[i].getRemains() <= 0 || !products[i].getName().contains(searchStr)) continue;
                    out.println("<div class='product-item'>");
                    out.println("<a href='product?id=" + products[i].getProductID() + "' title='" + products[i].getName() + "'><img src='" + products[i].getUrl() + "' alt='商品图片' class='product-img'/></a>");
                    out.println("<div class='product-price'>￥" + String.format("%.2f", products[i].getPrice()) + "</div>");
                    out.println("<div class='product-name'><a href='product?id=" + products[i].getProductID() + "' title='" + products[i].getName() + "'>" + products[i].getName() + "</a></div>");
                    out.println("<div class='product-sold'>已售" + products[i].getSold() + "件</div>");
                    out.println("</div>");
                }
            }
            if (products.length == 0) {
                out.println("<div class='product-empty'>该分类下暂无商品</div>");
            }
        %>
    </div>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>
