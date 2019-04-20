<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/"/>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link href="jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">

        $(function () {

            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });

            $("#addBtn").bind("click", function () {
                $.ajax({
                    type: "get",
                    url: "workbench/clue/getUserList.do",
                    data: {},
                    async: true,
                    success: function (data) {
                        var html = "<option></option>"

                        $.each(data, function (i, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>"
                        })
                        $("#create-owner").html(html)
                        $("#create-owner").val("${user.id}")

                        $("#createClueModal").modal("show")
                    },
                    error: function () {
                        alert("服务器维护中...")
                    },
                    dataType: "json"
                })
            })

            //为模态窗口的保存按钮绑定添加事件
            $("#saveBtn").click(function () {
                $.ajax({
                    type: "post",
                    url: "workbench/clue/save.do",
                    data: {
                        "fullname": $.trim($("#create-fullname").val()),
                        "appellation": $.trim($("#create-appellation").val()),
                        "owner": $.trim($("#create-owner").val()),
                        "company": $.trim($("#create-company").val()),
                        "job": $.trim($("#create-job").val()),
                        "email": $.trim($("#create-email").val()),
                        "phone": $.trim($("#create-phone").val()),
                        "website": $.trim($("#create-website").val()),
                        "mphone": $.trim($("#create-mphone").val()),
                        "state": $.trim($("#create-state").val()),
                        "source": $.trim($("#create-source").val()),
                        "description": $.trim($("#create-description").val()),
                        "contactSummary": $.trim($("#create-contactSummary").val()),
                        "nextContactTime": $.trim($("#create-nextContactTime").val()),
                        "address": $.trim($("#create-address").val())
                    },
                    async: true,
                    success: function (data) {
                        if (data.success) {

                            //pageList()

                            $("#createClueForm")[0].reset()

                            $("#createClueModal").modal("hide")

                            pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            alert(data.msg)
                        }
                    },
                    error: function () {
                        alert("服务器维护中...")
                    },
                    dataType: "json"
                })
            })

            //页面加载完成后展示线索列表
            pageList(1, 3)

            $("#searchBtn").click(function () {
                //将搜索框中的内容保存到隐藏域
                $("#hidden-fullname").val($.trim($("#search-fullname").val()))
                $("#hidden-company").val($.trim($("#search-company").val()))
                $("#hidden-phone").val($.trim($("#search-phone").val()))
                $("#hidden-source").val($.trim($("#search-source").val()))
                $("#hidden-owner").val($.trim($("#search-owner").val()))
                $("#hidden-mphone").val($.trim($("#search-mphone").val()))
                $("#hidden-state").val($.trim($("#search-state").val()))

                pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
            })

        });

        function pageList(pageNo, pageSize) {

            //读取隐藏域中的内容到搜索框
            $("#search-fullname").val($.trim($("#hidden-fullname").val()))
            $("#search-company").val($.trim($("#hidden-company").val()))
            $("#search-phone").val($.trim($("#hidden-phone").val()))
            $("#search-source").val($.trim($("#hidden-source").val()))
            $("#search-owner").val($.trim($("#hidden-owner").val()))
            $("#search-mphone").val($.trim($("#hidden-mphone").val()))
            $("#search-state").val($.trim($("#hidden-state").val()))

            $.ajax({
                type: "get",
                url: "workbench/clue/pageList.do",
                data: {
                    "fullname": $.trim($("#search-fullname").val()),
                    "company": $.trim($("#search-company").val()),
                    "phone": $.trim($("#search-phone").val()),
                    "source": $.trim($("#search-source").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "mphone": $.trim($("#search-mphone").val()),
                    "state": $.trim($("#search-state").val()),
                    "pageNo": pageNo,
                    "pageSize": pageSize
                },
                async: true,
                success: function (data) {

                    //data:{"total":?,"dataList":[{线索1},{线索2},{线索3},...]}

                    var html = ""

                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">'
                        html += '<td><input type="checkbox" id="' + n.id + '"/></td>'
                        html += '<td><a href="javascript:void(0)" onclick="window.location.href=\'workbench/clue/detail.do?id=' + n.id + '\'" style="text-decoration: none; cursor: pointer;" >' + n.fullname + n.appellation + '</a></td>'
                        html += '<td>' + n.company + '</td>'
                        html += '<td>' + n.phone + '</td>'
                        html += '<td>' + n.mphone + '</td>'
                        html += '<td>' + n.source + '</td>'
                        html += '<td>' + n.owner + '</td>'
                        html += '<td>' + n.state + '</td>'
                        html += '</tr>'
                    })

                    $("#clueBody").html(html)

                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1

                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });

                },
                error: function () {
                    alert("服务器维护中...")
                },
                dataType: "json"
            })

        }

    </script>
</head>
<body>

