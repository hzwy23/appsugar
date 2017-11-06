<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">曲线值配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div style="height: 44px; line-height: 44px; display: inline; position: relative;">
        <span style="font-size: 10px;font-weight: 600;" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-ftp-curve-manage-info-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
        <span style="font-size: 10px;font-weight: 600;" class="pull-left">&nbsp;&nbsp;曲线列表:</span>
        <select id="h-curve-manage-curve-list" class="form-control pull-left"
                style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px; padding: 0px;">
        </select>
        <button class="btn btn-default btn-xs" type="button"
                data-toggle="collapse" data-target="#h-ftp-curve-manage-collapse"
                aria-expanded="false" aria-controls="h-ftp-curve-manage-collapse"
                style="margin-left: 12px;">
            <i class="icon-double-angle-down"> 更多选项</i>
        </button>
        <div class="collapse pull-left" id="h-ftp-curve-manage-collapse"
             style="position: absolute; background-color: #fafafa; z-index: 20;width: 260px;">
            <span style="margin-top:-10px; font-size: 10px;font-weight: 600;display: inline">&nbsp;开始日期:</span>
            <input onclick="laydate()" placeholder="曲线数据开始日期" id="h-curve-manage-start-date" class="form-control" style="width: 180px;height: 24px; line-height: 24px;display: inline;" />
            <br/>
            <span style="margin-left:2px; margin-top:-10px; font-size: 10px;font-weight: 600;display: inline">&nbsp;结束日期:</span>
            <input onclick="laydate()" placeholder="曲线数据结束日期" id="h-curve-manage-end-date" class="form-control" style="width: 180px;height: 24px; line-height: 24px;display: inline;" />
            <button onclick="FtpCurveManageObj.search()" class="btn btn-default btn-xs"><i class="icon-search"> </i>查询</button>
        </div>
    </div>
    <div class="pull-right">
        <button onclick="FtpCurveManageObj.add()" class="btn btn-info btn-sm">
            <i class="icon-plus"> 新增</i>
        </button>
        <button onclick="FtpCurveManageObj.update()" class="btn btn-info btn-sm">
            <span class="icon-edit"> 编辑</span>
        </button>
        <button onclick="FtpCurveManageObj.delete()" class="btn btn-danger btn-sm">
            <span class="icon-trash"> 删除</span>
        </button>
    </div>
</div>
<div class="subsystem-content">
    <table id="h-ftp-curve-manage-info-table-details"
           data-toggle="table"
           data-striped="true"
           data-side-pagination="client"
           data-pagination="true"
           data-page-list="[20, 50, 100, 200]"
           data-search="false">
    </table>
</div>

