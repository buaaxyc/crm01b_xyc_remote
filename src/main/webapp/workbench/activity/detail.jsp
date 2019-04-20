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

            showRemark()

            $("#remarkBody").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            })

            //为保存按钮绑定添加事件
            $("#saveRemarkBtn").click(function () {
                var noteContent = $("#remark").val()

                $.ajax({
                    type: "post",
                    url: "workbench/activity/saveRemark.do",
                    data: {
                        "noteContent": noteContent,
                        "activityId": "${a.id}"
                    },
                    async: true,
                    success: function (data) {
                        // data:{"success":flag,"ar":{新增的市场活动备注},"msg":"异常信息"}

                        if (data.success) {
                            var html = ""

                            html += '<div id="' + data.ar.id + '" class="remarkDiv" style="height: 60px;">'
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                            html += '<div style="position: relative; top: -40px; left: 40px;">'
                            html += '<h5 id="e' + data.ar.id + '">' + data.ar.noteContent + '</h5>'
                            html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b>'
                            html += '<small id="s' + data.ar.id + '" style="color: gray;"> ' + data.ar.createTime + ' 由' + data.ar.createBy + '</small>'
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.ar.id + '\')">'
                            html += '<span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #ff0000;"></span>'
                            html += '</a>'
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;'
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + data.ar.id + '\')">'
                            html += '<span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #ff0000;"></span>'
                            html += '</a>'
                            html += '</div>'
                            html += '</div>'
                            html += '</div>'

                            $("#remarkDiv").before(html)

                            //添加成功后清空文本域
                            $("#remark").val("")
                        } else {
                            // alert("添加市场活动备注失败")
                            alert(data.msg)
                        }
                    },
                    error: function () {
                        alert("服务器维护中...")
                    },
                    dataType: "json"
                })
            })

            //为修改模态窗口中的更新按钮绑定更新事件
            $("#updateRemarkBtn").click(function () {
                var id = $("#remarkId").val()
                var noteContent = $("#noteContent").val()

                $.ajax({
                    type: "post",
                    url: "workbench/activity/updateRemark.do",
                    data: {
                        "id": id,
                        "noteContent": noteContent
                    },
                    async: true,
                    success: function (data) {
                        if (data.success) {
                            // $("#e" + id).html(noteContent)
                            $("#e" + id).html(data.ar.noteContent)

                            $("#s" + id).html(" " + data.ar.editTime + " 由" + data.ar.editBy)

                            $("#editRemarkModal").modal("hide")
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


        });

        function showRemark() {
            $.ajax({
                type: "get",
                url: "workbench/activity/getRemarkListByAid.do",
                data: {
                    "aid": "${a.id}"
                },
                async: true,
                success: function (data) {
                    var html = ""
                    $.each(data, function (i, n) {
                        html += '<div id="' + n.id + '" class="remarkDiv" style="height: 60px;">'
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                        html += '<div style="position: relative; top: -40px; left: 40px;">'
                        html += '<h5 id="e' + n.id + '">' + n.noteContent + '</h5>'
                        html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b>'
                        html += '<small id="s' + n.id + '" style="color: gray;"> ' + (n.editFlag == 0 ? n.createTime : n.editTime) + ' 由' + (n.editFlag == 0 ? n.createBy : n.editBy) + '</small>'
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                        html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + n.id + '\')">'
                        html += '<span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #ff0000;"></span>'
                        html += '</a>'
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;'
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + n.id + '\')">'
                        html += '<span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #ff0000;"></span>'
                        html += '</a>'
                        html += '</div>'
                        html += '</div>'
                        html += '</div>'
                    })
                    $("#remarkDiv").before(html)

                },
                error: function () {
                    alert("服务器维护中...")
                },
                dataType: "json"
            })
        }

        function deleteRemark(id) {
            // alert(id)
            if (confirm("确定删除当前备注记录？")) {
                $.ajax({
                    type: "post",
                    url: "workbench/activity/deleteRemark.do",
                    data: {
                        "id": id
                    },
                    async: true,
                    success: function (data) {
                        if (data.success) {
                            //如果删除成功，则删除页面中对应的备注记录
                            $("#" + id).remove()
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
        }

        function editRemark(id) {
            $("#remarkId").val(id)
            $("#noteContent").val($("#e" + id).html())

            $("#editRemarkModal").modal("show")
        }

    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="noteContent" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();">
        <span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span>
    </a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动-${a.name}
            <small>${a.startDate} ~ ${a.endDate}</small>
        </h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal" disabled>
            <span class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger">
            <span class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.createBy}&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;">${a.createTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.editBy}&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;">${a.editTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${a.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>