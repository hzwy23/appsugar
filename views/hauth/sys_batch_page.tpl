<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">授权管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div style="height: 44px; line-height: 44px; width: 260px; display: inline">
        <span style="font-size: 10px;font-weight: 600;" class="pull-left">&nbsp;&nbsp;机构：</span>
        <select id="h-auth-org-list" class="form-control pull-left"
                style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px; padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0105040100"}}
        <button onclick="AuthObj.batchAuth()" class="btn btn-info btn-sm">
            <i class="icon-plus"> 批量授权</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0105040200"}}
        <button onclick="AuthObj.batchRemove()" class="btn btn-danger btn-sm">
            <i class="icon-trash"> 批量撤权</i>
        </button>
        {{end}}
    </div>
</div>
<div id="h-grant-user-table-show" class="subsystem-content">
    <table id="h-grant-info-table-details"
           data-toggle="table"
           data-striped="true"
           data-url="/v1/auth/user/get"
           data-click-to-select="true"
           data-side-pagination="client"
           data-pagination="true"
           data-page-size="30"
           data-page-list="[20,30, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-field="user_id" data-sortable="true">账户</th>
            <th data-field="user_name">用户名称</th>
            <th data-field="org_unit_desc" data-sortable="true">机构</th>
            <th data-width="160px" data-align="center" data-field="user_phone">手机号</th>
            <th data-field="user_email">邮箱</th>
            <th data-field="modify_user" data-sortable="true">修改人</th>
            <th data-field="modify_date" data-sortable="true">修改时间</th>
            <th data-align="center" data-formatter="AuthObj.formatterHandle">操作</th>
        </tr>
        </thead>
    </table>
</div>

