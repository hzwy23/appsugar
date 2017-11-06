<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">批次配置管理</span>
    </div>
</div>

<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-ftp-dispatch-manage-info-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        <button onclick="FtpDispatchManageObj.add()" class="btn btn-info btn-sm">
            <i class="icon-plus"> 新增</i>
        </button>
        <button onclick="FtpDispatchManageObj.edit()" class="btn btn-info btn-sm">
            <span class="icon-edit"> 编辑</span>
        </button>
        <button onclick="FtpDispatchManageObj.start()" class="btn btn-info btn-sm">
            <span class="icon-edit"> 运行</span>
        </button>
        <button onclick="FtpDispatchManageObj.stop()" class="btn btn-info btn-sm">
            <span class="icon-trash"> 停止</span>
        </button>
        <button onclick="FtpDispatchManageObj.delete()" class="btn btn-danger btn-sm">
            <span class="icon-trash"> 删除</span>
        </button>
    </div>
</div>
<div id="h-ftp-dispatch-manage-info-content" class="subsystem-content">
    <table id="h-ftp-dispatch-manage-info-table-details"
           data-toggle="table"
           data-striped="true"
           data-unique-id="dispatch_id"
           data-click-to-select="true"
           data-url="/v1/ftp/dispatch/manage/get"
           data-side-pagination="client"
           data-pagination="true"
           data-page-list="[20, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-radio="true"></th>
            <th data-field="code_number">批次编码</th>
            <th data-field="dispatch_name">批次名称</th>
            <th data-formatter="FtpDispatchManageObj.formattersource" data-field="input_source_cd">输入源</th>
            <th data-formatter="FtpDispatchManageObj.formattersource" data-field="output_result_cd">输出源</th>
            <th data-align="right" data-field="start_offset">开始行</th>
            <th data-align="right" data-field="max_limit">偏移量</th>
            <th data-align="center" data-field="as_of_date">批次日期</th>
            <th data-align="center" data-field="dispatch_status">批次状态</th>
            <th data-align="center" data-formatter="FtpDispatchManageObj.formatter">运行监控</th>
        </tr>
        </thead>
    </table>
