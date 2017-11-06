<div class="row subsystem-header">
    <span style="font-size: 14px;">权限代码与域关联关系</span>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0103060710"}}
        <button onclick="SysPrivilegeDomainObj.add()" class="btn btn btn-info btn-sm">
            <i class="icon-plus"> 添加关联</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0103060720"}}
        <button onclick="SysPrivilegeDomainObj.edit()" class="btn btn btn-info btn-sm">
            <i class="icon-edit"> 编辑权限</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0103060730"}}
        <button  onclick="SysPrivilegeDomainObj.delete()" class="btn btn btn-danger btn-sm">
            <i class="icon-trash"> 取消关联</i>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content">
    <table id="h-sys-privilege-domain-table-content" ></table>
</div>

<script type="text/javascript">
    var SysPrivilegeDomainObj = {
        get:function(){
            $("#h-sys-privilege-domain-table-content").bootstrapTable({
                url:'/v1/auth/privilege/domain',
                uniqueId:'uuid',
                striped: true,
                pagination: true,
                pageList:[20,30,40,80,160,400,800,3000,"All"],
                showRefresh:false,
                pageSize: 30,
                showExport:false,
                clickToSelect:true,
                search:false,
                queryParams:function (params) {
                    params.privilegeId = SysPrivilegeDomainObj.privilegeId;
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

                    field: 'domainId',

                    title: '域编码',

                    align: 'center',

                    valign: 'middle',

                    sortable: true

                }, {

                    field: 'domainName',

                    title: '域名称',

                    align: 'center',

                    valign: 'middle',

                    sortable: true,
                },{

                    field: 'permission',

                    title: '权限模式',

                    align: 'left',

                    valign: 'middle',

                    sortable: true,

                    formatter: SysPrivilegeDomainObj.formatterMode

                }, {

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

                    valign: 'top',

                    sortable: true

                }, {

                    field: 'modifyTime',

                    title: '修改时间',

                    align: 'center',

                    valign: 'middle',

                    sortable: true

                },{

                    align: 'center',

                    title: '关联',

                    formatter : SysPrivilegeDomainObj.formatter
                }]
            });
        },
        deleteRow:function (id) {
            var rst = new Array();
            var e = {};
            e.uuid = id;
            rst.push(e);

            $.Hconfirm({
                callback:function () {
                    $.HAjaxRequest({
                        type:'delete',
                        url:"/v1/auth/privilege/domain",
                        data:{JSON:JSON.stringify(rst)},
                        success: function(){
                            $.Notify({
                                message:"删除域信息成功",
                                type:"success",
                            });
                            $(rst).each(function(index,element){
                                $("#h-sys-privilege-domain-table-content").bootstrapTable('removeByUniqueId', element.uuid);
                            })
                        }
                    });
                },
                body:"点击确定删除权限代码与域关联关系",
            });
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
            {{if checkResIDAuth "2" "0103060730"}}
                html = '<span class="h-td-btn btn-danger btn-xs" onclick="SysPrivilegeDomainObj.deleteRow(\''+rows.uuid+'\')">取消关联</span>';
            {{end}}
            return html;
        },
        add:function(e){
            var submitMenu = function(hmode){
                var rows = new Array();
                var list = $("#h-sysprivilege-domain-add-tpl").find("select[name='domainId']").next().find("ul");
                $(list).find("li").each(function (index, element) {
                    if ($(element).find("input").is(":checked")) {
                        var e = {};
                        e.privilegeId = SysPrivilegeDomainObj.privilegeId;
                        e.domainId = $(element).attr("data-id");
                        e.permission = $("#h-sysprivilege-domain-add-tpl").find("select[name='permission']").val();
                        rows.push(e);
                    }
                });

                $.HAjaxRequest({
                    type:"Post",
                    url:"/v1/auth/privilege/domain",
                    data:{JSON:JSON.stringify(rows)},
                    success: function(){
                        $.Notify({
                            message:"创建权限代码成功",
                            type:"success",
                        });
                        $(hmode).remove();
                        $("#h-sys-privilege-domain-table-content").bootstrapTable('refresh');
                    }
                });
            };

            $.Hmodal({
                callback:submitMenu,
                header:"新增权限域与关联关系",
                body:$("#h-sys-privilege-domain-input-src").html(),
                width:"420px",
                preprocess:function () {
                    $("#h-sysprivilege-domain-add-tpl").find("select[name='permission']").Hselect({
                        height:"30px",
                        value:"1",
                    });

                    $.getJSON("/v1/auth/privilege/domain",{
                        privilegeId:SysPrivilegeDomainObj.privilegeId,
                        typeCd:"unmap",
                    },function (data) {
                        var rows = new Array();
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.domainId;
                            e.text = element.domainDesc;
                            e.upId = "##hzwy23##";
                            rows.push(e);
                        });

                        $("#h-sysprivilege-domain-add-tpl").find("select[name='domainId']").Hselect({
                            height:"30px",
                            data:rows,
                            checkbox:true,
                        });
                    });
                },
            })
        },

        delete:function(){
            var rst = $("#h-sys-privilege-domain-table-content").bootstrapTable("getAllSelections")
            if (rst.length > 0){
                $.Hconfirm({
                    callback:function () {
                        $.HAjaxRequest({
                            type:'delete',
                            url:"/v1/auth/privilege/domain",
                            data:{JSON:JSON.stringify(rst)},
                            success: function(){
                                $.Notify({
                                    message:"删除域信息成功",
                                    type:"success",
                                });
                                $(rst).each(function(index,element){
                                    $("#h-sys-privilege-domain-table-content").bootstrapTable('removeByUniqueId', element.uuid);
                                })
                            }
                        });
                    },
                    body:"点击确定删除权限代码与域关联关系",
                });
            }else{
                $.Notify({
                    message:"请选择需要删除的权限与域关联关系",
                    type:"info",
                });
            }
        },
        edit:function(){
            var rst = $("#h-sys-privilege-domain-table-content").bootstrapTable('getSelections');
            if (rst.length == 0){
                $.Notify({
                    message:"请在下边列表中选择需要修改的项",
                    type:"info",
                });
                return;
            }else if (rst.length > 1){
                $.Notify({
                    message:"请选择<span style='font-weight: 600; color: red;'>一项</span>进行操作",
                    type:"warning",
                });
                return;
            }else if (rst.length == 1){
                var tr = rst[0];

                var editMenu = function(hmode){
                    $.HAjaxRequest({
                        type:"Put",
                        url:"/v1/auth/privilege/domain",
                        cache:false,
                        data:{
                            uuid : $("#h-sysprivilege-domain-add-tpl").find("input[name='uuid']").val(),
                            privilegeId : $("#h-sysprivilege-domain-add-tpl").find("input[name='privilegeId']").val(),
                            domainId : $("#h-sysprivilege-domain-add-tpl").find("select[name='domainId']").val(),
                            permission : $("#h-sysprivilege-domain-add-tpl").find("select[name='permission']").val(),
                        },
                        async:false,
                        dataType:"text",
                        success: function(){
                            $.Notify({
                                message:"更新权限代码与域关联关系",
                                type:"success",
                            });
                            $(hmode).remove();
                            $("#h-sys-privilege-domain-table-content").bootstrapTable('refresh');
                        }
                    });
                };

                var preHand = function(){

                    $("#h-sysprivilege-domain-add-tpl").find("input[name='privilegeId']").val(tr.privilegeId);
                    $("#h-sysprivilege-domain-add-tpl").find("input[name='uuid']").val(tr.uuid);
                    $("#h-sysprivilege-domain-add-tpl").find("select[name='domainId']").Hselect({
                        height:"30px",
                        data:[{id:tr.domainId,text:tr.domainName,upId:"##hzwy23##"}],
                        value:tr.domainId,
                        disabled:true,
                    });

                    $("#h-sysprivilege-domain-add-tpl").find("select[name='permission']").Hselect({
                        height:"30px",
                        value:tr.permission,
                    });
                };
                $.Hmodal({
                    callback:editMenu,
                    preprocess:preHand,
                    header:"修改权限代码与域关联关系",
                    body:$("#h-sys-privilege-domain-input-src").html(),
                    width:"420px",
                })
            }
        },
        privilegeId:{{.}},
    };
    $(document).ready(function(){
        SysPrivilegeDomainObj.get();
    });
</script>
<script id="h-sys-privilege-domain-input-src" type="text/html">
    <form class="row" id="h-sysprivilege-domain-add-tpl">
        <div class="col-sm-12" style="display: none;">
            <label class="h-label" style="width:100%;">权限代码：</label>
            <input name="privilegeId" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
            <input name="uuid" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <label class="h-label" style="width: 100%;">关联域：</label>
            <select type="text" class="form-control" name="domainId" style="width: 100%;height: 30px;line-height: 30px;">
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <label class="h-label" style="width: 100%;">关联域：</label>
            <select type="text" class="form-control" name="permission" style="width: 100%;height: 30px;line-height: 30px;">
                <option value="1">只读</option>
                <option value="2">读写</option>
            </select>
        </div>
    </form>
</script>