<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%--<meta charset="UTF-8">--%>
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

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
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
                pickerPosition: "bottom-left"
            });


            $("#addBtn").bind("click", function () {
                $.ajax({
                    type: "get",
                    url: "workbench/activity/getUserList.do",
                    data: {},
                    async: true,
                    success: function (data) {
                        $("#activityAddForm")[0].reset();

                        // var html = ""
                        $("#create-owner").empty()
                        $.each(data, function (i, n) {
                            $("#create-owner").append("<option value='" + n.id + "'>" + n.name + "</option>")
                            // html += "<option value='" + n.id + "'>" + n.name + "</option>"
                        })
                        // $("#create-owner").html(html)
                        $("#create-owner").val("${user.id}") //在JS的字符串中使用EL表达式，选中当前登录用户

                        $("#createActivityModal").modal("show")
                    },
                    error: function () {
                        alert("服务器维护中...")
                    },
                    dataType: "json"
                })


            })

            $("#saveBtn").bind("click", function () {
                $.ajax({
                    type: "post",
                    url: "workbench/activity/save.do",
                    data: {
                        "owner": $.trim($("#create-owner").val()),
                        "name": $.trim($("#create-name").val()),
                        "startDate": $.trim($("#create-startDate").val()),
                        "endDate": $.trim($("#create-endDate").val()),
                        "cost": $.trim($("#create-cost").val()),
                        "description": $.trim($("#create-description").val())
                    },
                    async: true,
                    success: function (data) {
                        if (data.success) {
                            //仅成功添加市场活动后才清空表单内容
                            $("#activityAddForm")[0].reset();

                            $("#createActivityModal").modal("hide")

                            // pageList(1, 2)
                            pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            // alert("市场活动添加失败！")
                            alert(data.msg)
                        }
                    },
                    error: function () {
                        alert("服务器维护中...")
                    },
                    dataType: "json"
                })
            })

            $("#searchBtn").bind("click", function () {
                //点击查询按钮时，将查询信息保存到隐藏域
                $("#hidden-name").val($.trim($("#search-name").val()))
                $("#hidden-owner").val($.trim($("#search-owner").val()))
                $("#hidden-startDate").val($.trim($("#search-startDate").val()))
                $("#hidden-endDate").val($.trim($("#search-endDate").val()))

                // pageList(1, 2)
                pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
            })

            pageList(1, 4)

            $("#qx").bind("click", function () {
                $(":checkbox[name=xz]").prop("checked", this.checked)
            })

            $("#activityBody").on("click", $(":checkbox[name=xz]"), function () {
                $("#qx").prop("checked", $(":checkbox[name=xz]").length == $(":checkbox[name=xz]:checked").length)
            })

            $("#deleteBtn").click(function () {
                var $xz = $(":checkbox[name=xz]:checked")
                if ($xz.length == 0) {
                    alert("请选择需要删除的记录")
                } else if (confirm("确定删除所有选中记录？")) {
                    var param = "";
                    for (var i = 0; i < $xz.length; i++) {
                        param += "id=" + $($xz[i]).val()

                        if (i < $xz.length - 1) {
                            param += "&"
                        }
                    }

                    // alert(param)

                    $.ajax({
                        type: "post",
                        url: "workbench/activity/delete.do",
                        data: param,
                        async: true,
                        success: function (data) {
                            if (data.success) {
                                $("#qx").prop("checked", false)

                                pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                // alert("市场活动删除失败！")
                                alert(data.msg)
                            }
                        },
                        error: function () {
                            alert("服务器维护中...")
                        },
                        dataType: "json"
                    })

                }

            })

            $("#editBtn").click(function () {
                var $xz = $(":checkbox[name=xz]:checked")
                if ($xz.length == 0) {
                    alert("请选择需要修改的记录")
                } else if ($xz.length > 1) {
                    alert("只能选择一条记录执行修改操作")
                } else {
                    $.ajax({
                        type: "get",
                        url: "workbench/activity/getUserListAndActivity.do",
                        data: {
                            "id": $xz.val()
                        },
                        async: true,
                        success: function (data) {
                            //data:{"uList":[{用户1},{用户2},...],"a":{"id":"?","name":"?",...}}
                            var html = ""
                            $.each(data.uList, function (i, n) {
                                html += "<option value = '" + n.id + "'>" + n.name + "</option>"
                            })
                            $("#edit-owner").html(html)

                            // $("#edit-id").val(data.a.id) //隐藏域保存id，在执行修改操作时一并提交
                            $("#edit-id").val($xz.val())
                            $("#edit-owner").val(data.a.owner) //下拉列表默认选中当前记录的拥有者
                            $("#edit-name").val(data.a.name)
                            $("#edit-startDate").val(data.a.startDate)
                            $("#edit-endDate").val(data.a.endDate)
                            $("#edit-cost").val(data.a.cost)
                            $("#edit-description").val(data.a.description)

                            $("#editActivityModal").modal("show")
                        },
                        error: function () {
                            alert("服务器维护中...")
                        },
                        dataType: "json"
                    })
                }
            })

            $("#updateBtn").click(function () {
                $.ajax({
                    type: "post",
                    url: "workbench/activity/update.do",
                    data: {
                        "id": $.trim($("#edit-id").val()),
                        "owner": $.trim($("#edit-owner").val()),
                        "name": $.trim($("#edit-name").val()),
                        "startDate": $.trim($("#edit-startDate").val()),
                        "endDate": $.trim($("#edit-endDate").val()),
                        "cost": $.trim($("#edit-cost").val()),
                        "description": $.trim($("#edit-description").val())
                    },
                    async: true,
                    success: function (data) {
                        if (data.success) {
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage'), $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                            $("#editActivityModal").modal("hide")
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

        })

        function pageList(pageNo, pageSize) {
            //查询活动列表之前，将隐藏域中的信息返回至搜索框search-*中，以显示和传参
            $("#search-name").val($.trim($("#hidden-name").val()))
            $("#search-owner").val($.trim($("#hidden-owner").val()))
            $("#search-startDate").val($.trim($("#hidden-startDate").val()))
            $("#search-endDate").val($.trim($("#hidden-endDate").val()))

            $.ajax({
                type: "get",
                url: "workbench/activity/pageList.do",
                data: {
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startDate").val()),
                    "endDate": $.trim($("#search-endDate").val()),
                    "pageNo": pageNo,
                    "pageSize": pageSize
                },
                async: true,
                success: function (data) {
                    // data:{"total":100,"dataList":[{市场活动1},{2},{3}]}
                    var html = ""
                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">'
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>'
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>'
                        html += '<td>' + n.owner + '</td>'
                        html += '<td>' + n.startDate + '</td>'
                        html += '<td>' + n.endDate + '</td>'
                        html += '</tr>'
                    })
                    $("#activityBody").html(html)

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

<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-startDate">
<input type="hidden" id="hidden-endDate">

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="activityAddForm">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <%--<option>zhangsan</option>--%>
                                <%--<option>lisi</option>--%>
                                <%--<option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate" readonly>
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
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

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <input type="hidden" id="edit-id">

                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <%--<option>zhangsan</option>--%>
                                <%--<option>lisi</option>--%>
                                <%--<option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate" readonly>
                        </div>
                        <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
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
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate" readonly/>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn">
                    <span class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn">
                    <span class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--<tr class="active">--%>
                <%--<td><input type="checkbox"/></td>--%>
                <%--<td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
                <%--<td>zhangsan</td>--%>
                <%--<td>2020-10-10</td>--%>
                <%--<td>2020-10-20</td>--%>
                <%--</tr>--%>
                <%--<tr class="active">--%>
                <%--<td><input type="checkbox"/></td>--%>
                <%--<td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
                <%--<td>zhangsan</td>--%>
                <%--<td>2020-10-10</td>--%>
                <%--<td>2020-10-20</td>--%>
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