</div>
<script type="text/javascript">

    var FtpDispatchManageObj = {
        $table:$("#h-ftp-dispatch-manage-info-table-details"),
        getCurveManagePage:function (dispatch_id,as_of_date) {
            var time = "";
            var domain_id = $("#h-ftp-dispatch-manage-info-domain-list").val();
            $.Hmodal({
                height:"450px",
                footerBtnStatus:false,
                body:$("#h-ftp-dispatch-monitoring-src").html(),
                header:"批次监控",
                preprocess:function () {
                    $.getJSON("/v1/ftp/dispatch/history/monitoring",
                        {domain_id:domain_id,
                            as_of_date:as_of_date,
                            dispatch_id:dispatch_id},
                        function (data) {
                            if (data.length > 0 ) {
                                var element = data[0];

                                var tmp = element.dispatch_id.split("_join_");
                                if (tmp.length==2){
                                    $("#h-ftp-dispatch-id").html(tmp[1])
                                } else {
                                    $("#h-ftp-dispatch-id").html(element.dispatch_id)
                                }

                                $("#h-ftp-dispatch-date").html(element.dispatch_date)
                                $("#h-ftp-dispatch-status").html(element.dispatch_status)
                                $("#h-ftp-dispatch-total").html(element.total_cnt)
                                $("#h-ftp-dispatch-success").html(element.success_cnt)
                                $("#h-ftp-dispatch-error").html(element.error_cnt)
                                $("#h-ftp-dispatch-nobusiz").html(element.nobusiz_cnt)
                                $("#h-ftp-dispatch-calc").html(element.calc_cnt)
                                $("#h-ftp-dispatch-start-date").html(element.start_time)
                                $("#h-ftp-dispatch-end-date").html(element.end_time)
                            }
                        });
                },
            })
        },
        stop:function () {

            var row  = $("#h-ftp-dispatch-manage-info-table-details").bootstrapTable('getSelections');
            if (row.length == 0) {
                $.Notify({
                    title:"温馨提示:",
                    message:"请选择需要定制的批次",
                    type:"info",
                })
                return
            }


            $.HAjaxRequest({
                url:"/v1/ftp/dispatch/manage/stop",
                type:"put",
                data:{domain_id:row[0].domain_id,dispatch_id:row[0].dispatch_id},
                success:function () {
                    $.Notify({
                        title:"温馨提示:",
                        message:"停止批次成功",
                        type:"success",
                    })
                },
            })
        },
        formattersource:function (value) {
            var tmp = value.split("_join_")
            if (tmp.length == 2){
                return tmp[1]
            } else {
                return value
            }
        },
        delete:function () {
            var rows = $("#h-ftp-dispatch-manage-info-table-details").bootstrapTable('getSelections')
            if (rows.length == 0){
                $.Notify({
                    title:"温馨提示:",
                    message:"您没有选中任何需要删除的批次信息",
                    type:"info"
                });
                return
            }

            $.Hconfirm({
                body:"点击确定,将删除批次信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ftp/dispatch/manage/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                title:"温馨提示:",
                                message:"删除批次信息成功",
                                type:"success",
                            });
                            FtpDispatchManageObj.$table.bootstrapTable('refresh')
                            return
                        }
                    })
                }
            })
        },
        add:function () {
            $.Hmodal({
                header:"新增批次信息",
                body:$("#h-ftp-dispatch-add-form").html(),
                width:"420px",
                preprocess:function () {
                    var domain_id  = $("#h-ftp-dispatch-manage-info-domain-list").val();
                    $.getJSON("/v1/ftp/dispatch/input/source/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.input_source_cd;
                            e.text = element.input_source_desc;
                            e.upId = "-1"

                            arr.push(e)
                        })

                        $("#h-ftp-dispatch-manage-input_source").Hselect({
                            data:arr,
                            height:"30px",
                        })
                    });

                    $.getJSON("/v1/ftp/dispatch/output/source/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.output_result_cd;
                            e.text = element.output_result_desc;
                            e.upId = "-1"

                            arr.push(e)
                        })

                        $("#h-ftp-dispatch-manage-output_source").Hselect({
                            data:arr,
                            height:"30px",
                        })
                    });

                    $("#h-ftp-dispatch-manage-domain-id").val(domain_id)
                },
                callback:function (hmode) {

                    $.HAjaxRequest({
                        url:"/v1/ftp/dispatch/manage/post",
                        type:"post",
                        data:$("#h-ftp-dispatch-add-info").serialize(),
                        success:function (data) {
                            $.Notify({
                                title:"温馨提示:",
                                message:"新增批次信息成功",
                                type:"success",
                            });
                            $(hmode).remove()
                            $("#h-ftp-dispatch-manage-info-table-details").bootstrapTable('refresh')
                        },
                    })

                },
            })
        },
        edit:function () {
            var row = $("#h-ftp-dispatch-manage-info-table-details").bootstrapTable('getSelections');
            if (row.length == 0){
                $.Notify({
                    title:"温馨提示:",
                    message:"请选择一行进行编辑",
                    type:"info",
                })
                return
            };

            $.Hmodal({
                header:"新增批次信息",
                body:$("#h-ftp-dispatch-add-form").html(),
                width:"360px",
                preprocess:function () {
                    var domain_id  = $("#h-ftp-dispatch-manage-info-domain-list").val();
                    $.getJSON("/v1/ftp/dispatch/input/source/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.input_source_cd;
                            e.text = element.input_source_desc;
                            e.upId = "-1"

                            arr.push(e)
                        })

                        $("#h-ftp-dispatch-manage-input_source").Hselect({
                            data:arr,
                            height:"30px",
                            value:row[0].input_source_cd,
                        })
                    });

                    $.getJSON("/v1/ftp/dispatch/output/source/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.output_result_cd;
                            e.text = element.output_result_desc;
                            e.upId = "-1"

                            arr.push(e)
                        })

                        $("#h-ftp-dispatch-manage-output_source").Hselect({
                            data:arr,
                            height:"30px",
                            value:row[0].output_result_cd,
                        })
                    });

                    $("#h-ftp-dispatch-manage-domain-id").val(domain_id)

                    $("#h-ftp-dispatch-add-info").find("input[name='dispatch_id']").val(row[0].code_number).attr("readonly","readonly");
                    $("#h-ftp-dispatch-add-info").find("input[name='dispatch_desc']").val(row[0].dispatch_name);
                    $("#h-ftp-dispatch-add-info").find("input[name='start_offset']").val(row[0].start_offset);
                    $("#h-ftp-dispatch-add-info").find("input[name='max_limit']").val(row[0].max_limit);

                },
                callback:function (hmode) {

                    $.HAjaxRequest({
                        url:"/v1/ftp/dispatch/manage/put",
                        type:"put",
                        data:$("#h-ftp-dispatch-add-info").serialize(),
                        success:function (data) {
                            $.Notify({
                                title:"温馨提示:",
                                message:"新增批次信息成功",
                                type:"success",
                            });
                            $(hmode).remove()
                            $("#h-ftp-dispatch-manage-info-table-details").bootstrapTable('refresh')
                        },
                    })

                },
            })
        },
        formatter:function (value, rows, index) {
            return '<span class="h-td-btn" onclick="FtpDispatchManageObj.getCurveManagePage(\''+rows.dispatch_id+'\',\''+ rows.as_of_date+'\')">批次监控</span>'
        },
        start:function () {
            var row = $("#h-ftp-dispatch-manage-info-table-details").bootstrapTable('getSelections');
            if (row.length==0){
                $.Notify({
                    title:"温馨提示:",
                    message:"请选择需要运行的批次",
                    type:"info",
                });
                return
            }
            $.Hmodal({
                body:$("#h-ftp-dispatch-start-dispatch").html(),
                width:"420px",
                header:"运行批次",
                callback:function (hmode) {
                    var dispatch_id = $("#h-ftp-dispatch-start-info").find("input[name='dispatch_id']").val();
                    var as_of_date = $("#h-ftp-dispatch-start-info").find("input[name='as_of_date']").val();
                    var domain_id = $("#h-ftp-dispatch-start-info").find("input[name='domain_id']").val();
                    $(hmode).remove();
                    $.Notify({
                        title:"温馨提示:",
                        message:"批次启动中...",
                        type:"info",
                    });
                    setTimeout(function () {
                        $.HAjaxRequest({
                            url:"/v1/ftp/dispatch/manage/start",
                            type:"put",
                            data:{dispatch_id:dispatch_id,as_of_date:as_of_date,domain_id:domain_id},
                            success:function () {
                                $.notifyClose();

                                $.Notify({
                                    title:"温馨提示:",
                                    message:"批次启动成功",
                                    type:"success",
                                });

                                return
                            },
                            error:function (m) {
                                $.notifyClose();

                                var msg = JSON.parse(m.responseText)
                                $.Notify({
                                    title:"温馨提示:",
                                    message:msg.error_msg,
                                    type:"danger",
                                });
                            },
                        })
                    },1500)
                },
                preprocess:function () {
                    $("#h-ftp-dispatch-start-info").find("input[name='domain_id']").val(row[0].domain_id);
                    $("#h-ftp-dispatch-start-info").find("input[name='dispatch_id']").val(row[0].dispatch_id);
                },
            })
        },
    };

    $(document).ready(function () {
        $("#h-ftp-dispatch-manage-info-content").height(document.documentElement.clientHeight-130)

        Hutils.InitDomain({
            id:"#h-ftp-dispatch-manage-info-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                $("#h-ftp-dispatch-manage-info-table-details").bootstrapTable('refresh');
            },
            callback:function (domainId) {
                $("#h-ftp-dispatch-manage-info-table-details").bootstrapTable({
                    height:document.documentElement.clientHeight-130,
                    queryParams:function (params) {
                        params.domain_id = $("#h-ftp-dispatch-manage-info-domain-list").val()
                        return params
                    }
                });

                var time = setInterval(function () {
                    var domain_id = $("#h-ftp-dispatch-manage-info-domain-list").val();
                    if (domain_id == undefined) {
                        clearInterval(time)
                        return
                    }
                    $.getJSON("/v1/ftp/dispatch/manage/get",{
                        domain_id:domain_id
                    },function (data) {
                        $(data).each(function (index, element) {
                            $("#h-ftp-dispatch-manage-info-table-details").bootstrapTable('updateByUniqueId', {
                                id: element.dispatch_id,
                                row: {
                                    dispatch_status:element.dispatch_status,
                                    as_of_date:element.as_of_date
                                }
                            });
                        });
                    });
                },10000)
            },
        });
    })
