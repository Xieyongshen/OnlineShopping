<%@ page import="beans.ProductBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="head.jsp" %>
    <title>商品详情 -
        <jsp:useBean id="connShop" scope="session" class="beans.ShopConn"/>
        <%
            String productIDStr = request.getParameter("id");
            String productName = "该商品不存在";
            String productUrl = "";
            String productDescription = "";
            Double productPrice = 0.0;
            int productSold = 0;
            int productRemains = 0;
            int productID = productIDStr == null ? 0 : Integer.parseInt(productIDStr);
            ProductBean product = connShop.getAProduct(productID);
            if (product != null) {
                productName = product.getName();
                productUrl = product.getUrl();
                productDescription = product.getDescription();
                productPrice = product.getPrice();
                productSold = product.getSold();
                productRemains = product.getRemains();
                out.println(productName);
            }else{
        %>
        <script type="text/javascript">alert("商品不存在！");
        window.location.href = "shop";</script>
        <%
            }
        %>
    </title>
</head>
<body>
<%@ include file="navBar.jsp" %>
<div class="page-product">
    <div class="product-container">
        <div class="product-body">
            <img src="<% out.print(productUrl); %>" alt="商品图片" class="product-img"/>
            <div class="product-info">
                <div class="product-name">
                    <% out.print(productName); %>
                </div>
                <div class="product-description">
                    <% out.print(productDescription); %>
                </div>
                <div class="product-price">
                    ￥<span><% out.print(productPrice); %></span>
                </div>
                <div class="product-nums">
                    <div class="nums-item">
                        已售：<% out.print(productSold); %>件
                    </div>
                    <div class="nums-item">
                        库存：<span id="productRemains"><% out.print(productRemains); %></span>件
                    </div>
                </div>
                <div class="product-count">
                    <div class="product-count-minus product-count-item" onclick="countMinus()">-</div>
                    <input type="text" id="productCount" class="product-count-num product-count-item" value="1"/>
                    <div class="product-count-add product-count-item" onclick="countAdd()">+</div>
                </div>
                <button class="btn product-btn" onclick="addToCart()">加入购物车</button>
            </div>
        </div>
    </div>
    <div class="modal fade" id="addSuccess" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button
                            type="button"
                            class="close"
                            data-dismiss="modal"
                            aria-label="Close"
                    >
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">添加成功</h4>
                </div>
                <div class="modal-body">
                    <p>成功将<span id="countHint"></span>件<% out.print(productName); %>添加到购物车！</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" onclick="window.location.href='shop'">
                        返回商品列表
                    </button>
                    <button type="button" class="btn btn-primary" onclick="window.location.href='cart'">
                        去购物车结算
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<script type="text/javascript">
    function countMinus() {
        var productInput = $("#productCount");
        var count = parseInt(productInput.val());
        if (count > 0) count--;
        productInput.val(count);
    }

    function countAdd() {
        var productInput = $("#productCount");
        var count = parseInt(productInput.val());
        var remainsStr = <% out.print(productRemains); %>;
        var remains = parseInt(remainsStr);
        if (count < remains) count++;
        productInput.val(count);
    }

    function addToCart() {
        var productInput = $("#productCount");
        var count = parseInt(productInput.val());
        var idStr = <% out.print(productID); %>;
        var found = false;
        if (count == 0) {
            alert("数量不能为0");
        } else {
            var cartStr = $.cookie('cart');
            var cart = [];
            if (cartStr) cart = JSON.parse(cartStr);
            for (var i = 0; i < cart.length; i++) {
                if (cart[i].id == idStr) {
                    var ecount = parseInt(cart[i].count);
                    ecount += count;
                    cart[i].count = ecount;
                    found = true;
                }
            }
            if (!found) {
                cart.push({
                    id: idStr,
                    name: "<% out.print(productName); %>",
                    url: "<% out.print(productUrl); %>",
                    price: <% out.print(productPrice); %>,
                    count: count
                })
            }
            var cartJSON = JSON.stringify(cart);
            $.cookie('cart', cartJSON);
            console.log(cart);
            $("#countHint").text(count);
            $("#addSuccess").modal();
        }
    }

    $(document).ready(function () {
        var productInput = $("#productCount");
        productInput.change(function () {
            var count = parseInt(productInput.val());
            var remainsStr = <% out.print(productRemains); %>;
            var remains = parseInt(remainsStr);
            if (!count) count = 0;
            if (count > remains) {
                count = remains;
            } else if (count < 0) {
                count = 0;
            }
            productInput.val(count);
        })
    });
</script>
<style type="text/css">
    .product-container {
        margin-top: 50px;
        padding: 50px 0;
        border-top: 3px solid #ff2832;
        border-bottom: 3px solid #ff2832;
    }

    .product-body {
        width: 902px;
        margin: 0 auto;
        padding: 30px;
        text-align: left;
        border: 1px solid #ddd;
        box-shadow: 1px 1px 3px #dcdcdc;
    }

    .product-img {
        width: 300px;
        height: 300px;
        margin-right: 35px;
    }

    .product-info {
        width: 500px;
        height: 300px;
        display: inline-block;
        vertical-align: top;
        position: relative;
    }

    .product-name {
        color: #323232;
        font-size: 24px;
        line-height: 40px;
        font-weight: 700;
    }

    .product-description {
        color: #888888;
        font-size: 14px;
        line-height: 30px;
    }

    .product-price {
        color: #e52222;
        font-size: 18px;
        line-height: 40px;
        position: absolute;
        bottom: 120px;
    }

    .product-price span {
        font-size: 30px;
    }

    .product-nums {
        position: absolute;
        bottom: 70px;
    }

    .nums-item {
        width: 200px;
        font-size: 16px;
        line-height: 40px;
        display: inline-block;
    }

    .product-count {
        position: absolute;
        bottom: 0;
    }

    .product-count-item {
        width: 52px;
        height: 52px;
        font-size: 20px;
        line-height: 50px;
        text-align: center;
        margin: 0;
        border: 1px solid #dcdcdc;
        display: inline-block;
    }

    .product-count-minus,
    .product-count-add {
        background: #eee;
        cursor: pointer;
        user-select: none;
    }

    .product-count-minus:hover,
    .product-count-add:hover {
        color: #ff2832;
        background: #fff5f5;
    }

    .product-count-num {
        width: 60px;
        outline: none;
    }

    .product-btn {
        width: 150px;
        height: 50px;
        color: #fff;
        font-size: 18px;
        line-height: 40px;
        text-align: center;
        margin: 0;
        padding: 0;
        border: none;
        background: #ff2832;
        outline: none !important;
        position: absolute;
        bottom: 1px;
        left: 200px;
    }

    .product-btn:hover,
    .product-btn:active,
    .product-btn:focus,
    .product-btn:visited {
        color: #fff;
        background: #ff2832;
        outline: none;
    }
</style>
