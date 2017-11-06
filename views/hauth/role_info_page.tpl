<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">角色管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0105020200"}}
        <button onclick="RoleObj.add()" class="btn btn btn-info btn-sm">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0105020300"}}
        <button onclick="RoleObj.edit()" class="btn btn btn-info btn-sm">
            <i class="icon-edit"> 编辑</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0105020400"}}
        <button onclick="RoleObj.delete()" class="btn btn btn-danger btn-sm">
            <i class="icon-trash"> 删除</i>
        </button>
        {{end}}
    </div>
</div>
<div id="h-role-info" class="subsystem-content">
    <table id="h-role-info-table-details"
           data-toggle="table"
           data-striped="true"
           data-side-pagination="client"
           data-click-to-select="true"
           data-pagination="true"
           data-page-size="30"
           data-page-list="[20,30, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-field="role_id">角色编码</th>
            <th data-field="role_name">角色名称</th>
            <th data-align="center"
                data-field="role_status_desc">状态</th>
            <!--<th data-align="center"-->
                <!--data-field="create_user">创建人</th>-->
            <!--<th data-align="center"-->
                <!--data-field="create_date">创建时间</th>-->
            <th data-align="center"
                data-field="modify_user">修改人</th>
            <th data-align="center"
                data-field="modify_date">修改时间</th>
            <th data-field="state-handle"
                data-align="center"
                data-formatter="RoleObj.formatter">资源操作</th>
        </tr>
        </thead>
    </table>
</div>

<script>
    var RoleObj={
        getUserRelationPage:function (id, name) {
            var name = name+"关联用户信息";
            Hutils.openTab({
                url:"/v1/auth/role/user/page?role_id="+id,
                id:"resourcedetails999988899",
                title:name,
                error:function (m) {
                    $.Notify({
                        title:"温馨提示：",
                        message:"权限不足",
                        type:"danger",
                    })
                }
            })
        },
        getResourcePage:function(id,name){
            var name = name+"资源信息";
            Hutils.openTab({
                url:"/v1/auth/role/resource/details?role_id="+id,
                id:"resourcedetails999988899",
                title:name,
                error:function (m) {
                    $.Notify({
                        title:"温馨提示：",
                        message:"权限不足",
                        type:"danger",
                    })
                }
            })
        },
        formatter:function(value,rows,index){
            var html = "-";
            {{if checkResIDAuth "2" "0105020500"}}
                html = '<span class="h-td-btn btn-primary btn-xs" onclick="RoleObj.getResourcePage(\''+rows.role_id+'\',\''+ rows.role_name+'\')">功能权限</span>';
            {{end}}
            {{if checkResIDAuth "2" "0105020600"}}
                html += '&nbsp;&nbsp;<span class="h-td-btn btn-success btn-xs" onclick="RoleObj.getUserRelationPage(\''+rows.role_id+'\',\''+ rows.role_name+'\')">关联用户</span>';
            {{end}}
            return html;
        },
        add:function () {
            $.Hmodal({
                header:"新增角色",
                body:$("#role_input_form").html(),
                width:"420px",
                preprocess:function () {
                    $("#h-role-add-status").Hselect({
                        height:"30px",
                        value:"0",
                    });
                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/auth/role/post",
                        type:"post",
                        data:$("#h-role-add-info").serialize(),
                        success:function () {
                            $.Notify({
                                title:"操作成功",
                                message:"新增角色信息成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            $("#h-role-info-table-details").bootstrapTable('refresh');
                        },
                    })
                }
            })
        },
        edit:function () {

            var rows = $("#h-role-info-table-details").bootstrapTable('getSelections');
            if (rows.length==0){
                $.Notify({
                    title:"温馨提示",
                    message:"您没有选择需要编辑的角色信息",
                    type:"info",
                });
            }else if (rows.length==1){

                var role_id = rows[0].role_id;
                var role_name = rows[0].role_name;
                var status_id = rows[0].role_status_code;

                $.Hmodal({
                    header:"编辑角色信息",
                    body:$("#role_modify_form").html(),
                    width:"420px",
                    preprocess:function () {
                        $("#h-role-modify-role-code-number").val(role_id);
                        $("#h-role-modify-role-name").val(role_name);
                        $("#h-role-modify-role-status-cd").Hselect({
                            height:"30px",
                            value:status_id,
                        });
                    },
                    callback:function (hmode) {
                        $.HAjaxRequest({
                            url:"/v1/auth/role/update",
                            type:"put",
                            data:$("#h-role-modify-info").serialize(),
                            success:function () {
                                $.Notify({
                                    title:"操作成功",
                                    message:"编辑角色信息成功",
                                    type:"success",
                                });
                                $(hmode).remove();
                                $("#h-role-info-table-details").bootstrapTable('refresh')
                            },
                        })
                    },
                })

            }else {
                $.Notify({
                    title:"温馨提示",
                    message:"您选择了多行角色信息，不知道确定要编辑哪一行",
                    type:"info",
                });
            }
        },
        delete:function () {
           var rows = $("#h-role-info-table-details").bootstrapTable('getSelections');
           if (rows.length==0){
               $.Notify({
                   title:"温馨提示",
                   message:"您没有选择需要删除的角色信息",
                   type:"info",
               });
               return;
           }else{
               $.Hconfirm({
                   callback:function () {
                       $.HAjaxRequest({
                           url:"/v1/auth/role/delete",
                           type:"post",
                           data:{JSON:JSON.stringify(rows)},
                           success:function () {
                               $.Notify({
                                   title:"操作成功",
                                   message:"删除角色信息成功",
                                   type:"success",
                               });
                               $("#h-role-info-table-details").bootstrapTable('refresh')
                           },
                       })
                   },
                   body:"确认要删除选中的角色吗"
               })
           }
        },
    };

    $(document).ready(function(obj){
        // 初始化右上角域选择框
        $("#h-role-info-table-details").bootstrapTable({
            url:"/v1/auth/role/get",
        });
    });
</script>

<script type="text/html" id="role_input_form">
    <form class="row" id="h-role-add-info">
        <div class="col-sm-12">
            <label class="h-label" style="width:100%;">角色编码：</label>
            <input placeholder="1..30位数字，字母组成" name="role_id" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="h-label" style="width: 100%;">角色名称：</label>
            <input placeholder="1..30位汉字，字母，数字组成" type="text" class="form-control" name="role_name" style="width: 100%;height: 30px;line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="h-label" style="width: 100%;">状　态：</label>
            <select id="h-role-add-status" name="role_status_code"  class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
                <option value="0">正常</option>
                <option value="1">失效</option>
            </select>
        </div>
    </form>
</script>

<script type="text/html" id="role_modify_form">
    <form class="row" id="h-role-modify-info">
        <div class="col-sm-12">
            <label class="h-label" style="width:100%;">角色编码：</label>
            <input id="h-role-modify-role-code-number" readonly="readonly" name="role_id" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="h-label" style="width: 100%;">角色名称：</label>
            <input id="h-role-modify-role-name" placeholder="" type="text" class="form-control" name="role_name" style="width: 100%;height: 30px;line-height: 30px;">

        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="h-label" style="width: 100%;">状　态：</label>
            <select id="h-role-modify-role-status-cd" name="role_status_code"  class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
                <option value="0">正常</option>
                <option value="1">失效</option>
            </select>
        </div>
    </form>
</script>