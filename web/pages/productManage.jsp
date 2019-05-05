<%@ page import="beans.CategoryBean" %>
<%@ page import="beans.ProductBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style type="text/css">
    button {
        outline: none;
    }

    .productManage-body {
        padding: 30px 20px;
        text-align: center;
        position: relative;
    }

    .productManage-filter {
        margin-bottom: 20px;
    }

    .productManage-cate {
        margin-left: 20px;
    }

    .productManage-cate, .productManage-search {
        display: inline-block;
    }

    #cateSelect {
        width: 150px;
        display: inline-block;
    }

    .productManage-search {
        float: right;
    }

    #searchForm {
        margin: 0;
    }

    .search-input {
        width: 300px;
        margin-right: 5px;
        display: inline-block;
    }

    .productManage-table > thead > tr > th {
        text-align: center;
    }

    .productManage-table > tbody > tr > td {
        height: 100px;
        font-size: 14px;
        line-height: 80px;
        text-align: center;
        padding: 10px;
    }

    .product-detail {
        text-align: left !important;
    }

    .product-img {
        width: 80px;
        height: 80px;
        margin-right: 10px;
        vertical-align: top;
    }

    .product-info {
        display: inline-block;
        vertical-align: top;
    }

    .product-name {
        max-width: 250px;
        font-size: 14px;
        line-height: 30px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .product-desc {
        font-size: 12px;
        line-height: 25px;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 2;
        overflow: hidden;
    }

    .product-btn {
        margin: 23px 0;
    }
</style>
<jsp:useBean id="connShop" scope="session" class="beans.ShopConn"/>
<%
    String searchStr = (String) request.getParameter("searchStr");
    CategoryBean[] categories = connShop.getCategories();
    ProductBean[] products = connShop.getProducts(0);
%>
<div class="manage-productManage">
    <div class="productManage-body">
        <div class="productManage-filter">
            <button type="button" id="productAdd" class="btn btn-primary" data-toggle="modal"
                    data-target="#productModal">添加商品
            </button>
            <div class="productManage-cate">
                <label for="cateSelect">筛选商品：</label>
                <select id="cateSelect" class="form-control">
                    <option data-cateid="0">全部商品</option>
                    <%
                        for (CategoryBean category : categories) {
                    %>
                    <option data-cateid="<% out.print(category.getCategoryID()); %>"><%
                        out.print(category.getName()); %></option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="productManage-search">
                <form id="searchForm" action="manage" method="get">
                    <input name="searchStr" type="text" id="searchInput" class="form-control search-input"
                           value="<% if(searchStr != null) out.print(searchStr); %>" placeholder="输入商品名称进行查询"/>
                    <button type="submit" class="btn btn-primary">搜索</button>
                </form>
            </div>
        </div>
        <div class="productManage-products">
            <table class="table table-hover productManage-table">
                <thead>
                <tr>
                    <th>编号</th>
                    <th>种类</th>
                    <th>商品</th>
                    <th>价格</th>
                    <th>库存</th>
                    <th>销量</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (ProductBean product : products) {
                        if(searchStr != null && product.getName().indexOf(searchStr) < 0) continue;
                        int cateID = product.getCategory();
                %>
                <tr class="products-item product-cate<% out.print(cateID); %>" data-proid="<% out.print(product.getProductID()); %>">
                    <td class="product-id product-item"><% out.print(product.getProductID()); %></td>
                    <td class="product-cate product-item" data-cateid="<% out.print(cateID); %>">
                        <%
                            for (CategoryBean cate : categories) {
                                if (cateID == cate.getCategoryID()) {
                                    out.print(cate.getName());
                                    break;
                                }
                            }
                        %>
                    </td>
                    <td class="product-detail product-item">
                        <img src="<% out.print(product.getUrl()); %>" class="product-img"/>
                        <div class="product-info">
                            <div class="product-name"><a href="product?id=<% out.print(product.getProductID()); %>" title="<% out.print(product.getName()); %>"><% out.print(product.getName()); %></a></div>
                            <div class="product-desc"><% out.print(product.getDescription()); %></div>
                        </div>
                    </td>
                    <td class="product-price product-item"><% out.print(product.getPrice()); %></td>
                    <td class="product-remains product-item"><% out.print(product.getRemains()); %></td>
                    <td class="product-sold product-item"><% out.print(product.getSold()); %></td>
                    <td class="product-edit product-item">
                        <button type="button" class="btn btn-default product-btn" data-toggle="modal"
                                data-target="#productModal">编辑
                        </button>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
    <div class="modal fade" id="productModal" tabindex="-1" role="dialog" aria-labelledby="modalTitle">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form id="productForm" action="ShopServlet" method="post">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="modalTitle">添加商品</h4>
                    </div>
                    <div class="modal-body">
                        <div id="formWithID" class="form-group">
                            <label for="productID">商品编号</label>
                            <input type="text" class="form-control" id="productID" name="productID" disabled>
                        </div>
                        <div class="form-group">
                            <label for="productCate">商品种类</label>
                            <select id="productCate" name="productCate" class="form-control">
                                <%
                                    for (CategoryBean category : categories) {
                                %>
                                <option id="cateSelect<% out.print(category.getCategoryID()); %>" value="<% out.print(category.getCategoryID()); %>"><%out.print(category.getName()); %></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="productName">商品名称</label>
                            <input type="text" class="form-control" id="productName" name="productName"
                                   placeholder="商品名称">
                        </div>
                        <div class="form-group">
                            <label for="productDesc">商品描述</label>
                            <input type="text" class="form-control" id="productDesc" name="productDesc"
                                   placeholder="商品描述">
                        </div>
                        <div class="form-group">
                            <label for="productImg">商品图片</label>
                            <input type="file" id="productImg" name="productImg">
                            <img src="" id="productImgShow">
                        </div>
                        <div class="form-group">
                            <label for="productPrice">商品价格</label>
                            <input type="number" min="0.01" step="0.01" class="form-control" id="productPrice" name="productPrice"
                                   placeholder="商品价格">
                        </div>
                        <div class="form-group">
                            <label for="productRemains">商品库存</label>
                            <input type="number" min="0" class="form-control" id="productRemains" name="productRemains"
                                   placeholder="商品库存">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary" id="btnAdd" name="action" value="add">添加</button>
                        <button type="submit" class="btn btn-primary" id="btnEdit" name="action" value="update">保存
                        </button>
                        <button type="submit" class="btn btn-danger" id="btnDelete" name="action" value="delete">删除
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        var mode = 0;

        $("#searchForm").submit(function () {
            var selectInput = "<input name='select' value='0'>";
            $("#searchForm").prepend(selectInput);
            var searchInput = $("#searchInput");
            var searchVal = searchInput.val();
            searchVal = searchVal.replace(/\s*/g, "");
            searchInput.val(searchVal);
        });

        $("#cateSelect").change(function () {
            var curOption = $("#cateSelect option:selected");
            var curCate = curOption.data("cateid");
            $(".products-item").hide();
            if (curCate == "0") {
                $(".products-item").show();
            } else {
                var cateClass = ".product-cate" + curCate;
                $(cateClass).show();
            }
        });

        $("#productAdd").click(function () {
            $("#modalTitle").text("添加商品");
            $("#formWithID").hide();
            $("#btnEdit").hide();
            $("#btnDelete").hide();
            $("#btnAdd").show();
        });

        $(".product-btn").click(function () {
            $("#modalTitle").text("编辑商品");
            $("#formWithID").show();
            $("#btnEdit").show();
            $("#btnDelete").show();
            $("#btnAdd").hide();
            var proID = $(this).parents(".products-item").data("proid");
            var proCate = $(this).parent().siblings(".product-cate").data("cateid");
            var proName = $(this).parent().siblings(".product-detail").find(".product-name").text();
            var proDesc = $(this).parent().siblings(".product-detail").find(".product-desc").text();
            var proUrl = $(this).parent().siblings(".product-detail").find(".product-img").attr("src");
            var proPrice = $(this).parent().siblings(".product-price").text();
            var proRemains = $(this).parent().siblings(".product-remains").text();
            var proSold = $(this).parent().siblings(".product-sold").text();
            var cateSelect = "#cateSelect" + proCate;
            $(cateSelect).attr("selected", true);
            $("#productID").val(proID);
            $("#productName").val(proName);
            $("#productDesc").val(proDesc);
            $("#productImgShow").attr("src", proUrl);
            $("#productPrice").val(proPrice);
            $("#productRemains").val(proRemains);
        });

        $("#productImg").change(function (e) {
            var file = e.target.files || e.dataTransfer.files;
            if (file) {
                var reader = new FileReader();
                reader.onload = function () {
                    $("#productImgShow").attr("src", this.result);
                };
                reader.readAsDataURL(file[0]);
            }
        });

        $("#productPrice").change(function () {
            var priceStr = $(this).val();
            var price = parseFloat(priceStr);
            if(price == NaN || price <= 0) price = 0.01;
            price = price.toFixed(2);
            $(this).val(price);
        });

        $("#productRemains").change(function () {
            var remainsStr = $(this).val();
            var remains = parseInt(remainsStr);
            if(remains == NaN || remains < 0) remains = 0;
            $(this).val(remains);
        });

        $("#productForm").submit(function () {
            $("#productID").attr("disabled", false);
            if (!testProForm()) {
                event.preventDefault();
            }
        })
    });

    function testProForm() {
        var name = $("#productName").val();
        if(name == null || name.length == 0){
            alert("商品名称不能为0！");
            return false;
        }
        return true;
    }
</script>
