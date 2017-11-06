<div class="row subsystem-header">
    <span style="font-size: 14px;">权限代码管理</span>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0103060100"}}
        <button onclick="SysPrivilegeObj.add()" class="btn btn btn-info btn-sm">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0103060200"}}
        <button onclick="SysPrivilegeObj.edit()" class="btn btn btn-info btn-sm">
            <i class="icon-edit"> 编辑</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0103060300"}}
        <button  onclick="SysPrivilegeObj.delete()" class="btn btn btn-danger btn-sm">
            <i class="icon-trash"> 删除</i>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content">
    <table id="h-sys-privilege-table-content" ></table>
</div>

<script type="text/javascript">
    var SysPrivilegeObj = {
        get:function(){
            $("#h-sys-privilege-table-content").bootstrapTable({
                url:'/v1/auth/privilege',
                uniqueId:'privilegeId',
                striped: true,
                pagination: true,
                pageList:[20,30,40,80,160,400,800,3000,"All"],
                showRefresh:false,
                pageSize: 30,
                showExport:false,
                clickToSelect:true,
                search:false,
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

                    field: 'modifyUser',

                    title: '修改人',

                    align: 'center',

                    valign: 'middle',

                    sortable: true

                }, {

                    field: 'modifyTime',

                    title: '修改时间',

                    align: 'center',

                    valign: 'middle',

                    sortable: true,
                }, {

                    align: 'center',

                    title: '关联',

                    formatter : SysPrivilegeObj.formatter
                }]
            });
        },
        getPrivilegeRole:function (id, name) {
            var name = name;
            Hutils.openTab({
                url:"/v1/auth/privilege/role/page?privilegeId="+id,
                id:"privilegeRole999988899",
                title:name,
                error:function (m) {
                    $.Notify({
                        message:"权限不足",
                        type:"danger",
                    });
                }
            })
        },
        getPrivilegeDomain:function (id,name) {
            var name = name;
            Hutils.openTab({
                url:"/v1/auth/privilege/domain/page?privilegeId="+id,
                id:"privilegeDomain999988899",
                title:name,
                error:function (m) {
                    $.Notify({
                        message:"权限不足",
                        type:"danger",
                    })
                }
            })
        },
        formatter:function(value,rows,index){
            var html = "";
            {{if checkResIDAuth "2" "0103060500"}}
               html += '<span class="h-td-btn btn-primary btn-xs" onclick="SysPrivilegeObj.getPrivilegeDomain(\''+rows.privilegeId+'\',\''+ rows.privilegeDesc+'\')">关联域</span>'
            {{end}}
            {{if checkResIDAuth "2" "0103060600"}}
            html += '&nbsp;&nbsp;<span class="h-td-btn btn-success btn-xs" onclick="SysPrivilegeObj.getPrivilegeRole(\''+rows.privilegeId+'\',\''+ rows.privilegeDesc+'\')">关联角色</span>';
            {{end}}
            return html;
        },
        add:function(e){
            var submitMenu = function(hmode){
                $.HAjaxRequest({
                    type:"Post",
                    url:"/v1/auth/privilege",
                    data:$("#h-sysprivilege-add-tpl").serialize(),
                    success: function(){
                        $.Notify({
                            message:"创建权限代码成功",
                            type:"success",
                        });
                        $(hmode).remove();
                        $("#h-sys-privilege-table-content").bootstrapTable('refresh');
                    }
                });
            };

            $.Hmodal({
                callback:submitMenu,
                header:"新增权限代码",
                body:$("#h-sys-privilege-input-src").html(),
                width:"420px",
            })
        },

        delete:function(){
            var rst = $("#h-sys-privilege-table-content").bootstrapTable("getAllSelections")
            if (rst.length > 0){
                $.Hconfirm({
                    callback:function () {
                        $.HAjaxRequest({
                            type:'delete',
                            url:"/v1/auth/privilege",
                            data:{JSON:JSON.stringify(rst)},
                            success: function(data){
                                $.Notify({
                                    message:"删除域信息成功",
                                    type:"success",
                                });
                                $(rst).each(function(index,element){
                                    $("#h-sys-privilege-table-content").bootstrapTable('removeByUniqueId', element.privilegeId);
                                })
                            }
                        });
                    },
                    body:"确定删除这个域，删除后将无法恢复",
                });
            }else{
                $.Notify({
                    title:"温馨提示",
                    message:"您没有勾选任何需要删除的域",
                    type:"info",
                });
            }
        },
        edit:function(){
            var rst = $("#h-sys-privilege-table-content").bootstrapTable('getSelections');
            if (rst.length == 0){
                $.Notify({
                    message:"请在下方表格中选中需要修改的行",
                    type:"info",
                });
                return
            }else if (rst.length > 1){
                $.Notify({
                    message:"您选中了多行，不知道您具体需要编辑哪一行",
                    type:"warning",
                });
                return
            }else if (rst.length == 1){
                var tr = rst[0];
                var editMenu = function(hmode){

                    $.HAjaxRequest({
                        type:"Put",
                        url:"/v1/auth/privilege",
                        cache:false,
                        data:{
                            privilegeId : $("#h-sysprivilege-add-tpl").find("input[name='privilegeId']").val(),
                            privilegeDesc : $("#h-sysprivilege-add-tpl").find("input[name='privilegeDesc']").val(),
                        },
                        async:false,
                        dataType:"text",
                        success: function(){
                            $.Notify({
                                title:"温馨提示:",
                                message:"更新域信息成功",
                                type:"success",
                            });

                            $(hmode).remove();
                            $("#h-sys-privilege-table-content").bootstrapTable('refresh');
                        }
                    });
                };

                var preHand = function(){
                    $("#h-sysprivilege-add-tpl").find("input[name='privilegeId']").val(tr.privilegeId).attr("readonly","readonly");
                    $("#h-sysprivilege-add-tpl").find("input[name='privilegeDesc']").val(tr.privilegeDesc);
                };
                $.Hmodal({
                    callback:editMenu,
                    preprocess:preHand,
                    header:"修改域信息",
                    body:$("#h-sys-privilege-input-src").html(),
                    width:"420px",
                })
            }
        },
    };
    $(document).ready(function(){
        SysPrivilegeObj.get();
    });
</script>
<script id="h-sys-privilege-input-src" type="text/html">
    <form class="row" id="h-sysprivilege-add-tpl">
        <div class="col-sm-12">
            <label class="h-label" style="width:100%;">权限代码：</label>
            <input placeholder="1至30个字母，数字组成" name="privilegeId" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <label class="h-label" style="width: 100%;">权限名称：</label>
            <input placeholder="1至30个汉字、字母、数字组成" type="text" class="form-control" name="privilegeDesc" style="width: 100%;height: 30px;line-height: 30px;">
        </div>
    </form>
</script>