<script type="text/javascript">
    var FtpCurveManageObj = {
        search:function(){
            var domain_id= $("#h-ftp-curve-manage-info-domain-list").val();
            var curve_id = $("#h-curve-manage-curve-list").val();
            var start_date = $("#h-curve-manage-start-date").val();
            var end_date = $("#h-curve-manage-end-date").val();

            $.getJSON("/v1/ftp/curve/manage/search",{
                domain_id:domain_id,
                curve_id:curve_id,
                start_date:start_date,
                end_date:end_date
            },function (data) {
                var dt = new Array;
                $(data).each(function (index, element) {
                    var d = {};
                    d.as_of_date = element.as_of_date;
                    $(element.curve_yield).each(function(index,element){
                        d[element.struct_code] = element.yield;
                    });
                    dt.push(d);
                });
                if (dt.length == 0){
                    $.Notify({
                        message:"这条曲线暂时没有配置任何值",
                        type:"info"
                    });
                    $("#h-ftp-curve-manage-info-table-details")
                        .bootstrapTable().bootstrapTable('load',dt);
                    return;
                }else{
                    var cols = new Array();
                    // 初始化checkbox选择框
                    var ck = {};
                    ck.field = "state";
                    ck.checkbox = "true";
                    cols.push(ck);
                    var row = dt[0];
                    for ( var x in row ){
                        var c = {};
                        if (x == "as_of_date"){
                            c.title = "数据日期"
                        } else {
                            c.title = x
                        }
                        c.field = x;
                        cols.push(c)
                    }
                    $("#h-ftp-curve-manage-info-table-details").bootstrapTable({
                        columns:cols
                    }).bootstrapTable('load',dt);
                }
            });
        },
        add:function(){
            $.notifyClose();
            if ($("#h-curve-manage-curve-list").val() == null){
                $.Notify({
                    message:"这个域中没有曲线信息,请先定义曲线.",
                    type:"info"
                });
                return
            }
            var pre = function(){
                var curve_id = $("#h-curve-manage-curve-list").val();
                var curve_desc = $("#h-curve-manage-curve-list option:selected").text().trim();
                var domain_id = $("#h-ftp-curve-manage-info-domain-list").val();
                var domain_desc = $("#h-ftp-curve-manage-info-domain-list option:selected").text().trim();

                var tmp = curve_id.split("_join_");
                if (tmp.length === 2){
                    var code_number = tmp[1];
                    $("#h-add-curve-info-form").find("input[name='code_number']").val(code_number);
                } else if (tmp.length === 1){
                    var code_number = tmp[0];
                    $("#h-add-curve-info-form").find("input[name='code_number']").val(code_number);
                } else {
                    $("#h-add-curve-info-form").find("input[name='code_number']").val(curve_id);
                }
                $("#h-add-curve-info-form").find("input[name='curve_id']").val(curve_id);
                $("#h-add-curve-info-form").find("input[name='curve_desc']").val(curve_desc);
                $("#h-add-curve-info-form").find("input[name='domain_id']").val(domain_id);
                $("#h-add-curve-info-form").find("input[name='domain_desc']").val(domain_desc);

                $.getJSON("/v1/ftp/curve/struct/owner/get",{domain_id:domain_id, curve_id:curve_id},function(data){
                    var optHtml = "";
                    $(data).each(function(index,element){
                        optHtml +='<div class="col-sm-2 col-md-2 col-lg-2" style="padding: 3px 3px;"><label class="control-label" style="width: 40px;">'+element.struct_code+'</label><input placeholder="'+element.struct_code+' 收益率值" style="height: 23px;line-height: 23px;" class="form-control" type="text" name="'+element.struct_code+'"/></div>'
                    });
                    $("#h-curve-info-getted-term").html(optHtml)
                });
            };

            var sub = function(hmode){
                var curve_id = $("#h-curve-manage-curve-list").val();
                $.HAjaxRequest({
                    url:'/v1/ftp/curve/manage/post',
                    type:"post",
                    data:$("#h-add-curve-info-form").serialize(),
                    dataType:'json',
                    success:function(){
                        $.Notify({
                            message:"添加曲线值成功",
                            type:"success"
                        });
                        FtpCurveManageObj.defaultQuery(curve_id);
                        $(hmode).remove();
                    },
                    error:function (e) {
                        var msg = JSON.parse(e.responseText);
                        if (msg.error_code === 429){
                            $.Hconfirm({
                                body:'曲线值已存在，是否更新曲线值',
                                callback:function () {
                                    $.HAjaxRequest({
                                        url: '/v1/ftp/curve/manage/put',
                                        type: "put",
                                        data: $("#h-add-curve-info-form").serialize(),
                                        dataType: 'json',
                                        success: function () {
                                            $.Notify({
                                                message:"更新曲线信息值成功",
                                                type:"success"
                                            });
                                            $(hmode).remove();
                                            FtpCurveManageObj.defaultQuery(curve_id)
                                        }
                                    });
                                }
                            });
                            return
                        }
                        $.Notify({
                            message:msg.error_msg,
                            type:"danger"
                        })
                    }
                });
            };

            $.Hmodal({
                header:"新增收益率曲线值信息",
                body:$("#h-curve-yield-add").html(),
                width:"580px",
                preprocess:pre,
                callback:sub
            })
        },
        delete:function () {
            var rows = $("#h-ftp-curve-manage-info-table-details").bootstrapTable('getSelections');
            if (rows.length === 0){
                $.Notify({
                    message:"你没有选中任何曲线值",
                    type:"info",
                });
                return
            }
            $.Hconfirm({
                body:"点击确定,删除曲线值信息",
                callback:function () {

                    var curve_id = $("#h-curve-manage-curve-list").val();
                    var domain_id = $("#h-ftp-curve-manage-info-domain-list").val();
                    var senddata = new Array();
                    $(rows).each(function (index, element) {
                        var e = {};
                        e.as_of_date = element.as_of_date;
                        e.curve_id = curve_id;
                        e.domain_id = domain_id;
                        senddata.push(e)
                    });

                    $.HAjaxRequest({
                        url:"/v1/ftp/curve/manage/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(senddata),curve_id:curve_id,domain_id:domain_id},
                        dataType:"json",
                        success:function () {
                            FtpCurveManageObj.defaultQuery(curve_id);
                            $.Notify({
                                message:"删除曲线值信息成功",
                                type:"success",
                            })
                        }
                    })
                }
            })
        },
        initCurveTable:function () {
            var domain_id= $("#h-ftp-curve-manage-info-domain-list").val();
            $.getJSON("/v1/ftp/curve/define/list",{
                domain_id:domain_id
            },function (cdata) {
                var first_curve_id = "{{.}}";
                var first_id = "";
                var curvelist = new Array();
                $(cdata).each(function (index, element) {
                    var e = {};
                    e.id = element.curve_id;
                    e.text = element.curve_desc;
                    e.upId = "##hzwy23##";
                    if (index === 0){
                        first_id = e.id;
                    }
                    curvelist.push(e)
                });

                if (first_curve_id == "_empty_") {
                    first_curve_id = first_id;
                }

                $("#h-curve-manage-curve-list").Hselect({
                    height:"24px",
                    data:curvelist,
                    value:first_curve_id,
                    width:"180px",
                    onclick:function () {
                        $.getJSON("/v1/ftp/curve/manage/get",{
                            domain_id:$("#h-ftp-curve-manage-info-domain-list").val(),
                            curve_id:$("#h-curve-manage-curve-list").val()
                        },function (data) {

                            var dt = new Array();
                            $(data).each(function (index, element) {
                                var d = {};
                                d.as_of_date = element.as_of_date;
                                $(element.curve_yield).each(function(index,element){
                                    d[element.struct_code] = element.yield;
                                });
                                dt.push(d)
                            });

                            if (dt.length === 0){
                                $.Notify({
                                    message:"这条曲线暂时没有配置任何值",
                                    type:"info"
                                });
                                $("#h-ftp-curve-manage-info-table-details").bootstrapTable('load',dt);
                                return
                            } else {
                                var cols = new Array();

                                // 初始化checkbox选择框
                                var ck = {}
                                ck.field = "state"
                                ck.checkbox = "true"
                                cols.push(ck)

                                var row = dt[0];
                                for ( var x in row){
                                    var c = {}
                                    if (x == "as_of_date"){
                                        c.title = "数据日期"
                                    } else {
                                        c.title = x
                                    }
                                    c.field = x
                                    cols.push(c)
                                }
                                $("#h-ftp-curve-manage-info-table-details").bootstrapTable('destroy');
                                $("#h-ftp-curve-manage-info-table-details").bootstrapTable({
                                    height:document.documentElement.clientHeight-130,
                                    columns:cols,
                                }).bootstrapTable('load',dt);
                            }
                        });
                    },
                });

                $.getJSON("/v1/ftp/curve/manage/get",{
                    domain_id:domain_id,
                    curve_id:first_curve_id,
                },function (data) {

                    var dt = new Array;
                    $(data).each(function (index, element) {
                        var d = {};
                        d.as_of_date = element.as_of_date;
                        $(element.curve_yield).each(function(index,element){
                            d[element.struct_code] = element.yield;
                        });
                        dt.push(d)
                    });

                    if (dt.length == 0){
                        $.Notify({
                            title:"温馨提示:",
                            message:"这条曲线暂时没有配置任何值",
                            type:"info",
                        });
                        $("#h-ftp-curve-manage-info-table-details").bootstrapTable({
                            height:document.documentElement.clientHeight-130,
                        });
                        $("#h-ftp-curve-manage-info-table-details").bootstrapTable('load',dt);
                        return
                    }else{
                        var cols = new Array;

                        // 初始化checkbox选择框
                        var ck = {}
                        ck.field = "state"
                        ck.checkbox = "true"
                        cols.push(ck)

                        var row = dt[0];
                        for ( var x in row){
                            var c = {}
                            if (x == "as_of_date"){
                                c.title = "数据日期"
                            } else {
                                c.title = x
                            }
                            c.field = x
                            cols.push(c)
                        }

                        $("#h-ftp-curve-manage-info-table-details").bootstrapTable({
                            height:document.documentElement.clientHeight-130,
                            columns:cols,
                        }).bootstrapTable('load',dt);
                    }
                });
            })
        },
        defaultQuery:function (curve_id) {
            var domain_id= $("#h-ftp-curve-manage-info-domain-list").val();
            $.getJSON("/v1/ftp/curve/manage/get",{
                domain_id:domain_id,
                curve_id:curve_id,},function (data) {
                var dt = new Array;
                $(data).each(function (index, element) {
                    var d = {};
                    d.as_of_date = element.as_of_date;
                    $(element.curve_yield).each(function(index,element){
                        d[element.struct_code] = element.yield;
                    });
                    dt.push(d)
                });

                if (dt.length == 0){
                    $.Notify({
                        message:"这条曲线暂时没有配置任何值",
                        info:"info",
                    });
                    var $table = $("#h-ftp-curve-manage-info-table-details");
                    $table.bootstrapTable('destroy');
                    $table.bootstrapTable();
                    return
                }else{
                    var cols = new Array;

                    // 初始化checkbox选择框
                    var ck = {}
                    ck.field = "state"
                    ck.checkbox = "true"
                    cols.push(ck)

                    var row = dt[0];
                    for ( var x in row){
                        var c = {}
                        if (x == "as_of_date"){
                            c.title = "数据日期"
                        } else {
                            c.title = x
                        }
                        c.field = x
                        cols.push(c)
                    }
                    var $table = $("#h-ftp-curve-manage-info-table-details");
                    $table.bootstrapTable('destroy');
                    $table.bootstrapTable({
                        columns:cols,
                    });
                    $table.bootstrapTable('load',dt);
                }
            });
        },
        update:function () {

            var rows = $("#h-ftp-curve-manage-info-table-details").bootstrapTable('getSelections');

            if (rows.length === 0) {
                $.Notify({
                    message:"请在列表中选择一项进行更新",
                    type:"info",
                });
                return
            } else if (rows.length != 1) {
                $.Notify({
                    message:"只能选择<span style='color: red; font-weight: 600;'>一项</span>进行更新操作",
                    type:"warning",
                });
                return
            }

            var pre = function(){
                var curve_id = $("#h-curve-manage-curve-list").val();
                var curve_desc = $("#h-curve-manage-curve-list option:selected").text().trim();
                var domain_id = $("#h-ftp-curve-manage-info-domain-list").val();
                var domain_desc = $("#h-ftp-curve-manage-info-domain-list option:selected").text().trim();

                var tmp = curve_id.split("_join_");
                if (tmp.length === 2){
                    var code_number = tmp[1]
                    $("#h-add-curve-info-form").find("input[name='code_number']").val(code_number);
                } else if (tmp.length === 1){
                    var code_number = tmp[0]
                    $("#h-add-curve-info-form").find("input[name='code_number']").val(code_number);
                } else {
                    $("#h-add-curve-info-form").find("input[name='code_number']").val(curve_id);
                }
                $("#h-add-curve-info-form").find("input[name='curve_id']").val(curve_id);
                $("#h-add-curve-info-form").find("input[name='curve_desc']").val(curve_desc);
                $("#h-add-curve-info-form").find("input[name='domain_id']").val(domain_id);
                $("#h-add-curve-info-form").find("input[name='domain_desc']").val(domain_desc);

                $.getJSON("/v1/ftp/curve/struct/owner/get",{domain_id:domain_id, curve_id:curve_id},function(data){
                    var optHtml = "";
                    $(data).each(function(index,element){
                        optHtml +='<div class="col-sm-2 col-md-2 col-lg-2" style="padding: 3px 3px;"><label class="control-label" style="width: 40px;">'+element.struct_code+'</label><input style="height: 23px;line-height: 23px;" class="form-control" type="text" name="'+element.struct_code+'"/></div>'
                    });
                    $("#h-curve-info-getted-term").html(optHtml)
                    $("#h-add-curve-info-form").find("input[name='as_of_date']").attr("readonly","readonly").attr("onclick","");
                    for (var x in rows[0]){
                        $("#h-add-curve-info-form").find("input[name='"+x+"']").val(rows[0][x])
                    }
                });
            };

            var sub = function(hmode){
                var curve_id = $("#h-curve-manage-curve-list").val();
                $.HAjaxRequest({
                    url:'/v1/ftp/curve/manage/put',
                    type:"put",
                    data:$("#h-add-curve-info-form").serialize(),
                    dataType:'json',
                    success:function(){
                        $.Notify({
                            message:"添加曲线值成功",
                            type:"success"
                        });
                        FtpCurveManageObj.defaultQuery(curve_id);
                        $(hmode).remove();
                    },
                    error:function (e) {
                        var msg = JSON.parse(e.responseText)
                        if (msg.error_code == 429){
                            $.Hconfirm({
                                header:"",
                                body:'<span style="height: 90px; line-height: 90px;padding-left: 60px;font-size: 14px;font-weight: 600;">曲线值已存在，是否更新曲线值？</span>',
                                callback:function () {
                                    $.HAjaxRequest({
                                        url: '/v1/ftp/curve/manage/put',
                                        type: "put",
                                        data: $("#h-add-curve-info-form").serialize(),
                                        dataType: 'json',
                                        success: function () {
                                            $.Notify({
                                                message:"更新曲线信息值成功",
                                                type:"success"
                                            });
                                            $(hmode).remove();
                                            FtpCurveManageObj.defaultQuery(curve_id)
                                        }
                                    });
                                }
                            });
                            return
                        }
                        $.Notify({
                            message:msg.error_msg,
                            type:"danger"
                        })
                    }
                });
            };

            $.Hmodal({
                header:"编辑收益率曲线值信息",
                body:$("#h-curve-yield-add").html(),
                width:"580px",
                preprocess:pre,
                callback:sub,
            })
        },
    };
    
    $(document).ready(function () {
        Hutils.InitDomain({
            id:"#h-ftp-curve-manage-info-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                FtpCurveManageObj.initCurveTable();
            },
            callback:function (domainId) {
                $.getJSON("/v1/ftp/curve/define/list",{
                    domain_id:domainId,
                },function (cdata) {
                    var first_curve_id = "{{.}}"
                    var curvelist = new Array()
                    $(cdata).each(function (index, element) {
                        var e = {};
                        e.id = element.curve_id;
                        e.text = element.curve_desc;
                        e.upId = "##hzwy23##";
                        curvelist.push(e)
                    });

                    $("#h-curve-manage-curve-list").Hselect({
                        height:"24px",
                        data:curvelist,
                        value:first_curve_id,
                        width:"180px",
                        onclick:function () {

                            $.getJSON("/v1/ftp/curve/manage/get",{
                                domain_id:$("#h-ftp-curve-manage-info-domain-list").val(),
                                curve_id:$("#h-curve-manage-curve-list").val(),
                            },function (data) {

                                var dt = new Array;
                                $(data).each(function (index, element) {
                                    var d = {};
                                    d.as_of_date = element.as_of_date;
                                    $(element.curve_yield).each(function(index,element){
                                        d[element.struct_code] = element.yield;
                                    });
                                    dt.push(d)
                                });

                                if (dt.length == 0){
                                    $.Notify({
                                        message:"这条曲线暂时没有配置任何值",
                                        type:"info",
                                    });
                                    $("#h-ftp-curve-manage-info-table-details").bootstrapTable('load',dt);
                                    return
                                } else {
                                    var cols = new Array;

                                    // 初始化checkbox选择框
                                    var ck = {}
                                    ck.field = "state"
                                    ck.checkbox = "true"
                                    cols.push(ck)

                                    var row = dt[0];
                                    for ( var x in row){
                                        var c = {}
                                        if (x == "as_of_date"){
                                            c.title = "数据日期"
                                        } else {
                                            c.title = x
                                        }
                                        c.field = x
                                        cols.push(c)
                                    }
                                    $("#h-ftp-curve-manage-info-table-details").bootstrapTable('destroy');
                                    $("#h-ftp-curve-manage-info-table-details").bootstrapTable({
                                        columns:cols,
                                    }).bootstrapTable('load',dt);
                                }
                            });
                        },
                    });
                    if (first_curve_id != "_empty_") {
                        FtpCurveManageObj.search();
                    } else {
                        $("#h-ftp-curve-manage-info-table-details").bootstrapTable()
                    }
                })
            },
        });
    });
