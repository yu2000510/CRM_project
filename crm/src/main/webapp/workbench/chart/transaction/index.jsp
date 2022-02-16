<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<html>
<head>
    <title>Title</title>
    <base href="<%=basePath%>">
    <script src="ECharts/echarts.min.js"></script>
    <script src="jquery/jquery-1.11.1-min.js"></script>

    <script type="text/javascript">
        $(function () {

            // 在页面加载完毕后，绘制统计图表
            getCharts();

        });

        function getCharts() {
            var myChart1 = echarts.init(document.getElementById('main'));
            var myChart2 = echarts.init(document.getElementById('main2'));

            $.ajax({
                url:"workbench/transaction/getCharts",
                type:"get",
                dataType:"json",
                success:function (data) {
                    // 指定图表的配置项和数据
                    var option1 = {
                        title: {
                            text: '交易漏斗图',
                            subtext: '统计交易阶段数量的漏斗图'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: '{a} <br/>{b} : {c}%'
                        },
                        toolbox: {
                            feature: {
                                dataView: { readOnly: false },
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        legend: {
                            data: ['01资质审查', '02需求分析', '03价值建议',
                                '04确定决策者', '05提案/报价','06谈判/复审',
                                '07成交','08丢失的线索','09因竞争丢失']
                        },
                        series: [
                            {
                                name: '交易漏斗图',
                                type: 'funnel',
                                left: '10%',
                                top: 60,
                                bottom: 60,
                                width: '80%',
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
                            }
                        ]
                    };
                    option2 = {
                        title: {
                            text: '交易饼状图',
                            subtext: '统计交易阶段数量的饼状图',
                            left: 'center'
                        },
                        tooltip: {
                            trigger: 'item'
                        },
                        legend: {
                            orient: 'vertical',
                            left: 'left'
                        },
                        series: [
                            {
                                name: '交易饼状图',
                                type: 'pie',
                                radius: '50%',
                                data: data.dataList,
                                emphasis: {
                                    itemStyle: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                }
                            }
                        ]
                    };
                    myChart1.setOption(option1);// 漏斗图
                    myChart2.setOption(option2);// 柱状图
                }
            });
        }

    </script>
</head>
<body>
    <!-- 为 ECharts 准备一个定义了宽高的 DOM -->
    <div id="main" style="width: 600px;float:left;height:400px;"></div>

    <div id="main2" style="width: 500px;float:right;height:400px;"></div>
</body>
</html>
