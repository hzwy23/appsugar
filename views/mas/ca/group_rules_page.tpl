<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">规则组信息配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-ca-group-rules-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0202040200"}}
        <button onclick="CaGroupRuleObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202040300"}}
        <button onclick="CaGroupRuleObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202040400"}}
        <button onclick="CaGroupRuleObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
    <div id="h-ca-group-rules-content">
        <table id="h-ca-group-rules-table-details"
               data-toggle="table"
               data-striped="true"
               data-click-to-select="true"
               data-side-pagination="client"
               data-pagination="true"
               data-page-list="[20, 50, 100, 200]"
               data-search="false">
            <thead>
            <tr>
                <th data-field="state" data-checkbox="true"></th>
                <th data-sortable="true" data-field="code_number">规则组编码</th>
                <th data-sortable="true" data-field="group_desc">规则组名称</th>
                <th data-sortable="true" data-align="center" data-field="status_cd" data-formatter="CaGroupRuleObj.formatterStatus">状态</th>
                <th data-sortable="true" data-align="center" data-field="create_date">创建日期</th>
                <th data-sortable="true" data-align="center" data-field="create_user">创建人</th>
                <th data-sortable="true" data-align="center" data-field="modify_date">修改日期</th>
                <th data-sortable="true" data-align="center" data-field="modify_user">修改人</th>
                <th data-align="center" data-formatter="CaGroupRuleObj.formatterhandle">操作</th>
            </tr>
            </thead>
        </table>
    </div>
</div>
<script type="text/javascript">

    var CaGroupRuleObj = {
        delete:function () {
            var rows = $("#h-ca-group-rules-table-details").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"请在列表中选择规则组信息",
                    type:"info",
                })
                return
            }
            $.Hconfirm({
                body:"点击确定,删除规则组信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/amart/group/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                message:"删除规则组定义信息成功",
                                type:"success",
                            });
                            $("#h-ca-group-rules-table-details").bootstrapTable('refresh');
                        }
                    })
                },
            })
        },
        edit:function () {
            var rows = $("#h-ca-group-rules-table-details").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"请在列表中选择规则组信息",
                    type:"info",
                })
                return
            } else if (rows.length > 1) {
                $.Notify({
                    message:"您选择了多个规则组,请只选择一个进行编辑",
                    type:"info",
                });
                return
            }

            $.Hmodal({
                header:"定义规则组",
                width:"420px",
                body:$("#h-ca-group-rules-src").html(),
                preprocess:function () {
                    var domain_id = rows[0].domain_id;
                    var status_cd = rows[0].status_cd;
                    var group_id = rows[0].code_number;
                    var group_desc = rows[0].group_desc;


                    $("#h-ca-group-rules-form").find("input[name='domain_id']").val(domain_id);

                    $("#h-ca-group-rules-form").find("select[name='status_cd']").Hselect({
                        height:"30px",
                        value:status_cd,
                    });

                    $("#h-ca-group-rules-form").find("input[name='group_desc']").val(group_desc);
                    $("#h-ca-group-rules-form").find("input[name='group_id']").val(group_id).attr("readonly","readonly");

                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/amart/group/put",
                        type:"put",
                        data:$("#h-ca-group-rules-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"新增规则组定义成功",
                                type:"success",
                            });
                            $("#h-ca-group-rules-table-details").bootstrapTable('refresh');
                            $(hmode).remove();
                        },
                    })
                }
            })
        },
        add:function () {
            $.Hmodal({
                header:"定义规则组",
                width:"420px",
                body:$("#h-ca-group-rules-src").html(),
                preprocess:function () {
                    var domain_id = $("#h-ca-group-rules-domain-list").val();
                    $("#h-ca-group-rules-form").find("input[name='domain_id']").val(domain_id);

                    $("#h-ca-group-rules-form").find("select[name='status_cd']").Hselect({
                        height:"30px",
                    });

                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/amart/group/post",
                        type:"post",
                        data:$("#h-ca-group-rules-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"新增规则组定义成功",
                                type:"success",
                            });
                            $("#h-ca-group-rules-table-details").bootstrapTable('refresh');
                            $(hmode).remove();
                        },
                    })
                }
            })
        },
        getRulesInfo:function (gid,name) {
            var name = name+"规则管理"
            Hutils.openTab({
                url:"/v1/ca/amart/group/rules/page?id="+gid,
                id:"GroupRulesConfig1989",
                title:name,
            })
        },
        formatterhandle:function (value,rows,index) {
            var html = "-";
            {{if checkResIDAuth "2" "0202040500"}}
                html = '<span class="h-td-btn btn-primary btn-xs" onclick="CaGroupRuleObj.getRulesInfo(\''+rows.group_id+'\',\''+rows.group_desc+'\')">规则管理</span>';
            {{end}}
            return html;
        },
        formatterStatus:function (value, rows, index) {
            if (value == "0"){
                return "正常"
            } else if (value == "1"){
                return "禁用"
            } else {
                return "-"
            }
        }
    };

    $(document).ready(function () {
        Hutils.InitDomain({
            id:"#h-ca-group-rules-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                $("#h-ca-group-rules-table-details").bootstrapTable('refresh');
            },
            callback:function () {
                $("#h-ca-group-rules-table-details").bootstrapTable({
                    url:"/v1/ca/amart/group/get",
                    queryParams:function (params) {
                        params.domain_id = $("#h-ca-group-rules-domain-list").val();
                        return params
                    }
                });
            }
        });
    })
</script>

<script type="text/html" id="h-ca-group-rules-src">
    <form class="row" id="h-ca-group-rules-form">
        <div class="col-sm-12">
            <span>分摊规则组编码:</span>
            <input name="group_id" class="form-control" type="text" style="height: 30px;line-height: 30px;" placeholder="由1-30位字母,数字组成"/>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>分摊规则组名称:</span>
            <input name="group_desc" class="form-control" type="text" style="height: 30px;line-height: 30px;" placeholder="规则编码的详细描述"/>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>规则组状态:</span>
            <select name="status_cd" class="form-control" type="text" placeholder="规则编码的详细描述">
                <option value="0">正常</option>
                <option value="1">禁止</option>
            </select>
        </div>
        <input name="domain_id" style="display: none;" />
    </form>
</script>