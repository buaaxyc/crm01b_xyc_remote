<%--
  Created by IntelliJ IDEA.
  User: XYC
  Date: 2019/4/19
  Time: 17:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/"/>
    <title>Title</title>
    <script type="text/javascript" src="ECharts/echarts.min.js"></script>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script>
        $(function () {
            getCharts()
        })

        function getCharts() {
            $.ajax({
                type: "get",
                url: "workbench/transaction/getCharts.do",
                // data:{},
                async: true,
                success: function (data) {

                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));

                    var option = {
                        title: {
                            text: '交易漏斗图',
                            subtext: '统计不同交易阶段数量的漏斗图'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}"
                        },
                        // toolbox: {
                        //     feature: {
                        //         dataView: {readOnly: false},
                        //         restore: {},
                        //         saveAsImage: {}
                        //     }
                        // },
                        // legend: {
                        //     data: ['展现', '点击', '访问', '咨询', '订单']
                        // },
                        calculable: true,
                        series: [
                            {
                                name: '交易漏斗图',
                                type: 'funnel',
                                left: '10%',
                                top: 60,
                                //x2: 80,
                                bottom: 60,
                                width: '80%',
                                // height: {totalHeight} - y - y2,
                                min: 0,
                                max: data.total,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: data.dataList
                                // [
                                //     {value: 60, name: '访问'},
                                //     {value: 40, name: '咨询'},
                                //     {value: 20, name: '订单'},
                                //     {value: 80, name: '点击'},
                                //     {value: 100, name: '展现'}
                                // ]
                            }
                        ]
                    };

                    // 使用刚指定的配置项和数据显示图表
                    myChart.setOption(option);

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

<center>
    <!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
    <div id="main" style="width: 800px;height:400px;"></div>
</center>

</body>
</html>
