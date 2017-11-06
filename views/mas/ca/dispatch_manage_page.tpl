<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">分摊批次配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-ca-dispatch-manage-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0203010100"}}
        <button onclick="CaDispatchManageObj.refresh()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-refresh"> 刷新</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0203010200"}}
        <button onclick="CaDispatchManageObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0203010300"}}
        <button onclick="CaDispatchManageObj.edit()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0203010500"}}
        <button onclick="CaDispatchManageObj.run()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 运行</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0203010600"}}
        <button onclick="CaDispatchManageObj.stop()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 停止</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0203010700"}}
        <button onclick="CaDispatchManageObj.config()" class="btn btn-info btn-sm" title="配置批次">
            <span class="icon-wrench"> 配置</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0203010400"}}
        <button onclick="CaDispatchManageObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
    <div id="h-ca-dispatch-manage-content">
        <table id="h-ca-dispatch-manage-table-details"
               data-toggle="table"
               data-striped="true"
               data-click-to-select="true"
               data-unique-id="dispatch_id"
               data-url="/v1/ca/dispatch/get"
               data-side-pagination="client"
               data-pagination="true"
               data-page-size="30"
               data-page-list="[20, 50, 100, 200]"
               data-search="false">
            <thead>
            <tr>
                <th data-field="state" data-checkbox="true"></th>
                <th data-sortable="true" data-field="code_number">批次编码</th>
                <th data-sortable="true" data-field="dispatch_desc">批次名称</th>
                <th data-sortable="true" data-align="center" data-field="as_of_date">批次日期</th>
                <th data-sortable="true" data-align="center" data-field="dispatch_status_desc">批次状态</th>
                <th data-sortable="true" data-align="center" data-field="start_date">开始时间</th>
                <th data-sortable="true" data-align="center" data-field="end_date">结束时间</th>
                <!--<th data-align="center" data-field="modify_date">修改日期</th>-->
                <!--<th data-align="center" data-field="modify_user">修改人</th>-->
                <!-- <th data-align="center" data-field="ret_msg">消息</th> -->
            </tr>
            </thead>
        </table>
    </div>
</div>

