<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .searchBar {
        width: 1100px;
        margin: 50px auto;
        padding: 0 30px;
        text-align: left;
    }

    .searchBar-logo{
        display: inline-block;
    }

    .logo-img {
        width: 350px;
        height: 45px;
    }

    .search-body {
        margin: 5px 0;
        float: right;
    }

    .search-input {
        width: 500px !important;
        margin-right: 10px;
        display: inline-block;
    }

    #btnSearch {
        vertical-align: top;
    }
</style>
<div class="searchBar">
    <div class="searchBar-logo"><a href="shop"><img src="assets/logo.png" class="logo-img"></a></div>
    <div class="search-body">
        <input type="text" class="form-control search-input" placeholder="搜索商品名称"/>
        <button type="button" class="btn btn-primary" id="btnSearch">搜索</button>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $("#btnSearch").click(function () {
            var hrefStr = "shop?" + "<%
                    String cStr = request.getParameter("category");
                    int cNum = 0;
                    if(cStr != null && cStr.length() > 0) cNum = Integer.parseInt(cStr);
                    if(cNum != 0) out.print("category=" + cStr + "&");
                %>"
                + "searchStr=" + $(".search-input").val();
            window.location.href = hrefStr;
        })
    });
</script>