<input type="hidden" id="hidden-fullname">
<input type="hidden" id="hidden-company">
<input type="hidden" id="hidden-phone">
<input type="hidden" id="hidden-source">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-mphone">
<input type="hidden" id="hidden-state">

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="createClueForm">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者
                            <span style="font-size: 15px; color: red;">*</span>
                        </label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <%--<option>zhangsan</option>--%>
                                <%--<option>lisi</option>--%>
                                <%--<option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <%--<option>先生</option>--%>
                                <%--<option>夫人</option>--%>
                                <%--<option>女士</option>--%>
                                <%--<option>博士</option>--%>
                                <%--<option>教授</option>--%>
                                <c:forEach items="${appellationList}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-fullname" class="col-sm-2 control-label">
                            姓名<span style="font-size: 15px; color: red;">*</span>
                        </label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-state" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <option></option>
                                <%--<option>试图联系</option>--%>
                                <%--<option>将来联系</option>--%>
                                <%--<option>已联系</option>--%>
                                <%--<option>虚假线索</option>--%>
                                <%--<option>丢失线索</option>--%>
                                <%--<option>未联系</option>--%>
                                <%--<option>需要条件</option>--%>
                                <c:forEach items="${clueStateList}" var="c">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <%--<option>广告</option>--%>
                                <%--<option>推销电话</option>--%>
                                <%--<option>员工介绍</option>--%>
                                <%--<option>外部介绍</option>--%>
                                <%--<option>在线商场</option>--%>
                                <%--<option>合作伙伴</option>--%>
                                <%--<option>公开媒介</option>--%>
                                <%--<option>销售邮件</option>--%>
                                <%--<option>合作伙伴研讨会</option>--%>
                                <%--<option>内部研讨会</option>--%>
                                <%--<option>交易会</option>--%>
                                <%--<option>web下载</option>--%>
                                <%--<option>web调研</option>--%>
                                <%--<option>聊天</option>--%>
                                <c:forEach items="${sourceList}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">线索描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <option></option>
                                <option selected>先生</option>
                                <option>夫人</option>
                                <option>女士</option>
                                <option>博士</option>
                                <option>教授</option>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" value="李四">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-status">
                                <option></option>
                                <%--<option>试图联系</option>--%>
                                <%--<option>将来联系</option>--%>
                                <%--<option selected>已联系</option>--%>
                                <%--<option>虚假线索</option>--%>
                                <%--<option>丢失线索</option>--%>
                                <%--<option>未联系</option>--%>
                                <%--<option>需要条件</option>--%>
                                <c:forEach items="${clueStateList}" var="c">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <%--<option selected>广告</option>--%>
                                <%--<option>推销电话</option>--%>
                                <%--<option>员工介绍</option>--%>
                                <%--<option>外部介绍</option>--%>
                                <%--<option>在线商场</option>--%>
                                <%--<option>合作伙伴</option>--%>
                                <%--<option>公开媒介</option>--%>
                                <%--<option>销售邮件</option>--%>
                                <%--<option>合作伙伴研讨会</option>--%>
                                <%--<option>内部研讨会</option>--%>
                                <%--<option>交易会</option>--%>
                                <%--<option>web下载</option>--%>
                                <%--<option>web调研</option>--%>
                                <%--<option>聊天</option>--%>
                                <c:forEach items="${sourceList}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-fullname">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text" id="search-company">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="search-phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="search-source">
                            <option></option>
                            <%--<option>广告</option>--%>
                            <%--<option>推销电话</option>--%>
                            <%--<option>员工介绍</option>--%>
                            <%--<option>外部介绍</option>--%>
                            <%--<option>在线商场</option>--%>
                            <%--<option>合作伙伴</option>--%>
                            <%--<option>公开媒介</option>--%>
                            <%--<option>销售邮件</option>--%>
                            <%--<option>合作伙伴研讨会</option>--%>
                            <%--<option>内部研讨会</option>--%>
                            <%--<option>交易会</option>--%>
                            <%--<option>web下载</option>--%>
                            <%--<option>web调研</option>--%>
                            <%--<option>聊天</option>--%>
                            <c:forEach items="${applicationScope.sourceList}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text" id="search-mphone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="search-state">
                            <option></option>
                            <%--<option>试图联系</option>--%>
                            <%--<option>将来联系</option>--%>
                            <%--<option>已联系</option>--%>
                            <%--<option>虚假线索</option>--%>
                            <%--<option>丢失线索</option>--%>
                            <%--<option>未联系</option>--%>
                            <%--<option>需要条件</option>--%>
                            <c:forEach items="${clueStateList}" var="c">
                                <option value="${c.value}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="clueBody">
                <%--<tr>--%>
                <%--<td><input type="checkbox"/></td>--%>
                <%--<td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--onclick="window.location.href='workbench/clue/detail.do?id=be8118b57a0d4d64a760f31c8450ce95';">刘强东博士</a></td>--%>
                <%--<td>动力节点</td>--%>
                <%--<td>010-84846003</td>--%>
                <%--<td>12345678901</td>--%>
                <%--<td>广告</td>--%>
                <%--<td>zhangsan</td>--%>
                <%--<td>已联系</td>--%>
                <%--</tr>--%>
                <%--<tr class="active">--%>
                <%--<td><input type="checkbox"/></td>--%>
                <%--<td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--onclick="window.location.href='workbench/clue/detail.do?id=28d705dff35a4e7a98224d27b286f891';">李彦宏先生</a></td>--%>
                <%--<td>动力节点</td>--%>
                <%--<td>010-84846003</td>--%>
                <%--<td>12345678901</td>--%>
                <%--<td>广告</td>--%>
                <%--<td>zhangsan</td>--%>
                <%--<td>已联系</td>--%>
                <%--</tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage"></div>
        </div>

    </div>

</div>
</body>
</html>