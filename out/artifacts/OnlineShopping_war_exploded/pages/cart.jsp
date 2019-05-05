<%@ page import="beans.CartItemBean" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.reflect.TypeToken" %>
<%@ page import="java.lang.reflect.Type" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="head.jsp" %>
    <title>购物车</title>
    <style type="text/css">
        .cart-container {
            margin-top: 50px;
            border-top: 3px solid #ff2832;
            border-bottom: 3px solid #ff2832;
        }

        .cart-address {
            height: 50px;
            background: #fafafa;
        }

        .address-body {
            width: 1100px;
            height: 50px;
            line-height: 50px;
            text-align: left;
            margin: 0 auto;
            padding: 0 30px;
            position: relative;
        }

        .address-title {
            width: 80px;
            text-align: right;
            margin-right: 10px;
            display: inline-block;
        }

        .cart-header {
            width: 1000px;
            height: 40px;
            margin: 20px auto 10px auto;
            padding: 0 20px;
            background: #fafafa;
            border: 1px solid #dcdcdc;
            text-align: left;
        }

        .header-item {
            font-size: 14px;
            line-height: 40px;
            vertical-align: top;
            display: inline-block;
            text-align: center;
        }

        .header-book {
            width: 430px;
        }

        .header-price,
        .header-count,
        .header-sum {
            width: 150px;
        }

        .header-delete {
            width: 60px;
        }

        .cart-items {
            width: 1000px;
            margin: 0 auto;
            padding: 0 20px;
            background: #fafafa;
            border: 1px solid #dcdcdc;
            text-align: left;
        }

        .cart-item {
            padding: 20px 0;
            border-top: 1px solid #dcdcdc;
            text-align: left;
        }

        .cart-item:first-child {
            border-top: none;
        }

        .item-block {
            font-size: 14px;
            line-height: 100px;
            text-align: center;
            vertical-align: top;
            display: inline-block;
        }

        .cart-item-img {
            width: 100px;
            height: 100px;
            margin: 0 20px;
        }

        .cart-item-img > img {
            width: 100px;
            height: 100px;
        }

        .cart-item-name {
            width: 280px;
            font-size: 14px;
            line-height: 30px;
            vertical-align: top;
            display: inline-block;
        }

        .cart-item-name p {
            margin: 0;
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
            overflow: hidden;
        }

        .cart-item-count {
            width: 150px;
            font-size: 14px;
            text-align: center;
            display: inline-block;
        }

        .cart-count-item {
            height: 30px;
            line-height: 28px;
            text-align: center;
            display: inline-block;
        }

        .cart-count-minus,
        .cart-count-add {
            width: 32px;
            background: #eee;
            border: 1px solid #dcdcdc;
            cursor: pointer;
            user-select: none;
        }

        .cart-count-minus:hover,
        .cart-count-add:hover {
            color: #ff2832;
            background: #fff5f5;
        }

        .cart-count-num {
            width: 42px;
            border: 1px solid #dcdcdc;
            outline: none;
        }

        .cart-item-price,
        .cart-item-sum {
            width: 150px;
        }

        .cart-item-delete {
            width: 60px;
            margin: 33px 0;
        }

        .cart-total {
            width: 1000px;
            height: 60px;
            line-height: 60px;
            text-align: left;
            margin: 20px auto;
            padding: 0 30px;
            background: #fafafa;
            border: 1px solid #dcdcdc;
        }

        .total-right {
            float: right;
        }

        .total-title {
            font-size: 13px;
            display: inline-block;
        }

        .total-num {
            color: #ff2832;
            font-size: 20px;
            display: inline-block;
        }

        .total-pay {
            width: 100px;
            height: 40px;
            color: #fff;
            font-size: 18px;
            line-height: 40px;
            text-align: center;
            margin: 10px 0 10px 50px;
            padding: 0;
            border: none;
            background: #ff2832;
            vertical-align: top;
            display: inline-block;
            outline: none !important;
        }

        .total-pay:hover,
        .total-pay:active,
        .total-pay:focus,
        .total-pay:visited {
            color: #fff;
            background: #ff2832;
            outline: none;
        }
    </style>
</head>
<body>
<%@ include file="navBar.jsp" %>
<%
    if (userID == null) {
%>
<script type="text/javascript">alert("请先登录！");
window.location.href = "index";</script>
<%
    }
    UserBean user = connUser.queryAUser(userID);