</script>

<script id="h-curve-yield-add" type="text/html">
    <form class="row" id="h-add-curve-info-form">
        <div class="form-group-sm col-sm-6 col-md-6 col-lg-6">
            <label class="control-label" style="font-size: 12px;">曲线编码：</label>
            <input readonly="readonly" name="code_number" type="text" class="form-control" style="height: 30px;line-height: 30px;">
            <input readonly="readonly" name="curve_id" type="text" class="form-control" style="height: 30px;line-height: 30px;display: none;">
        </div>
        <div class="form-group-sm col-sm-6 col-md-6 col-lg-6">
            <label class="control-label" style="font-size: 12px;">曲线名称：</label>
            <input disabled="disabled" name="curve_desc" type="text" class="form-control" style="height: 30px;line-height: 30px;"/>
        </div>
        <div class="form-group-sm col-sm-6 col-md-6 col-lg-6" style="margin-top: 12px;">
            <label class="control-label" style="font-size: 12px;">所属域：</label>
            <input disabled="disabled" name="domain_desc" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;"/>
        </div>
        <div class="form-group-sm col-sm-6 col-md-6 col-lg-6" style="margin-top: 12px;">
            <label class="control-label" style="font-size: 12px;">数据日期：</label>
            <input name="old_as_of_date" onclick="laydate()" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;display: none"/>
            <input name="as_of_date" placeholder="数据日期" onclick="laydate()" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;"/>
        </div>
        <div class="form-group-sm col-sm-6 col-md-6 col-lg-6" style="display: none">
            <input readonly="readonly" name="domain_id" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 12px;">收益率：</label>
            <div id="h-curve-info-getted-term"></div>
        </div>
    </form>
</script>