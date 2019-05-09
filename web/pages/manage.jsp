<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="head.jsp" %>
    <title>商店管理</title>
    <style type="text/css">
        .manage-body {
            width: 1000px;
            margin: 50px auto;
            position: relative;
            padding-left: 200px;
        }

        .manage-menu {
            width: 200px;
            position: absolute;
            top: 0;
            left: 0;
        }

        .manage-menu a {
            color: #323232;
            text-decoration: none;
        }

        .menu-all {
            width: 200px;
            height: 60px;
            color: #323232;
            font-size: 16px;
            line-height: 60px;
            text-align: center;
            background: #fafafa;
            border: 1px solid #dcdcdc;
            box-shadow: 0 1px 1px #dcdcdc;
        }

        .menu-all .glyphicon {
            color: #969696;
            margin-right: 10px;
        }

        .menu-items {
            width: 190px;
            margin: 0 auto;
            padding: 20px 0;
            background: #ffffff;
            border: 1px solid #dcdcdc;
            border-top: none;
            font-size: 16px;
            line-height: 40px;
            text-align: center;
            list-style-type: none;
        }

        .menu-items .active{
            color: #9966CC;
        }

        a.menu-choose:hover{
            color: #9966CC;
        }

        .manage-content {
            width: 750px;
            min-height: 500px;
            margin: 0 25px;
            border: 1px solid #dcdcdc;
            box-shadow: 0 1px 3px #d0d0d0;
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
%>
<%
    String select = (String) request.getParameter("select");
    int mode = -1;
    if (select == null || select.equals("0")) {
        mode = 0;
    } else if (select.equals("1")) {
        mode = 1;
    } else {
%>
<script type="text/javascript">window.location.href = "error";</script>
<%
    }
%>
<div class="page-manage">
    <div class="manage-body">
        <div class="manage-menu">
            <div class="menu-all">
                <div><span class="glyphicon glyphicon-edit"></span>商店管理</div>
            </div>
            <ul class="menu-items">
                <li><a href="manage?select=0" class="menu-choose <% if(mode == 0) out.print("active"); %>">商品管理</a></li>
                <li><a href="manage?select=1" class="menu-choose <% if(mode == 1) out.print("active"); %>">订单管理</a></li>
            </ul>
        </div>
        <div class="manage-content">
            <%
                if (mode == 0) {
            %>
            <%@ include file="productManage.jsp" %>
            <%
            } else if (mode == 1) {
            %>
            <%@ include file="orderManage.jsp" %>
            <%
                }
            %>
        </div>
    </div>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>
<script type="text/javascript">
    $(document).ready(function () {
        $(document).attr("title", "<%
            String title = "商店管理 - ";
            if(mode == 0){
                title = title + "商品管理";
            }else if(mode == 1){
                title = title + "订单管理";
            }
            out.print(title);
        %>");
    })
</script>