<script type="text/javascript">
    var AuthObj = {
        formatterHandle:function (value, row, index) {
            var html = "-"
            {{if checkResIDAuth "2" "0105040100"}}
                html = '<span class="h-td-btn btn-primary btn-xs" onclick="AuthObj.auth(\'' + row.user_id + '\')"> 授权</span>';
            {{end}}
            {{if checkResIDAuth "2" "0105040200"}}
                html += '&nbsp;&nbsp;<span class="h-td-btn btn-danger btn-xs" onclick="AuthObj.revoke(\'' + row.user_id + '\')"> 撤权</span>';
            {{end}}
            return html;
        },
        batchAuth:function () {
            var userList = $("#h-grant-info-table-details").bootstrapTable('getSelections');
            if (userList.length == 0){
                $.Notify({
                    message:"请在下表中选择需要授权的用户",
                    type:"info",
                });
                return;
            }
            $.getJSON("/v1/auth/role/get", function (data) {
                $.Hmodal({
                    header: "授权管理",
                    body: $("#h-other-user-role-table-details-html").html(),
                    submitDesc: "授予角色",
                    cancelDesc: "关闭",
                    preprocess: function () {
                        var $table = $("#h-other-user-role-table-details");
                        $table.bootstrapTable({
                            paginationLoop: false,
                            striped: true,
                        });
                        $table.bootstrapTable('load', data)
                    },
                    callback: function (hmode) {
                        var $table = $("#h-other-user-role-table-details");
                        var sect = $table.bootstrapTable('getSelections');
                        var arr = new Array();
                        $(userList).each(function (index1, user) {
                            $(sect).each(function (index2, role) {
                                var e = {};
                                e.user_id = user.user_id;
                                e.role_id = role.role_id;
                                arr.push(e);
                            });
                        });

                        $.HAjaxRequest({
                            url: "/v1/auth/user/roles/auth",
                            type: "post",
                            data: {JSON: JSON.stringify(arr)},
                            success: function () {
                                $.Notify({
                                    title: "操作成功",
                                    message: "授权用户角色信息成功",
                                    type: "success",
                                });
                                $(hmode).remove();
                            },
                        })
                    }
                })
            });
        },
        batchRemove:function () {
            var userList = $("#h-grant-info-table-details").bootstrapTable('getSelections');
            if (userList.length == 0){
                $.Notify({
                    message:"请在下表中选择需要授权的用户",
                    type:"info",
                });
                return;
            }

            var domain_id = $("#h-auth-domain-list").val();
            $.getJSON("/v1/auth/role/get", {domain_id: domain_id}, function (data) {
                $.Hmodal({
                    header: "撤销角色",
                    body: $("#h-other-user-role-table-details-html").html(),
                    submitDesc: "撤销角色",
                    cancelDesc: "关闭",
                    preprocess: function () {
                        var $table = $("#h-other-user-role-table-details");
                        $table.bootstrapTable({
                            paginationLoop: false,
                            striped: true,
                        });
                        $table.bootstrapTable('load', data)
                    },
                    callback: function (hmode) {
                        var $table = $("#h-other-user-role-table-details");
                        var sect = $table.bootstrapTable('getSelections');
                        var arr = new Array();
                        $(userList).each(function (index1, user) {
                            $(sect).each(function (index2, role) {
                                var e = {};
                                e.user_id = user.user_id;
                                e.role_id = role.role_id;
                                arr.push(e);
                            });
                        });

                        $.HAjaxRequest({
                            url: "/v1/auth/user/roles/revoke",
                            type: "post",
                            data: {JSON: JSON.stringify(arr)},
                            success: function () {
                                $.Notify({
                                    title: "操作成功",
                                    message: "授权用户角色信息成功",
                                    type: "success",
                                });
                                $(hmode).remove();
                            },
                        })
                    }
                })
            });
        },
        search:function(){
            $.notifyClose();
            var org_id = $("#h-auth-org-list").val();
            var did = $("#h-auth-domain-list").val();
            $.HAjaxRequest({
                url:"/v1/auth/user/search",
                type:"get",
                data:{org_id:org_id,domain_id:did},
                success:function (data) {
                    $.Notify({
                        title:"查询成功",
                        message:"查询机构下用户信息成功",
                        type:"success",
                    });
                    $("#h-grant-info-table-details").bootstrapTable('load',data)
                },
            })
        },
        auth:function (user_id) {
            $.getJSON("/v1/auth/user/roles/other",{user_id:user_id},function (data) {
                $.Hmodal({
                    header:"授权管理",
                    body:$("#h-other-user-role-table-details-html").html(),
                    submitDesc:"授权",
                    cancelDesc:"关闭",
                    preprocess:function () {
                        var $table =  $("#h-other-user-role-table-details");
                        $table.bootstrapTable({
                            paginationLoop:false,
                            striped:true,
                        });
                        $table.bootstrapTable('load',data)
                    },
                    callback:function (hmode) {
                        var $table =  $("#h-other-user-role-table-details");
                        var sect = $table.bootstrapTable('getSelections');
                        var arr = new Array();
                        $(sect).each(function (index,element) {
                            element.user_id = user_id
                            arr.push(element)
                        });
                        $.HAjaxRequest({
                            url:"/v1/auth/user/roles/auth",
                            type:"post",
                            data:{JSON:JSON.stringify(arr)},
                            success:function () {
                                $.Notify({
                                    title:"操作成功",
                                    message:"授权用户角色信息成功",
                                    type:"success",
                                })
                                $(hmode).remove();
                            },
                        })
                    }
                })
            });
        },
        formatter:function (value,row,index) {
            var user_id = row.user_id;
            var role_id = row.role_id;
            return '<button onclick="AuthObj.revoke(\''+user_id+'\',\''+role_id+'\')" class="btn btn-danger btn-xs">删除</button>'
        },
        revoke: function (user_id) {
            $.getJSON("/v1/auth/user/roles/get", {user_id: user_id}, function (data) {
                $.Hmodal({
                    header: "撤销角色",
                    body: $("#h-other-user-role-table-details-html").html(),
                    submitDesc: "撤销角色",
                    cancelDesc: "关闭",
                    preprocess: function () {
                        var $table = $("#h-other-user-role-table-details");
                        $table.bootstrapTable({
                            paginationLoop: false,
                            striped: true,
                        });
                        $table.bootstrapTable('load', data)
                    },
                    callback: function (hmode) {
                        var $table = $("#h-other-user-role-table-details");
                        var sect = $table.bootstrapTable('getSelections');
                        var arr = new Array();
                        $(sect).each(function (index, element) {
                            var e = {};
                            e.role_id = element.role_id;
                            e.user_id = user_id;
                            arr.push(e);
                        });

                        $.HAjaxRequest({
                            url: "/v1/auth/user/roles/revoke",
                            type: "post",
                            data: {JSON: JSON.stringify(arr)},
                            success: function () {
                                $.Notify({
                                    title: "操作成功",
                                    message: "授权用户角色信息成功",
                                    type: "success",
                                })
                                $(hmode).remove();
                            },
                        })
                    }
                })
            });
        },
    };

    $(document).ready(function(){
        $.getJSON("/v1/auth/org/get",function(data){
            var arr = new Array()
            $(data).each(function(index,element){
                var ijs = {};
                ijs.id=element.org_id;
                ijs.text=element.org_desc;
                ijs.upId=element.up_org_id;
                arr.push(ijs);
            });

            $("#h-auth-org-list").Hselect({
                data:arr,
                height:"24px",
                width:"360px",
                onclick:function () {
                    AuthObj.search()
                },
            });
        });
        $("#h-grant-info-table-details").bootstrapTable();
    });
</script>
<script type="text/html" id="h-other-user-role-table-details-html">
    <table id="h-other-user-role-table-details"
           data-toggle="table"
           data-side-pagination="client"
           data-pagination="false"
           data-page-list="[20, 50, 100, 200]"
           data-click-to-select="true"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true">序号</th>
            <th data-field="role_id" data-sortable="true">角色编码</th>
            <th data-field="role_name">角色名称</th>
        </tr>
        </thead>
    </table>
</script>
