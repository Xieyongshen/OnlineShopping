<%@ page import="beans.OrderBean" %>
<%@ page import="beans.OrderItemBean" %>
<%@ page import="beans.ProductBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style type="text/css">
    ::-webkit-scrollbar {
        width: 0;
    }

    .user-orderDetail {
        width: 700px;
        display: flex;
        flex-wrap: wrap;
    }

    .OrderList-body {
        min-height: 400px;
        padding: 30px 50px;
        text-align: center;
        position: relative;
    }

    .status-tab {
        color: #3399CC;
        line-height: 20px;
        margin-right: 2px;
        padding: 10px 15px;
        border: 1px solid transparent;
        border-radius: 4px 4px 0 0;
        cursor: pointer;
        position: relative;
        display: block;
    }

    .status-tab:hover {
        border-color: #eee #eee #ddd;
        background: #eee;
    }

    .OrderList-status li.active > .status-tab {
        color: #555;
        cursor: default;
        background-color: #fff;
        border: 1px solid #ddd;
        border-bottom-color: transparent;
    }

    .OrderList-search {
        margin: 20px 0;
        padding: 0 20px;
        text-align: left;
    }

    .search-input {
        width: 300px;
        display: inline-block;
    }

    .OrderList-header {
        height: 40px;
        padding: 0;
        background: #ececec;
        text-align: left;
    }

    .header-item {
        font-size: 14px;
        line-height: 40px;
        vertical-align: top;
        margin: 0;
        display: inline-block;
        text-align: center;
    }

    .header-book {
        width: 320px;
    }

    .header-price,
    .header-sum {
        width: 90px;
    }

    .header-count {
        width: 85px;
    }

    .orders-item {
        margin-top: 30px;
        border: 1px solid transparent;
        text-align: left;
    }

    .orders-item:hover .order-head,
    .orders-item:hover .order-foot {
        background: #daf3ff;
    }

    .order-head {
        height: 40px;
        font-size: 14px;
        line-height: 40px;
        text-align: left;
        padding: 0 20px;
        background: #ececec;
    }

    .order-time {
        display: inline-block;
    }

    .time-complete {
        float: right;
    }

    .order-img {
        width: 100px;
        height: 100px;
        margin: 10px 15px;
        display: inline-block;
    }

    .order-img > img {
        width: 100px;
        height: 100px;
    }

    .order-name {
        width: 185px;
        font-size: 14px;
        line-height: 30px;
        margin: 10px 0;
        padding: 10px 0;
        vertical-align: top;
        display: inline-block;
    }

    .order-name p {
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 2;
        overflow: hidden;
    }

    .order-item {
        font-size: 14px;
        line-height: 120px;
        text-align: center;
        vertical-align: top;
        display: inline-block;
    }

    .order-price,
    .order-sum {
        width: 90px;
    }

    .order-count {
        width: 85px;
    }

    .order-books {
        width: 600px;
        display: inline-block;
        vertical-align: top;
    }

    .order-book {
        width: 600px;
        border-left: 1px solid #dcdcdc;
        border-right: 1px solid #dcdcdc;
        border-top: 1px solid #dcdcdc;
        display: inline-block;
    }

    .order-book:first-child {
        border-top: none;
    }

    .order-foot {
        height: 40px;
        font-size: 14px;
        line-height: 40px;
        text-align: left;
        padding: 0 20px;
        background: #ececec;
    }

    .order-status {
        float: left;
    }

    .order-total {
        float: right;
    }
</style>
<jsp:useBean id="connOrder" scope="session" class="beans.OrderConn"/>
<%
    OrderBean[] orders = connOrder.queryOrders(userID);
    String searchStr = (String) request.getParameter("searchStr");
    if (searchStr == null) searchStr = "";
%>
<div class="user-orderDetail">
    <div class="OrderList-body">
        <div class="OrderList-status">
            <ul id="mySort" class="nav nav-tabs">
                <li role="presentation" class="active">
                    <div class="status-tab" data-status="-1">全部订单</div>
                </li>
                <li role="presentation">
                    <div class="status-tab" data-status="0">未完成</div>
                </li>
                <li role="presentation">
                    <div class="status-tab" data-status="1">已完成</div>
                </li>
            </ul>
        </div>
        <div class="OrderList-search">
            <form id="searchForm" action="user" method="get">
                查询订单：
                <input name="searchStr" type="text" id="searchInput" class="form-control search-input"
                       value="<% out.print(searchStr); %>" placeholder="输入商品名称进行查询"/>
                <button type="submit" class="btn btn-primary">搜索</button>
            </form>
        </div>
        <div class="OrderList-header">
            <div class="header-book header-item">商品</div>
            <div class="header-price header-item">单价</div>
            <div class="header-count header-item">数量</div>
            <div class="header-sum header-item">总价</div>
        </div>
        <div class="OrderList-orders">
            <%
                for (OrderBean order : orders) {
                    if (connOrder.searchInOrder(order, searchStr)) {
            %>
            <div class="orders-item status<% out.print(order.getStatus()); %>">
                <div class="order-head">
                    <div class="order-time">下单时间：<% out.print(order.getCreateTime()); %></div>
                    <% if (order.getStatus() == 1) { %>
                    <div class="order-time time-complete">完成时间：<% out.print(order.getCompleteTime()); %></div>
                    <% } %>
                </div>
                <div class="order-books">
                    <jsp:useBean id="connShop" scope="session" class="beans.ShopConn"/>
                    <%
                        ArrayList<OrderItemBean> items = order.getOrderList();
                        for (OrderItemBean item : items) {
                            int productID = item.getProductID();
                            ProductBean product = connShop.getAProduct(productID);
                    %>
                    <div class="order-book">
                        <a href='product?id=<% out.print(product.getProductID()); %>'
                           title="<% out.print(product.getName()); %>" class="order-img">
                            <img src="<% out.print(product.getUrl()); %>"/>
                        </a>
                        <div class="order-name">
                            <p><a href='product?id=<% out.print(product.getProductID()); %>'
                                  title="<% out.print(product.getName()); %>"><%
                                out.print(product.getName()); %></a></p>
                        </div>
                        <div class="order-price order-item">￥
                            <%
                                double proPrice = item.getSum() / item.getCount();
                                out.print(String.format("%.2f", proPrice));
                            %>
                        </div>
                        <div class="order-count order-item"><% out.print(item.getCount()); %></div>
                        <div class="order-sum order-item">￥<% out.print(item.getSum()); %></div>
                    </div>
                    <%
                        }
                    %>
                </div>
                <div class="order-foot">
                    <div class="order-status">订单状态：<% out.print(order.getStatus() == 0 ? "未完成" : "已完成"); %></div>
                    <div class="order-total">
                        共<% out.print(order.getOrderList().size()); %>件商品，总计：<% out.print(order.getTotal()); %>元
                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $(".status-tab").click(function () {
            var curTab = $(this);
            $(".status-tab").parent().removeClass("active");
            curTab.parent().addClass("active");
            var curStatus = curTab.data("status");
            $(".orders-item").hide();
            if (curStatus == "-1") {
                $(".orders-item").show();
            } else {
                var statusClass = ".status" + curStatus;
                $(statusClass).show();
            }
        });

        $("#searchForm").submit(function () {
            var selectInput = "<input name='select' value='1' hidden>";
            $("#searchForm").append(selectInput);
            var searchInput = $("#searchInput");
            var searchVal = searchInput.val();
            searchVal = searchVal.replace(/\s*/g, "");
            searchInput.val(searchVal);
        });
    })
</script> 