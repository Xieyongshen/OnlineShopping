<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="pages/head.jsp" %>
    <title>登录/注册</title>
    <style type="text/css">
        body {
            background: #CCCCFF;
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

        .index-login {
            width: 400px;
            margin: 100px auto 0 auto;
            padding: 30px;
            border: 1px solid #dcdcdc;
            background: #ffffff;
            box-shadow: 1px 1px 1px #dcdcdc;
        }

        .index-login>ul{
            display: flex;
            flex-direction: row;
            justify-content : space-between;
        }

        .index-login>ul>li{
            width: 49%;
            text-align: center;
        }

        .index-login .tab-content {
            padding-top: 20px;
        }

        .login-form form {
            margin: 0;
        }

        .login-form label {
            line-height: 30px;
        }

        .btn-submit {
            width: 100%;
            height: 42px;
            line-height: 40px;
            margin-top: 20px;
            padding: 0;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="index-login">
        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" class="active">
                <a href="#login" aria-controls="home" role="tab" data-toggle="tab">登录</a>
            </li>
            <li role="presentation">
                <a href="#register" aria-controls="profile" role="tab" data-toggle="tab">注册</a>
            </li>
        </ul>
        <div class="tab-content">
            <div role="tabpanel" class="tab-pane active" id="login">
                <form id="loginForm" action="UserServlet" method="get">
                    <div class="form-group">
                        <label for="username">用户名</label>
                        <input type="text" name="loginName" class="form-control" id="username" placeholder="Username">
                    </div>
                    <div class="form-group">
                        <label for="password">密码</label>
                        <input type="password" name="loginPassword" class="form-control" id="password"
                               placeholder="Password">
                    </div>
                    <button type="submit" name="action" value="login" class="btn btn-primary btn-submit">登 录</button>
                </form>
            </div>
            <div role="tabpanel" class="tab-pane" id="register">
                <form id="regForm" action="UserServlet" method="get">
                    <div class="form-group">
                        <label for="regUsername">用户名</label>
                        <input type="text" name="regUserName" class="form-control register-input" id="regUsername"
                               placeholder="Username"
                               data-toggle="tooltip" data-placement="bottom" title="4-16位数字、字母、下划线">
                    </div>
                    <div class="form-group">
                        <label for="regPassword">密码</label>
                        <input type="password" name="regPassword" class="form-control register-input" id="regPassword"
                               placeholder="Password"
                               data-toggle="tooltip" data-placement="bottom" title="6-16位数字、字母">
                    </div>
                    <div class="form-group">
                        <label for="regEmail">邮箱</label>
                        <input type="text" name="regEmail" class="form-control register-input tooltip-manual"
                               id="regEmail" placeholder="Email"
                               data-toggle="tooltip" data-placement="bottom" title="邮箱格式不正确" data-trigger="manual">
                    </div>
                    <div class="form-group">
                        <label for="regPhone">电话</label>
                        <input type="text" name="regPhone" class="form-control register-input tooltip-manual"
                               id="regPhone" placeholder="Phone"
                               data-toggle="tooltip" data-placement="bottom" title="电话格式不正确" data-trigger="manual">
                    </div>
                    <div class="form-group">
                        <label for="regQQ">QQ</label>
                        <input type="text" name="regQQ" class="form-control register-input tooltip-manual" id="regQQ"
                               placeholder="QQ"
                               data-toggle="tooltip" data-placement="bottom" title="QQ格式不正确" data-trigger="manual">
                    </div>
                    <button type="submit" name="action" value="register" class="btn btn-primary btn-submit">注 册</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<%
    //登录/注册页面错误类别：0-正常，1-密码错误，2-用户不存在，3-登录失败，4-注册用户名已存在，5-注册失败
    int indexError = request.getSession().getAttribute("indexErr") == null ? 0 : (int)request.getSession().getAttribute("indexErr");
    if(indexError != 0){
        String alertMsg = "";
        switch (indexError){
            case 1:
                alertMsg = "密码错误！请重新登录";
                break;
            case 2:
                alertMsg = "用户不存在！";
                break;
            case 3:
                alertMsg = "登录失败！请重新登录";
                break;
            case 4:
                alertMsg = "注册用户名已存在！请重新输入";
                break;
            case 5:
                alertMsg = "注册失败！请重新注册";
                break;
            default:
                break;
        }
        if(alertMsg.length() > 0){
            out.print("<script type=\"text/javascript\">alert(\"" + alertMsg + "\");</script>");
        }
    }
    request.getSession().setAttribute("indexErr", 0);
%>
<script type="text/javascript">
    function testRegForm() {
        var testRes = true;

        var usernamePat = /^[a-zA-Z0-9_]{4,16}$/;
        var passwordPat = /^[a-zA-Z0-9]{6,16}$/;
        var emailPat = /^[a-zA-Z0-9]{1,10}@[a-zA-Z0-9]{1,5}\.[a-zA-Z0-9]{1,5}$/;
        var phonePat = /^1[34578]\d{9}$/;
        var qqPat = /^[1-9][0-9]{5,10}$/;

        var username = $("#regUsername");
        var password = $("#regPassword");
        var email = $("#regEmail");
        var phone = $("#regPhone");
        var QQ = $("#regQQ");

        if (!usernamePat.test(username.val())) {
            username.tooltip('show');
            testRes = false;
        }
        if (!passwordPat.test(password.val())) {
            password.tooltip('show');
            testRes = false;
        }
        if (!emailPat.test(email.val())) {
            email.tooltip('show');
            testRes = false;
        }
        if (!phonePat.test(phone.val())) {
            phone.tooltip('show');
            testRes = false;
        }
        if (!qqPat.test(QQ.val())) {
            QQ.tooltip('show');
            testRes = false;
        }

        return testRes;
    }

    $(document).ready(function () {
        $('[data-toggle="tooltip"]').tooltip();
        $(".tooltip-manual").focus(function () {
            $(this).tooltip('hide');
        });
        $('#regForm').submit(function () {
            if (!testRegForm()) {
                event.preventDefault();
            }
        })
    });
</script>
