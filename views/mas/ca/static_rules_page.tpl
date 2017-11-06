<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">静态规则配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-static-rules-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0202010200"}}
        <button onclick="CaStaticRulesDefObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202010300"}}
        <button onclick="CaStaticRulesDefObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202010400"}}
        <button onclick="CaStaticRulesDefObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
    <div id="h-static-rules-content">
        <table id="h-static-rules-table-details"
               data-toggle="table"
               data-striped="true"
               data-click-to-select="true"
               data-url="/v1/ca/static/radio/get"
               data-side-pagination="client"
               data-pagination="true"
               data-page-list="[20, 50, 100, 200]"
               data-search="false">
            <thead>
            <tr>
                <th data-field="state" data-checkbox="true"></th>
                <th data-sortable="true" data-field="code_number">静态规则编码</th>
                <th data-sortable="true" data-field="static_amart_desc">静态规则名称</th>
                <th data-sortable="true" data-align="center" data-field="create_date">创建日期</th>
                <th data-sortable="true" data-align="center" data-field="create_user">创建人</th>
                <th data-sortable="true" data-align="center" data-field="modify_date">修改日期</th>
                <th data-sortable="true" data-align="center" data-field="modify_user">修改人</th>
                <th data-sortable="true" data-align="center" data-formatter="CaStaticRulesDefObj.formatterhandle">操作</th>
            </tr>
            </thead>
        </table>
    </div>
</div>
<script type="text/javascript">

    var CaStaticRulesDefObj = {
        delete:function () {
            var rows = $("#h-static-rules-table-details").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"您没有选择需要删除的静态规则",
                    type:"warning",
                });
                return
            }
            $.Hconfirm({
                body:"点击确定,删除静态规则定义信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/static/radio/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $("#h-static-rules-table-details").bootstrapTable('refresh');
                            $.Notify({
                                message:"删除静态规则比例信息成功",
                                type:"success",
                            });
                        }
                    })
                }
            });
        },
        edit:function () {
            var rows = $("#h-static-rules-table-details").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"您没有选择需要编辑的静态规则",
                    type:"warning",
                });
                return
            } else if (rows.length > 1) {
                $.Notify({
                    message:"您选择了多个静态规则,请选择一个进行编辑",
                    type:"warning",
                });
                return
            }

            $.Hmodal({
                body:$("#h-ca-static-rule-src").html(),
                width:"420px",
                header:"编辑静态规则定义信息",
                preprocess:function () {
                    var domain_id = rows[0].domain_id;
                    $("#h-ca-static-rule-form").find("input[name='domain_id']").val(rows[0].domain_id);
                    $("#h-ca-static-rule-form").find("input[name='static_amart_id']").val(rows[0].code_number).attr("readonly","readonly");
                    $("#h-ca-static-rule-form").find("input[name='static_amart_desc']").val(rows[0].static_amart_desc);
                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/static/radio/put",
                        type:"put",
                        data:$("#h-ca-static-rule-form").serialize(),
                        success:function () {
                            $("#h-static-rules-table-details").bootstrapTable('refresh');
                            $.Notify({
                                message:"编辑静态规则比例信息成功",
                                type:"success",
                            });
                            $(hmode).remove();
                        }
                    })
                },
            })
        },
        add:function () {
            $.Hmodal({
                header:"新增静态分摊规则",
                width:"420px",
                body:$("#h-ca-static-rule-src").html(),
                preprocess:function () {
                    var domain_id = $("#h-static-rules-domain-list").val();
                    $("#h-ca-static-rule-form").find("input[name='domain_id']").val(domain_id);
                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/static/radio/post",
                        type:"post",
                        data:$("#h-ca-static-rule-form").serialize(),
                        success:function () {
                            $("#h-static-rules-table-details").bootstrapTable('refresh');
                            $.Notify({
                                message:"新增静态规则比例信息成功",
                                type:"success",
                            });
                            $(hmode).remove();
                        }
                    })
                },
            })
        },
        formatterhandle:function(value,row,index){
            var html = "-";
            {{if checkResIDAuth "2" "0202030000"}}
                html = '<span class="h-td-btn btn-primary btn-xs" onclick="CaStaticRulesDefObj.getStaticConfigPage(\''+row.static_amart_id+'\',\''+row.static_amart_desc+'\')">比例管理</span>';
            {{end}}
            return html;
        },
        getStaticConfigPage:function (id,name) {
            var name = name+"比例配置"
            Hutils.openTab({
                url:"/v1/ca/static/config/page?id="+id,
                id:"staticRulesConfig1989",
                title:name,
            })
        }
    };

    $(document).ready(function () {
        Hutils.InitDomain({
            id:"#h-static-rules-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                $("#h-static-rules-table-details").bootstrapTable('refresh');
            },
            callback:function () {
                $("#h-static-rules-table-details").bootstrapTable({
                    queryParams:function (params) {
                        params.domain_id = $("#h-static-rules-domain-list").val();
                        return params
                    }
                });
            }
        });
    })
</script>

<script type="text/html" id="h-ca-static-rule-src">
    <form class="row" id="h-ca-static-rule-form">
        <div class="col-sm-12">
            <span>静态分摊规则编码</span>
            <input placeholder="由1-30位字母,数字组成（必填）" name="static_amart_id" class="form-control" style="height: 30px;line-height: 30px;"/>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>静态分摊规则名称</span>
            <input placeholder="静态分摊规则详细描述信息（必填）" name="static_amart_desc" class="form-control" style="height: 30px;line-height: 30px;"/>
        </div>
        <div style="display: none;">
            <input name="domain_id"/>
        </div>
    </form>
</script>