<script type="text/javascript">
    var CaDispatchManageObj = {
        refresh:function () {
            $("#h-ca-dispatch-manage-table-details").bootstrapTable('refresh');
        },
        run:function () {
            var row = $("#h-ca-dispatch-manage-table-details").bootstrapTable('getSelections')
            if (row.length == 0) {
                $.Notify({
                    message:"您没有选择需要启动的批次",
                    type:"info",
                });
                return
            } else if (row.length > 1) {
                $.Notify({
                    message:"您选择了多个批次,一次只能启动一个批次",
                    type:"info",
                });
                return
            }

            $.Hconfirm({
                body:"点击确定，开启分摊引擎",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/dispatch/run",
                        type:"GET",
                        data:{domain_id:row[0].domain_id,dispatch_id:row[0].dispatch_id},
                        success:function () {
                            $.Notify({
                                message:"批次启动成功",
                                type:"success"
                            })
                        }
                    })
                }
            })
        },
        stop:function () {
            var row = $("#h-ca-dispatch-manage-table-details").bootstrapTable('getSelections')
            if (row.length == 0) {
                $.Notify({
                    message:"您没有选择需要启动的批次",
                    type:"info",
                });
                return
            } else if (row.length > 1) {
                $.Notify({
                    message:"您选择了多个批次,一次只能启动一个批次",
                    type:"info",
                });
                return
            }

            $.Hconfirm({
                body:"点击确定，停止批次",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/dispatch/stop",
                        type:"GET",
                        data:{domain_id:row[0].domain_id,dispatch_id:row[0].dispatch_id},
                        success:function () {
                            $.Notify({
                                message:"停止批次成功",
                                type:"success"
                            })
                        }
                    })
                }
            })
        },
        dbClick:function (row,$element) {
            var dispatch_id = row.dispatch_id;
            var domain_id = row.domain_id;
            var name = row.dispatch_desc+" 任务组管理"
            Hutils.openTab({
                url:"/v1/ca/dispatch/config/page?dispatch_id="+dispatch_id+"&domain_id="+domain_id,
                id:"CaDispatchConfig1989",
                title:name,
            })
        },
        config:function () {
            var row = $("#h-ca-dispatch-manage-table-details").bootstrapTable('getSelections')
            if (row.length == 0) {
                $.Notify({
                    message:"您没有选择需要配置任务组的批次",
                    type:"info",
                })
                return
            } else if (row.length > 1) {
                $.Notify({
                    message:"您选择了多个批次,请只选择一项进行任务组配置",
                    type:"info",
                })
                return
            }

            var check = true;
            $(row).each(function (index, element) {
                if (element.dispatch_status_cd == "1") {
                    check = false
                    return false
                }
            });

            var dispatch_id = row[0].dispatch_id;
            var domain_id = row[0].domain_id;
            var name = row[0].dispatch_desc+" 任务组管理"
            Hutils.openTab({
                url:"/v1/ca/dispatch/config/page?dispatch_id="+dispatch_id+"&domain_id="+domain_id,
                id:"CaDispatchConfig1989",
                title:name,
            })
        },
        delete:function () {
            var row = $("#h-ca-dispatch-manage-table-details").bootstrapTable('getSelections')
            if (row.length == 0) {
                $.Notify({
                    message:"您没有选择需要删除的批次信息",
                    type:"info",
                })
                return
            }
            var check = true;
            $(row).each(function (index, element) {
                if (element.dispatch_status_cd == "1") {
                    check = false
                    return false
                }
            });
            if (!check) {
                $.Notify({
                    message:"不能删除运行中的任务",
                    type:"danger",
                });
                return
            }
            $.Hconfirm({
                body:"点击确定,删除批次信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/dispatch/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(row)},
                        success:function () {
                            $.Notify({
                                message:"删除批次信息成功",
                                type:"success",
                            });
                            $(row).each(function (index, element) {
                                $("#h-ca-dispatch-manage-table-details").bootstrapTable('removeByUniqueId',element.dispatch_id)
                            })
                        }
                    })
                }
            })
        },
        add:function () {
            $.Hmodal({
                width:"420px",
                header:"新增批次信息",
                body:$("#h-ca-dispatch-manage-src").html(),
                preprocess:function () {
                    var domain_id = $("#h-ca-dispatch-manage-domain-list").val();
                    $("#h-ca-dispatch-manage-form").find("input[name='domain_id']").val(domain_id);

                    $("#h-ca-dispatch-manage-form").find("select[name='dispatch_status_cd']").Hselect({
                        height:"30px",
                        value:"0",
                        disabled:true,
                    })
                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/dispatch/post",
                        type:"post",
                        data:$("#h-ca-dispatch-manage-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"新增批次信息成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            $("#h-ca-dispatch-manage-table-details").bootstrapTable('refresh')
                        },
                    })
                },
            })
        },
        edit:function () {
            var row = $("#h-ca-dispatch-manage-table-details").bootstrapTable('getSelections')
            if (row.length == 0) {
                $.Notify({
                    message:"您没有选择需要编辑的批次信息",
                    type:"info",
                });
                return
            } else if (row.length > 1) {
                $.Notify({
                    message:"您选择了多个批次,请只选择一项进行编辑",
                    type:"info",
                })
                return
            }

            var check = true;
            $(row).each(function (index, element) {
                if (element.dispatch_status_cd == "1") {
                    check = false
                    return false
                }
            });
            if (!check) {
                $.Notify({
                    message:"不能编辑运行中的任务",
                    type:"danger",
                });
                return
            }

            $.Hmodal({
                width:"420px",
                header:"修改批次信息",
                body:$("#h-ca-dispatch-manage-src").html(),
                preprocess:function () {

                    $("#h-ca-dispatch-manage-form").find("input[name='domain_id']").val(row[0].domain_id);

                    $("#h-ca-dispatch-manage-form").find("select[name='dispatch_status_cd']").Hselect({
                        height:"30px",
                        value:row[0].dispatch_status_cd,
                        disabled:true,
                    });

                    $("#h-ca-dispatch-manage-form").find("input[name='dispatch_id']").val(row[0].code_number).attr("readonly","readonly");
                    $("#h-ca-dispatch-manage-form").find("input[name='dispatch_desc']").val(row[0].dispatch_desc);
                    $("#h-ca-dispatch-manage-form").find("input[name='as_of_date']").val(row[0].as_of_date);

                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/dispatch/put",
                        type:"put",
                        data:$("#h-ca-dispatch-manage-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"新增批次信息成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            $("#h-ca-dispatch-manage-table-details").bootstrapTable('refresh')
                        },
                    })
                },
            })
        },
    };
    $(document).ready(function () {

        Hutils.InitDomain({
            id:"#h-ca-dispatch-manage-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                $("#h-ca-dispatch-manage-table-details").bootstrapTable('refresh')
            },
            callback:function () {
                $("#h-ca-dispatch-manage-table-details").bootstrapTable({
                {{if checkResIDAuth "2" "0203010700"}}
                    onDblClickRow:CaDispatchManageObj.dbClick,
                {{end}}
                    queryParams:function (params) {
                        params.domain_id = $("#h-ca-dispatch-manage-domain-list").val();
                        return params
                    }
                });
            }
        });
    })
</script>

<script id="h-ca-dispatch-manage-src" type="text/html">
    <form class="row" id="h-ca-dispatch-manage-form">
        <div class="col-sm-12">
            <span>批次编码</span>
            <input placeholder="由1-30位字母,数字组成" name="dispatch_id" type="text" class="form-control" style="height: 30px; line-height: 30px;"/>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>批次名称</span>
            <input placeholder="批次详细描述信息" name="dispatch_desc" type="text" class="form-control" style="height: 30px; line-height: 30px;"/>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>批次状态</span>
            <select placeholder="批次详细描述信息" name="dispatch_status_cd" type="text" class="form-control" style="height: 30px; line-height: 30px;">
                <option value="0">未运行</option>
                <option value="1">运行中</option>
                <option value="2">已完成</option>
                <option value="3">错误</option>
                <option value="4">停止</option>
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>批次日期</span>
            <input onclick="laydate(this)" placeholder="批次运行日期" name="as_of_date" type="text" class="form-control" style="height: 30px; line-height: 30px;"/>
        </div>
        <input name="domain_id" style="display: none;"/>
    </form>
</script>