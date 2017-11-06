<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">币种信息配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-common-currency-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        <button onclick="CommonIsoCurrencyObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        <button onclick="CommonIsoCurrencyObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        <button onclick="CommonIsoCurrencyObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-edit"> 导入</span>
        </button>
        <button onclick="CommonIsoCurrencyObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 导出</span>
        </button>
        <button onclick="CommonIsoCurrencyObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
    </div>
</div>
<div id="h-common-currency-content" class="subsystem-content" style="padding-top: 3px;">
    <table id="h-common-currency-table-id"
           data-toggle="table"
           data-striped="true"
           data-click-to-select="true"
           data-url="/v1/common/isocurrency/get"
           data-side-pagination="client"
           data-pagination="true"
           data-page-list="[20, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-sortable="true" data-field="code_number">币种编码</th>
            <th data-sortable="true" data-field="iso_currency_desc">币种名称</th>
            <th data-sortable="true" data-align="center" data-field="create_date">创建日期</th>
            <th data-sortable="true" data-align="center" data-field="create_user">创建人</th>
            <th data-sortable="true" data-align="center" data-field="modify_date">修改日期</th>
            <th data-sortable="true" data-align="center" data-field="modify_user">修改人</th>
        </tr>
        </thead>
    </table>
</div>
<script type="text/javascript">
    var CommonIsoCurrencyObj = {
        upload:function () {
            $.Hupload({
                url:"/v1/common/isocurrency/upload",
                header:"币种参数配置信息导入",
                callback:function () {
                    $("#h-common-currency-table-id").bootstrapTable('refresh');
                },
            })
        },
        download:function () {
            var domain_id = $("#h-common-currency-domain-list").val();
            $.Hdownload({
                url:"/v1/common/isocurrency/download?domain_id="+domain_id,
                name:"币种信息配置参数",
            })
        },
        edit:function () {
            var rows = $("#h-common-currency-table-id").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"请选择需要编辑的币种信息",
                    type:"info",
                });
                return
            } else if (rows.length > 1) {
                $.Notify({
                    message:"只能对<span style='color: red;font-weight: 600;'>一项</span>进行编辑",
                    type:"warning",
                });
                return
            }

            $.Hmodal({
                header:"编辑币种信息",
                body:$("#h-common-currency-src").html(),
                width:"420px",
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/common/isocurrency/put",
                        type:"put",
                        data:$("#h-common-currency-form").serialize(),
                        success:function () {
                            $("#h-common-currency-table-id").bootstrapTable('refresh');
                            $(hmode).remove();
                        },
                    })
                },
                preprocess:function () {
                    $("#h-common-currency-form").find("input[name='domain_id']").val(rows[0].domain_id)
                    $("#h-common-currency-form").find("input[name='iso_currency_cd']").val(rows[0].code_number).attr("readonly","readonly")
                    $("#h-common-currency-form").find("input[name='iso_currency_desc']").val(rows[0].iso_currency_desc)
                }
            })
        },
        add:function () {
            $.Hmodal({
                header:"新增币种信息",
                body:$("#h-common-currency-src").html(),
                width:"420px",
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/common/isocurrency/post",
                        type:"post",
                        data:$("#h-common-currency-form").serialize(),
                        success:function () {
                            $("#h-common-currency-table-id").bootstrapTable('refresh');
                            $(hmode).remove();
                        },
                    })
                },
                preprocess:function () {
                    var domain_id = $("#h-common-currency-domain-list").val();
                    $("#h-common-currency-form").find("input[name='domain_id']").val(domain_id)
                }
            })
        },
        delete:function () {
            var rows = $("#h-common-currency-table-id").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"请选择需要删除的币种信息",
                    type:"info",
                });
                return
            }
            $.Hconfirm({
                body:"点击确认将会删除币种信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/common/isocurrency/delete",
                        type:"Post",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                message:"删除币种信息成功",
                                type:"success",
                            });
                            $("#h-common-currency-table-id").bootstrapTable('refresh');
                        }
                    })
                }
            })
        },
    };

    $(document).ready(function () {
        $("#h-common-currency-content").height(document.documentElement.clientHeight-130)
        Hutils.InitDomain({
            id:"#h-common-currency-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                $("#h-common-currency-table-id").bootstrapTable('refresh');
            },
            callback:function (domainId) {
                $("#h-common-currency-table-id").bootstrapTable({
                    height:document.documentElement.clientHeight-130,
                    queryParams:function (params) {
                        params.domain_id = $("#h-common-currency-domain-list").val()
                        return params
                    }
                });
            }
        });
    })
</script>

<script id="h-common-currency-src" type="text/html">
    <form class="row" id="h-common-currency-form">
        <div class="col-sm-12">
            <span>币种编码</span>
            <input placeholder="由1-30位字母,数字组成（必填）" name="iso_currency_cd" class="form-control" style="height: 30px; line-height: 30px;"/>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>币种名称</span>
            <input placeholder="币种详细描述信息（必填）" name="iso_currency_desc" class="form-control" style="height: 30px; line-height: 30px;" />
        </div>
        <input name="domain_id" style="display: none;"/>
    </form>
</script>