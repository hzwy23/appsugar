<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">角色用户关联关系</span>
    </div>
    <div class="pull-right">
                <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline"
                      class="pull-left">&nbsp;角色编码 = <span id="h-role-resource-rel-role-id">{{.RoleId}}</span></span>
        <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline"
              class="pull-left">&nbsp;&nbsp;&nbsp;<i style="border: #0b4059 dotted 0.5px; height: 44px;"></i>&nbsp;&nbsp;&nbsp;角色名称 = {{.RoleName}}</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0105020610"}}
        <button onclick="UserRoleObj.add()" class="btn btn-info btn-sm">
            <i class="icon-plus"> 添加关联用户</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0105020620"}}
        <button onclick="UserRoleObj.delete()" class="btn btn-danger btn-sm">
            <i class="icon-trash"> 批量取消关联用户</i>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content">
    <table id="h-role-user-relation-table-details"
           class="table"
           data-toggle="table"
           data-unique-id="user_id"
           data-side-pagination="client"
           data-click-to-select="true"
           data-pagination="true"
           data-striped="true"
           data-page-size="30"
           data-show-refresh="false"
           data-page-list="[20,30, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-field="userId" data-sortable="true">账号</th>
            <th data-field="userDesc" data-sortable="true">用户名称</th>
            <th data-field="orgUnitId" data-sortable="true">机构编码</th>
            <th data-field="orgUnitDesc" data-sortable="true">机构描述</th>
            <th data-align="center" data-field="createUser" data-sortable="true">授权人</th>
            <th data-align="center" data-field="createTime" data-sortable="true">授权时间</th>
            <th data-align="center" data-formatter="UserRoleObj.formatter">操作</th>
        </tr>
        </thead>
    </table>
</div>
<script>
    $(document).ready(function(){
        $("#h-role-user-relation-table-details").bootstrapTable({
            url:"/v1/auth/role/query/user",
            queryParams:function (params) {
                params.roleId = $("#h-role-resource-rel-role-id").html();
                return params;
            }
        })
    });
    
    var UserRoleObj = {
        formatter:function (value,row,index) {
            var html = "-";
            {{if checkResIDAuth "2" "0105020620"}}
                html = '<span class="h-td-btn btn-danger btn-xs" onclick="UserRoleObj.deleteRow(\''+row.roleId+'\',\''+ row.userId+'\')">取消关联</span>';
            {{end}}
            return html;
        },
        add:function () {
            $.Hmodal({
                header:"添加关联用户",
                body:$("#h-role-user-add-src").html(),
                preprocess:function () {
                    $("#h-role-user-relation-add").bootstrapTable({
                        queryParams:function (param) {
                            param.roleId = $("#h-role-resource-rel-role-id").html();
                            return param;
                        }
                    });
                },
                callback:function (hmode) {
                    var rows = $("#h-role-user-relation-add").bootstrapTable('getSelections');
                    if (rows.length == 0){
                        $.Notify({
                            message:"请选择需要关联的用户",
                            type:"warning",
                        });
                        return;
                    }

                    var arr = new Array();
                    $(rows).each(function (index, element) {
                        var e = {};
                        e.user_id = element.userId;
                        e.role_id = element.roleId;
                        arr.push(e);
                    });

                    $.HAjaxRequest({
                        url: "/v1/auth/user/roles/auth",
                        type: "post",
                        data: {JSON: JSON.stringify(arr)},
                        success: function () {
                            $.Notify({
                                message: "角色关联新用户成功",
                                type: "success",
                            });
                            $(hmode).remove();
                            $("#h-role-user-relation-table-details").bootstrapTable('refresh');
                        },
                    })
                }
            })
        },
        delete:function () {
            var rows = $("#h-role-user-relation-table-details").bootstrapTable("getSelections");
            if (rows.length == 0){
                $.Notify({
                    message:"请在下表中选择需要取消关联的用户",
                    type:"warning",
                });
                return;
            }

            var arr = new Array();
            $(rows).each(function (index, element) {
                var e = {};
                e.user_id = element.userId;
                e.role_id = element.roleId;
                arr.push(e);
            });

            $.Hconfirm({
                body:"点击确定取消用户与角色关联关系",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/auth/user/roles/revoke",
                        type:"post",
                        data:{JSON:JSON.stringify(arr)},
                        success:function () {
                            $("#h-role-user-relation-table-details").bootstrapTable('refresh');
                        },
                    })
                }
            })
        },
        deleteRow:function (roleId,userId) {
            var arr = new Array();
            var e = {};
            e.user_id = userId;
            e.role_id = roleId;
            arr.push(e);
            $.HAjaxRequest({
                url:"/v1/auth/user/roles/revoke",
                type:"post",
                data:{JSON:JSON.stringify(arr)},
                success:function () {
                    $("#h-role-user-relation-table-details").bootstrapTable('refresh');
                },
            })
        }
    }
</script>

<script id="h-role-user-add-src" type="text/html">
    <table id="h-role-user-relation-add"
           class="table"
           data-toggle="table"
           data-unique-id="user_id"
           data-side-pagination="client"
           data-url="/v1/auth/role/query/user/other"
           data-click-to-select="true"
           data-pagination="false"
           data-striped="true"
           data-show-refresh="false"
           data-page-list="[20, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-field="userId" data-sortable="true">账号</th>
            <th data-field="userDesc" data-sortable="true">用户名称</th>
            <th data-field="orgUnitId" data-sortable="true">机构编码</th>
            <th data-field="orgUnitDesc" data-sortable="true">机构描述</th>
        </tr>
        </thead>
    </table>
</script>