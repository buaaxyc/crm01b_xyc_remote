<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%--<meta charset="UTF-8">--%>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/"/>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            showActivity()

            $("#unbundBtn").click(function () {
                $.ajax({
                    type: "post",
                    url: "workbench/contacts/unbund.do",
                    data: {
                        "activityId": $.trim($("#hidden-activityId").val()),
                        "contactsId": "${con.id}"
                    },
                    async: true,
                    success: function (data) {
                        if (data.success) {

                            $("#unbundActivityModal").modal("hide")

                            showActivity()

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

            $("#searchBtn").click(showActivityByCondition)

            $("#aname").keydown(function (event) {
                if (event.keyCode == 13) {

                    showActivityByCondition()

                    return false
                }
            })

            $("#qx").click(function () {
                $(":checkbox[name=xz]").prop("checked", $("#qx").prop("checked"))
            })

            $("#activitySearchBody").on("click", $(":checkbox[name=xz]"), function () {
                $("#qx").prop("checked", $(":checkbox[name=xz]").length == $(":checkbox[name=xz]:checked").length)
            })

            $("#bundBtn").click(function () {
                var $xz = $(":checkbox[name=xz]:checked")

                if ($xz.length == 0) {
                    alert("请选择需要绑定的市场活动")
                } else {

                    var param = "contactsId=${con.id}&"

                    for (var i = 0; i < $xz.length; i++) {
                        param += "activityId=" + $($xz[i]).val()

                        if (i < $xz.length - 1) {
                            param += "&"
                        }
                    }

                    // alert(param)

                    $.ajax({
                        type: "post",
                        url: "workbench/contacts/bund.do",
                        data: param,
                        async: true,
                        success: function (data) {

                            if (data.success) {

                                $("#aname").val("")

                                $("#qx").prop("checked", false)

                                $("#activitySearchBody").empty()

                                $("#bundActivityModal").modal("hide")

                                showActivity()
                            } else {
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
        });

        function showActivity() {
            $.ajax({
                type: "get",
                url: "workbench/contacts/getActivityListByContactsId.do",
                data: {
                    "contactsId": "${con.id}"
                },
                async: true,
                success: function (data) {

                    var html = ""

                    $.each(data, function (i, n) {
                        html += '<tr>'
                        html += '<td><a href="workbench/activity/detail.do?id=' + n.id + '" style="text-decoration: none;">' + n.name + '</a></td>'
                        html += '<td>' + n.startDate + '</td>'
                        html += '<td>' + n.endDate + '</td>'
                        html += '<td>' + n.owner + '</td>'
                        html += '<td>'
                        html += '<a href="javascript:void(0);" onclick="showUnbundModal(\'' + n.id + '\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a>'
                        html += '</td>'
                        html += '</tr>'
                    })

                    $("#activityBody").html(html)
                },
                error: function () {
                    alert("服务器维护中...")
                },
                dataType: "json"
            })
        }

        function showUnbundModal(activityId) {

            $("#hidden-activityId").val(activityId)

            $("#unbundActivityModal").modal("show")

        }

        function showActivityByCondition() {
            $.ajax({
                type: "get",
                url: "workbench/contacts/getActivityListByNameAndNotByContactsId.do",
                data: {
                    "aname": $("#aname").val(),
                    "contactsId": "${con.id}"
                },
                async: true,
                success: function (data) {

                    var html = ""

                    $.each(data, function (i, n) {
                        html += '<tr>'
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>'
                        html += '<td>' + n.name + '</td>'
                        html += '<td>' + n.startDate + '</td>'
                        html += '<td>' + n.endDate + '</td>'
                        html += '<td>' + n.owner + '</td>'
                        html += '</tr>'
                    })

                    $("#activitySearchBody").html(html)
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

<!-- 解除联系人和市场活动关联的模态窗口 -->
<div class="modal fade" id="unbundActivityModal" role="dialog">

    <input type="hidden" id="hidden-activityId">

    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">解除关联</h4>
            </div>
            <div class="modal-body">
                <p>您确定要解除该关联关系吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" id="unbundBtn">解除</button>
            </div>
        </div>
    </div>
</div>

<!-- 联系人和市场活动关联的模态窗口 -->
<div class="modal fade" id="bundActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询" id="aname">
                            <a id="searchBtn" href="javascript:void(0)">
                                <%--<span class="glyphicon glyphicon-search form-control-feedback"></span>--%>
                                <span class="glyphicon glyphicon-search"></span>
                            </a>
                        </div>
                    </form>
                </div>
                <table id="activityTable2" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="qx"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="activitySearchBody">
                    <%--<tr>--%>
                    <%--<td><input type="checkbox"/></td>--%>
                    <%--<td>发传单</td>--%>
                    <%--<td>2020-10-10</td>--%>
                    <%--<td>2020-10-20</td>--%>
                    <%--<td>zhangsan</td>--%>
                    <%--</tr>--%>
                    <%--<tr>--%>
                    <%--<td><input type="checkbox"/></td>--%>
                    <%--<td>发传单</td>--%>
                    <%--<td>2020-10-10</td>--%>
                    <%--<td>2020-10-20</td>--%>
                    <%--<td>zhangsan</td>--%>
                    <%--</tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="bundBtn">关联</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${con.fullname}${con.appellation}
            <small> - ${con.customerId}</small>
        </h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editContactsModal" disabled>
            <span class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" disabled>
            <span class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${con.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${con.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${con.customerId}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${con.fullname}${con.appellation}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${con.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${con.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${con.job}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${con.birth}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${con.createBy}&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;">${con.createTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${con.editBy}&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;">${con.editTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${con.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${con.contactSummary}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${con.nextContactTime}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${con.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>
<!-- 备注 -->
<div style="position: relative; top: 20px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>哎呦！</h5>
            <font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b>
            <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>

    <!-- 备注2 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>呵呵！</h5>
            <font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b>
            <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 交易 -->
<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>交易</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable3" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>金额</td>
                    <td>阶段</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>类型</td>
                    <td></td>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><a href="workbench/transaction/detail.jsp" style="text-decoration: none;">动力节点-交易01</a></td>
                    <td>5,000</td>
                    <td>谈判/复审</td>
                    <td>90</td>
                    <td>2017-02-07</td>
                    <td>新业务</td>
                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal"
                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
                </tr>
                </tbody>
            </table>
        </div>

        <div>
            <a href="workbench/transaction/save.jsp" style="text-decoration: none;"><span
                    class="glyphicon glyphicon-plus"></span>新建交易</a>
        </div>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--<tr>--%>
                <%--<td><a href="workbench/activity/detail.jsp" style="text-decoration: none;">发传单</a></td>--%>
                <%--<td>2020-10-10</td>--%>
                <%--<td>2020-10-20</td>--%>
                <%--<td>zhangsan</td>--%>
                <%--<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal"--%>
                <%--style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
                <%--</tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" data-toggle="modal" data-target="#bundActivityModal"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>