</script>

<script id="h-ftp-dispatch-monitoring-src" type="text/html">
    <table id="h-ftp-dispatch-monitoring-table" class="table table-bordered table-condensed table-striped table-hover">
        <tr><th class="col-sm-4 col-md-4 col-lg-4 text-center">指标</th><th class="col-sm-8 col-md-8 col-lg-8 text-center">值</th></tr>
        <tr><td class="text-right">批次号：</td><td id="h-ftp-dispatch-id"></td></tr>
        <tr><td class="text-right">批次日期：</td><td id="h-ftp-dispatch-date"></td></tr>
        <tr><td class="text-right">批次状态：</td><td id="h-ftp-dispatch-status"></td></tr>
        <tr><td class="text-right">总共定价账户数：</td><td id="h-ftp-dispatch-total"></td></tr>
        <tr><td class="text-right">成功定价账户数：</td><td id="h-ftp-dispatch-success"></td></tr>
        <tr><td class="text-right">错误执行账户数：</td><td id="h-ftp-dispatch-error"></td></tr>
        <tr><td class="text-right">没有匹配定价单元账户数：</td><td id="h-ftp-dispatch-nobusiz"></td></tr>
        <tr><td class="text-right">送入计算引擎账户数：</td><td id="h-ftp-dispatch-calc"></td></tr>
        <tr><td class="text-right">开始时间：</td><td id="h-ftp-dispatch-start-date"></td></tr>
        <tr><td class="text-right">结束时间：</td><td id="h-ftp-dispatch-end-date"></td></tr>
    </table>
