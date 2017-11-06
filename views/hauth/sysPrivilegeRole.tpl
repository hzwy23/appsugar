<div class="row subsystem-header">
    <span style="font-size: 14px;">权限代码与角色关联关系</span>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0103060620"}}
        <button onclick="SysPrivilegeRoleObj.add()" class="btn btn btn-info btn-sm">
            <i class="icon-plus"> 添加关联</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0103060630"}}
        <button  onclick="SysPrivilegeRoleObj.delete()" class="btn btn btn-danger btn-sm">
            <i class="icon-trash"> 取消关联</i>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content">
    <table id="h-sys-privilege-domain-table-content"></table>
</div>

<script type="text/javascript">
    var SysPrivilegeRoleObj = {
        get:function(){
            $("#h-sys-privilege-domain-table-content").bootstrapTable({
                url:'/v1/auth/privilege/role',
                uniqueId:'privilegeId',
                striped: true,
                pagination: true,
                pageList:[20,30,40,80,160,400,800,3000,"All"],
                showRefresh:false,
                pageSize: 30,
                showExport:false,
                clickToSelect:true,
                search:false,
                queryParams:function (params) {
                    params.privilegeId = SysPrivilegeRoleObj.privilegeId;
                    return params;
                },
                sidePagination: "client",
                showColumns: false,
                columns:[{
                    checkbox:true,
                }, {

                    field: 'privilegeId',

                    title: '权限代码',

                    align: 'left',

                    valign: 'middle',

                    sortable: true

                }, {

                    field: 'privilegeDesc',

                    title: '权限名称',

                    align: 'left',

                    valign: 'middle',

                    sortable: true,

                }, {

                    field: 'roleId',

                    title: '角色编码',

                    align: 'center',

                    valign: 'middle',

                    sortable: true

                }, {

                    field: 'roleName',

                    title: '角色名称',

                    align: 'center',

                    valign: 'middle',

                    sortable: true,
                },{

                    field: 'createUser',

                    title: '创建人',

                    align: 'center',

                    valign: 'top',

                    sortable: true

                }, {

                    field: 'createTime',

                    title: '创建时间',

                    align: 'center',

                    valign: 'middle',

                    sortable: true

                }, {

                    align: 'center',

                    title: '关联',

                    formatter : SysPrivilegeRoleObj.formatter
                }]
            });
        },
        deleteRow:function (uuid) {
            var args = new Array();
            var e = {};
            e.uuid = uuid;
            args.push(e);

            $.HAjaxRequest({
                url:"/v1/auth/privilege/role",
                type:"delete",
                success:function () {
                    $("#h-sys-privilege-domain-table-content").bootstrapTable('refresh');
                },
                data:{JSON:JSON.stringify(args)}
            })
        },
        formatterMode:function(value,rows,index){
            if (value == "1") {
                return "只读";
            } else if (value == "2") {
                return "读写";
            } else {
                return "权限不足";
            }
        },
        formatter:function(value,rows,index){
            var html = "-";
            {{if checkResIDAuth "2" "0103060630"}}
                html = '<span class="h-td-btn btn-danger btn-xs" onclick="SysPrivilegeRoleObj.deleteRow(\''+rows.uuid+'\')">取消关联</span>';
            {{end}}
            return html;
        },
        add:function(e){
            $.Hmodal({
                callback:function (hmode) {
                    var rows = $("#h-other-privilege-role-table-details").bootstrapTable('getSelections');
                    var args = new Array();
                    $(rows).each(function (index, element) {
                        var e = {};
                        e.privilegeId = SysPrivilegeRoleObj.privilegeId;
                        e.roleId = element.role_id;
                        args.push(e);
                    });

                    $.HAjaxRequest({
                        url:"/v1/auth/privilege/role",
                        type:"post",
                        success:function () {
                            $.Notify({
                                message:"添加角色关联信息成功",
                                type:"success",
                            });
                            $("#h-sys-privilege-domain-table-content").bootstrapTable('refresh');
                            $(hmode).remove();
                        },
                        data:{JSON:JSON.stringify(args)},
                    });
                },
                preprocess:function () {
                    $("#h-other-privilege-role-table-details").bootstrapTable({
                        url:"/v1/auth/privilege/role",
                        queryParams:function (params) {
                            params.typeCd = "unmap";
                            params.privilegeId = SysPrivilegeRoleObj.privilegeId;
                            return params;
                        }
                    })
                },
                header:"新增权限代码与角色关联关系",
                body:$("#h-sys-privilege-role-input-src").html(),
            })
        },

        delete:function(){
            var rst = $("#h-sys-privilege-domain-table-content").bootstrapTable('getAllSelections');

            if (rst.length > 0){
                $.Hconfirm({
                    callback:function () {
                        $.HAjaxRequest({
                            url:"/v1/auth/privilege/role",
                            type:"delete",
                            success:function () {
                                $.Notify({
                                    message:"删除角色关联信息成功",
                                    type:"success",
                                });
                                $("#h-sys-privilege-domain-table-content").bootstrapTable('refresh');
                            },
                            data:{JSON:JSON.stringify(rst)},
                        });
                    },
                    body:"点击确定删除权限代码与角色之间的关联关系",
                });
            } else {
                $.Notify({
                    message:"您没有勾选任何需要删除的关联关系",
                    type:"warning",
                });
            }
        },
        privilegeId:{{.}},
    };

    $(document).ready(function(){
        SysPrivilegeRoleObj.get();
    });
</script>
<script id="h-sys-privilege-role-input-src" type="text/html">
    <table id="h-other-privilege-role-table-details"
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
            <th data-field="role_desc">角色名称</th>
        </tr>
        </thead>
    </table>
</script>