%>
<div class="page-cart">
    <div class="cart-container">
        <div class="cart-body">
            <div class="cart-address">
                <div class="address-body">
                    <div class="address-title">配送至：</div>
                    <%
                        if (user != null) {
                            String address = user.getAddress();
                            if (address == null) address = "未填写";
                            out.println(address);
                        }
                    %>
                </div>
            </div>
            <div class="cart-header">
                <div class="header-book header-item">图书</div>
                <div class="header-price header-item">单价(元)</div>
                <div class="header-count header-item">数量</div>
                <div class="header-sum header-item">金额(元)</div>
                <div class="header-delete header-item">操作</div>
            </div>
            <form action="ShopServlet" method="get">
                <div class="cart-items">
                    <%
                        Cookie[] cookies = request.getCookies();
                        String cartStr = "[]";
                        for (Cookie cookie : cookies) {
                            if (cookie.getName().equals("cart")) {
                                cartStr = URLDecoder.decode(cookie.getValue(), "utf-8");
                            }
                        }
                        Gson gson = new Gson();
                        Type type = new TypeToken<List<CartItemBean>>() {
                        }.getType();
                        List<CartItemBean> cart = gson.fromJson(cartStr, type);
                        double total = 0;
                        for (CartItemBean item : cart) {
                    %>
                    <div class="cart-item">
                        <a href='product?id=<% out.print(item.getId()); %>' title="<% out.print(item.getName()); %>"
                           class='cart-item-img'>
                            <img src='<% out.print(item.getUrl()); %>' alt='商品图片'/>
                        </a>
                        <div class="cart-item-name">
                            <p><a href='product?id=<% out.print(item.getId()); %>'
                                  title="<% out.print(item.getName()); %>"><% out.print(item.getName()); %></a>
                            </p>
                        </div>
                        <div class="cart-item-price item-block">￥<span id="priceNum<% out.print(item.getId()); %>"><%
                            out.print(item.getPrice()); %></span></div>
                        <div class="cart-item-count">
                            <div class="cart-count-minus cart-count-item" data-itemid="<% out.print(item.getId()); %>">-
                            </div>
                            <input type="text" class="cart-count-num cart-count-item"
                                   id="count<% out.print(item.getId()); %>"
                                   value="<% out.print(item.getCount()); %>"
                                   data-itemid="<% out.print(item.getId()); %>"/>
                            <div class="cart-count-add cart-count-item" data-itemid="<% out.print(item.getId()); %>">+
                            </div>
                        </div>
                        <div class="cart-item-sum item-block">￥<span class="sum-num" id="sumNum<% out.print(item.getId()); %>"><%
                            double sum = item.getPrice() * item.getCount();
                            out.print(String.format("%.2f", sum));
                        %></span>
                        </div>
                        <div class="cart-item-delete item-block">
                            <button type="button" class="btn btn-default delete-btn"
                                    data-itemid="<% out.print(item.getId()); %>">删除
                            </button>
                        </div>
                    </div>
                    <%
                            total += item.getPrice() * item.getCount();
                        }
                    %>
                </div>
                <div class="cart-total">
                    <div class="total-right">
                        <div class="total-title">合计：</div>
                        <div class="total-num">￥<span id="totalNum"><% out.print(String.format("%.2f", total)); %></span></div>
                        <button type="submit" name="action" value="order" class="btn total-pay">结 算</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
<script type="text/javascript">
    function changeCartCount(id, count) {
        var countNum = parseInt(count);
        var cartStr = $.cookie('cart');
        var cart = [];
        if (cartStr) cart = JSON.parse(cartStr);
        for (var i = 0; i < cart.length; i++) {
            if (cart[i].id == id) {
                cart[i].count = countNum;
            }
        }
        var cartJSON = JSON.stringify(cart);
        $.cookie('cart', cartJSON);
    }

    function deleteCartItem(id) {
        var idNum = parseInt(id);
        var cartStr = $.cookie('cart');
        var cart = [];
        if (cartStr) cart = JSON.parse(cartStr);
        var deleteIndex = -1;
        for (var i = 0; i < cart.length; i++) {
            if (cart[i].id == idNum) {
                deleteIndex = i;
            }
        }
        if (deleteIndex >= 0) {
            cart.splice(deleteIndex, 1);
        } else {
            alert("购物车中找不到该商品");
        }
        var cartJSON = JSON.stringify(cart);
        $.cookie('cart', cartJSON);
        window.location.reload();
    }

    function changeSum(count, idStr) {
        var priceNum = "#priceNum" + idStr;
        var priceStr = $(priceNum).text();
        var price = parseFloat(priceStr);
        var sum = price * count;
        var sumNum = "#sumNum" + idStr;
        $(sumNum).text(sum.toFixed(2));
        changeTotal();
    }

    function changeTotal(){
        var total = 0;
        $(".sum-num").each(function () {
            var curStr = $(this).text();
            var curNum = parseFloat(curStr);
            total += curNum;
        });
        $("#totalNum").text(total);
    }

    $(document).ready(function () {
        $(".cart-count-num").change(function () {
            var idStr = $(this).data("itemid");
            var id = parseInt(idStr);
            var count = parseInt($(this).val());
            if (!count || count <= 0) {
                count = 1;
            }
            changeCartCount(id, count);
            $(this).val(count);
            changeSum(count, idStr);
        });

        $(".cart-count-minus").click(function () {
            var idStr = $(this).data("itemid");
            var id = parseInt(idStr);
            var inputID = "#count" + idStr;
            var cartItem = $(inputID);
            var count = parseInt(cartItem.val());
            if (count > 0) count--;
            changeCartCount(id, count);
            cartItem.val(count);
            changeSum(count, idStr);
        });

        $(".cart-count-add").click(function () {
            var idStr = $(this).data("itemid");
            var id = parseInt(idStr);
            var inputID = "#count" + idStr;
            var cartItem = $(inputID);
            var count = parseInt(cartItem.val());
            count++;
            changeCartCount(id, count);
            cartItem.val(count);
            changeSum(count, idStr);
        });

        $(".delete-btn").click(function () {
            var id = parseInt($(this).data("itemid"));
            deleteCartItem(id);
        });
    });
</script>
