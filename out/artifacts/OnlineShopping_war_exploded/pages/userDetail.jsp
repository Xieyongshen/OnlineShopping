<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style type="text/css">
    .UserDetail-body {
        min-height: 400px;
        padding: 30px 50px;
        text-align: center;
        position: relative;
    }

    .UserDetail-table > tbody > tr > td {
        font-size: 16px;
        line-height: 40px;
        text-align: left;
        border: none;
        overflow: hidden;
    }

    .UserDetail-table label {
        font-weight: 500;
        margin: 0;
    }

    .UserDetail-table > tbody > tr > td.hint {
        color: #999;
        user-select: none;
    }

    .UserDetail-table > tbody > tr > td.detail-title {
        width: 150px !important;
        text-align: right;
        vertical-align: top;
        margin: 0;
        padding-right: 20px;
    }

    .detail-input {
        display: none;
    }

    .detail-input-box {
        width: 250px;
        height: 30px;
        padding: 0 10px;
    }

    .UserDetail-table ul {
        padding-inline-start: 20px;
    }

    #btnGroup {
        display: none;
    }

    #btnCancel {
        margin-left: 30px;
    }
</style>
<%
    UserBean user = connUser.queryAUser(userID);
    username = user.getName();
    String email = user.getEmail();
    String phone = user.getPhone();
    String address = user.getAddress();
    String QQ = user.getQQ();
    String recipient = user.getRecipient();
%>
<div class="user-userDetail">
    <div class="UserDetail-body">
        <form action="UserServlet" method="get">
            <table class="table UserDetail-table">
                <tr>
                    <td class="detail-title">用户名：</td>
                    <td><% out.print(username); %></td>
                </tr>
                <tr>
                    <td class="detail-title">
                        <label for="userEmail">邮箱：</label>
                    </td>
                    <td class="detail-info <% if(email.length() == 0) out.print("hint"); %>"><% out.print(email.length() == 0 ? "未填写" : email); %></td>
                    <td class="detail-input">
                        <input type="text"
                               class="form-control detail-input-box"
                               value="<% out.print(email); %>"
                               name="userEmail" id="userEmail"/>
                    </td>
                </tr>
                <tr>
                    <td class="detail-title">
                        <label for="userPhone">电话：</label>
                    </td>
                    <td class="detail-info <% if(phone.length() == 0) out.print("hint"); %>"><% out.print(phone.length() == 0 ? "未填写" : phone); %></td>
                    <td class="detail-input">
                        <input type="text"
                               class="form-control detail-input-box"
                               value="<% out.print(phone); %>"
                               name="userPhone" id="userPhone"/>
                    </td>
                </tr>
                <tr>
                    <td class="detail-title">
                        <label for="userAddress">地址：</label>
                    </td>
                    <td class="detail-info <% if(address.length() == 0) out.print("hint"); %>"><% out.print(address.length() == 0 ? "未填写" : address); %></td>
                    <td class="detail-input">
                        <input type="text"
                               class="form-control detail-input-box"
                               value="<% out.print(address); %>"
                               name="userAddress" id="userAddress"/>
                    </td>
                </tr>
                <tr>
                    <td class="detail-title">
                        <label for="userQQ">QQ：</label>
                    </td>
                    <td class="detail-info <% if(QQ.length() == 0) out.print("hint"); %>"><% out.print(QQ.length() == 0 ? "未填写" : QQ); %></td>
                    <td class="detail-input">
                        <input type="text"
                               class="form-control detail-input-box"
                               value="<% out.print(QQ); %>"
                               name="userQQ" id="userQQ"/>
                    </td>
                </tr>
                <tr>
                    <td class="detail-title">
                        <label for="userRecipient">收件人：</label>
                    </td>
                    <td class="detail-info <% if(recipient.length() == 0) out.print("hint"); %>"><% out.print(recipient.length() == 0 ? "未填写" : recipient); %></td>
                    <td class="detail-input">
                        <input type="text"
                               class="form-control detail-input-box"
                               value="<% out.print(recipient); %>"
                               name="userRecipient" id="userRecipient"/>
                    </td>
                </tr>
            </table>
            <div class="UserDetail-function">
                <button class="btn btn-default" id="btnModify">
                    修改资料
                </button>
                <div id="btnGroup">
                    <button type="submit" class="btn btn-default" id="btnSave" name="action" value="modify">
                        保存修改
                    </button>
                    <button class="btn btn-default btn-cancel" id="btnCancel">
                        取消修改
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $("#btnModify").click(function () {
            $(".detail-info").hide();
            $("#btnModify").hide();
            $(".detail-input").show();
            $("#btnGroup").show();
            event.preventDefault();
        });

        $("#btnSave").click(function () {
            $("#btnGroup").hide();
            $("#btnModify").show();
        });

        $("#btnCancel").click(function () {
            $(".detail-input").hide();
            $("#btnGroup").hide();
            $(".detail-info").show();
            $("#btnModify").show();
            event.preventDefault();
        });
    })
</script>