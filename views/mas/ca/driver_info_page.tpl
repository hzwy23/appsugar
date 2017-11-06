<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">动因信息配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-driver-info-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0201040200"}}
        <button onclick="CaDriverInfoObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201040300"}}
        <button onclick="CaDriverInfoObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201040500"}}
        <button onclick="CaDriverInfoObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-edit"> 导入</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201040600"}}
        <button onclick="CaDriverInfoObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 导出</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201040400"}}
        <button onclick="CaDriverInfoObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
    <div id="h-driver-info-content">
        <table id="h-driver-info-table-details"
               data-toggle="table"
               data-striped="true"
               data-url="/v1/ca/driver/get"
               data-click-to-select="true"
               data-side-pagination="client"
               data-pagination="true"
               data-page-size="20"
               data-page-list="[10,20,30,50,100,200]"
               data-search="false">
            <thead>
            <tr>
                <th data-field="state" data-checkbox="true"></th>
                <th data-sortable="true" data-field="code_number">动因编码</th>
                <th data-sortable="true" data-field="driver_desc">动因名称</th>
                <th data-sortable="true" data-align="center" data-field="create_date">创建日期</th>
                <th data-sortable="true" data-align="center" data-field="create_user">创建人</th>
                <th data-sortable="true" data-align="center" data-field="modify_date">修改日期</th>
                <th data-sortable="true" data-align="center" data-field="modify_user">修改人</th>
            </tr>
            </thead>
        </table>
    </div>
</div>
<script type="text/javascript">
    var CaDriverInfoObj = {
        upload:function () {
            $.Hupload({
                url:"/v1/ca/driver/upload",
                header:"动因参数配置信息导入",
                callback:function () {
                    $("#h-driver-info-table-details").bootstrapTable('refresh');
                },
            })
        },
        download:function () {
            var domain_id = $("#h-driver-info-domain-list").val();
            $.Hdownload({
                url:"/v1/ca/driver/download?domain_id="+domain_id,
                name:"动因配置参数",
            })
        },
        edit:function () {
            var rows = $("#h-driver-info-table-details").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"您没有选择需要编辑的动因信息",
                    type:"info",
                });
                return
            } else if (rows.length > 1) {
                $.Notify({
                    message:"只能选择<span style='font-weight: 600;color: red'> 一项 </span>进行编辑",
                    type:"warning",
                });
                return
            }

            $.Hmodal({
                header:"编辑动因信息",
                body:$("#h-ca-driver-info-src").html(),
                width:"420px",
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/driver/put",
                        type:"put",
                        data:$("#h-ca-driver-info-form-add").serialize(),
                        success:function () {
                            $("#h-driver-info-table-details").bootstrapTable('refresh');
                            $(hmode).remove();
                        },
                    })
                },
                preprocess:function () {
                    $("#h-ca-driver-info-form-add").find("input[name='domain_id']").val(rows[0].domain_id)
                    $("#h-ca-driver-info-form-add").find("input[name='driver_id']").val(rows[0].code_number).attr("readonly","readonly")
                    $("#h-ca-driver-info-form-add").find("input[name='driver_desc']").val(rows[0].driver_desc)
                }
            })
        },
        add:function () {
            $.Hmodal({
                header:"新增动因信息",
                body:$("#h-ca-driver-info-src").html(),
                width:"420px",
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/driver/post",
                        type:"post",
                        data:$("#h-ca-driver-info-form-add").serialize(),
                        success:function () {
                            $("#h-driver-info-table-details").bootstrapTable('refresh');
                            $(hmode).remove();
                        },
                    })
                },
                preprocess:function () {
                    var domain_id = $("#h-driver-info-domain-list").val();
                    $("#h-ca-driver-info-form-add").find("input[name='domain_id']").val(domain_id)
                }
            })
        },
        delete:function () {
            var rows = $("#h-driver-info-table-details").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"您没有选择需要删除的动因信息",
                    type:"warning",
                });
                return
            }
            $.Hconfirm({
                body:"点击确认,将会删除动因信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/driver/delete",
                        type:"Post",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                message:"删除动因信息成功",
                                type:"success",
                            });
                            $("#h-driver-info-table-details").bootstrapTable('refresh');
                        }
                    })
                }
            })
        },
    };

    $(document).ready(function () {
        Hutils.InitDomain({
            height:"24px",
            width:"180px",
            id:"#h-driver-info-domain-list",
            onclick:function () {
                $("#h-driver-info-table-details").bootstrapTable('refresh');
            },
            callback:function (domainId) {
                $("#h-driver-info-table-details").bootstrapTable({
                    queryParams:function (params) {
                        params.domain_id = $("#h-driver-info-domain-list").val();
                        return params
                    }
                });
            }
        });
    })
</script>

<script id="h-ca-driver-info-src" type="text/html">
    <form class="row" id="h-ca-driver-info-form-add">
        <div class="col-sm-12">
            <span>动因编码</span>
            <input placeholder="由1-30位字母,数字组成（必填）" name="driver_id" class="form-control" style="height: 30px; line-height: 30px;"/>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>动因名称</span>
            <input placeholder="对动因编码的详细描述信息（必填）" name="driver_desc" class="form-control" style="height: 30px; line-height: 30px;" />
        </div>
        <input name="domain_id" style="display: none;"/>
    </form>
</script>