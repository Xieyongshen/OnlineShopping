<%@ page import="beans.UserBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style type="text/css">
    a{
        color: #323232;
    }

    a:hover, a:focus{
        color: #9966CC;
    }

    .btn-primary{
        background-color: #9966CC;
        border-color: #9966CC;
    }

    .btn-primary:active, .btn-primary:hover,.btn-primary:focus {
        color: #fff;
        background-color: #663399;
        border-color: #663399;
    }

    .nav-container {
        width: 100%;
        background: #f9f9f9;
        border-bottom: 1px solid #f2f2f2;
        z-index: 999;
    }

    .nav-container a{
        color: #666;
    }

    .nav-container a:hover{
        color: #9966CC;
    }

    .nav>li>a:focus, .nav>li>a:hover{
        background: #f9f9f9;
    }

    .nav-body {
        width: 1100px;
    }

    #userMenu {
        min-width: 120px;
        left: 50%;
        margin-left: -60px;
    }

    .glyphicon {
        margin-right: 5px;
    }
</style>
<%
    //状态标志：0-正常，1-修改资料成功，2-修改资料失败，3-提交订单成功，4-提交订单失败，
    // 5-商品添加成功，6-商品添加失败，7-商品修改成功，8-商品修改失败，9-商品删除成功，
    // 10-商品删除失败，11-订单发货成功，12-订单发货失败
    int statusFlag = request.getSession().getAttribute("statusFlag") == null ? 0 : (int)request.getSession().getAttribute("statusFlag");
    if(statusFlag != 0){
        String alertMsg = "";
        switch (statusFlag){
            case 1:
                alertMsg = "修改资料成功！";
                break;
            case 2:
                alertMsg = "修改资料失败！";
                break;
            case 3:
                alertMsg = "提交订单成功！";
                break;
            case 4:
                alertMsg = "提交订单失败！";
                break;
            case 5:
                alertMsg = "商品添加成功！";
                break;
            case 6:
                alertMsg = "商品添加失败！";
                break;
            case 7:
                alertMsg = "商品修改成功！";
                break;
            case 8:
                alertMsg = "商品修改失败！";
                break;
            case 9:
                alertMsg = "商品删除成功！";
                break;
            case 10:
                alertMsg = "商品删除失败！";
                break;
            case 11:
                alertMsg = "订单发货成功！";
                break;
            case 12:
                alertMsg = "订单发货失败！";
                break;
            default:
                break;
        }
        if(alertMsg.length() > 0){
            out.print("<script type=\"text/javascript\">alert(\"" + alertMsg + "\");</script>");
        }
    }
    request.getSession().setAttribute("statusFlag", 0);
%>
<jsp:useBean id="connUser" scope="session" class="beans.UserConn"/>
<nav class="navbar nav-container">
    <div class="container nav-body">
        <div class="navbar-header">
            <a class="navbar-brand" href="shop">Online Shopping</a>
        </div>
        <div class="navbar-function">
            <ul class="nav navbar-nav navbar-right">
                <%
                    String userID = (String) request.getSession().getAttribute("userID");
                    String username = (String) request.getSession().getAttribute("username");
                    if (userID != null && username != null) {
                %>
                <%
                    if (connUser.examineAdmin(userID)) {
                %>
                <li>
                    <a href="manage"><span class="glyphicon glyphicon-edit"></span> 商店管理</a>
                </li>
                <%
                    }
                %>
                <li>
                    <a href="cart"><span class="glyphicon glyphicon-shopping-cart"></span> 购物车</a>
                </li>
                <li class="dropdown" id="userBlock">
                    <a href="#" class="dropdown-toggle" role="button" aria-haspopup="true"
                       aria-expanded="false">
                        <%
                            out.println(username);
                        %>
                        <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu" id="userMenu">
                        <li><a href="user"><span class="glyphicon glyphicon-user"></span> 个人中心</a></li>
                        <li role="separator" class="divider"></li>
                        <li>
                            <a href="UserServlet" class="navbar-quit"><span class="glyphicon glyphicon-log-out"></span>
                                退出登录</a>
                        </li>
                    </ul>
                </li>
                <%
                } else {
                %>
                <li><a href="index">登录/注册</a></li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
</nav>
<script type="text/javascript">
    $(document).ready(function () {
        var userBlock = $("#userBlock");
        if(userBlock){
            userBlock.hover(function () {
                $("#userMenu").slideDown(100);
            }, function () {
                $("#userMenu").slideUp(100);
            })
        }
    })
</script>