</script>

<script id="h-ftp-dispatch-start-dispatch" type="text/html">
    <form id="h-ftp-dispatch-start-info" class="row">
        <div class="col-sm-12" style="display: none;">
            <input name="domain_id" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;" />
            <input name="dispatch_id" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;" />
        </div>
        <div class="col-sm-12">
            <label class="control-label" style="font-size: 12px;">批次日期：</label>
            <input onclick="laydate(this)" placeholder="请选择批次运行的日期" name="as_of_date" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;" />
        </div>
    </form>
</script>

<script type="text/html" id="h-ftp-dispatch-add-form">
    <form class="row" id="h-ftp-dispatch-add-info">
        <div class="col-sm-12">
            <label class="h-label" style="width:100%;">批次编码：</label>
            <input placeholder="请输入1-30位数字，字母（必填）" name="dispatch_id" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
        </div>

        <div class="col-sm-12" style="margin-top: 15px;">
            <label class="h-label" style="width: 100%;">批次名称：</label>
            <input placeholder="请输入1-60位汉字，字母，数字（必填）" type="text" class="form-control" name="dispatch_desc" style="width: 100%;height: 30px;line-height: 30px;">
        </div>

        <div class="col-sm-12" style="margin-top: 15px;">
            <label class="h-label" style="width: 100%;">输入源：</label>
            <select id="h-ftp-dispatch-manage-input_source" name="input_source_cd" style="width: 100%;height: 30px;line-height: 30px;">
            </select>
        </div>

        <div class="col-sm-12" style="margin-top: 15px;">
            <label class="h-label" style="width: 100%;">输出源：</label>
            <select id="h-ftp-dispatch-manage-output_source" name="output_result_cd" style="width: 100%;height: 30px;line-height: 30px;">
            </select>
        </div>

        <div class="col-sm-12" style="margin-top: 15px;">
            <label class="h-label" style="width: 100%;">起始行：</label>
            <input placeholder="数据起始行数" name="start_offset" class="form-control" style="width: 100%;height: 30px;line-height: 30px;" />
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <label class="h-label" style="width: 100%;">偏移量：</label>
            <input placeholder="读取数据最大行数" name="max_limit" class="form-control" style="width: 100%;height: 30px;line-height: 30px;" />
        </div>
        <div class="col-sm-12" style="margin-top: 15px; display: none;">
            <input name="domain_id" id="h-ftp-dispatch-manage-domain-id" />
        </div>
    </form>
</script>