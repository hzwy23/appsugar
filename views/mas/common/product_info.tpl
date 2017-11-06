<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">产品配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-common-product_domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        <button onclick="CommonProductObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        <button onclick="CommonProductObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-edit"> 导入</span>
        </button>
        <button onclick="CommonProductObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 导出</span>
        </button>
        <button onclick="CommonProductObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        <button onclick="CommonProductObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
    <div class="row">
        <div class="col-sm-12 col-md-5 col-md-5">
            <div id="h-common-product-tree-info" class="thumbnail">
                <div class="col-ms-12 col-md-12 col-lg-12">
                    <div style="border-bottom: #598f56 solid 1px;height: 44px; line-height: 44px;">
                        <div class="pull-left">
                            <span><i class="icon-sitemap"> </i>产品树形结构</span>
                        </div>
                        <div class="pull-right">
                    <span>
                        <i class=" icon-search" style="margin-top: 15px;"></i>&nbsp;
                    </span>
                        </div>
                    </div>
                </div>
                <div id="h-common-product-tree-info-list" class="col-sm-12 col-md-12 col-lg-12"
                     style="padding:15px 5px;overflow: auto">
                </div>
            </div>
        </div>
        <div id="h-common-product-table-info" class="col-sm-12 col-md-7 col-lg-7" style="padding-left: 0px;">
            <table id="h-common-product-table-id"
                   data-toggle="table"
                   data-unique-id="product_id"
                   data-side-pagination="client"
                   data-pagination="true"
                   data-click-to-select="true"
                   data-page-size="30"
                   data-page-list="[10,20,30, 50, 100, 200]"
                   data-search="false">
                <thead>
                <tr>
                    <th data-field="state" data-checkbox="true"></th>
                    <th data-sortable="true" data-field="code_number">产品编码</th>
                    <th data-sortable="true" data-field="product_desc">产品名称</th>
                    <th data-sortable="true" data-field="product_up_id" data-formatter="CommonProductObj.AccountFormatter">上级产品编码</th>
                    <!--<th data-sortable="true" data-align="center" data-field="create_date">创建日期</th>-->
                    <!--<th data-sortable="true" data-align="center" data-field="create_user">创建人</th>-->
                    <th data-sortable="true" data-align="center" data-field="modify_date">修改日期</th>
                    <th data-sortable="true" data-align="center" data-field="modify_user">修改人</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">

    var CommonProductObj = {
        $table:$('#h-common-product-table-id'),
        download:function () {
            var domain_id = $("#h-common-product_domain-list").val();
            $.Hdownload({
                url:"/v1/common/product/download?domain_id="+domain_id,
                name:"产品配置信息",
            })
        },
        upload:function () {
            $.Hupload({
                header:"上传产品参数信息",
                url:"/v1/common/product/upload",
                callback:function () {
                    CommonProductObj.tree();
                    $("#h-common-product-tree-info-list").removeAttr("data-selected");
                },
            })
        },
        add:function(){
            $.Hmodal({
                body:$("#h-common-product-src").html(),
                width:"420px",
                header:"新增产品信息",
                callback:function(hmode){
                    $.HAjaxRequest({
                        url:"/v1/common/product/post",
                        type:"post",
                        data:$("#h-common-product-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"新增产品信息成功",
                                type:"success",
                            });
                            CommonProductObj.tree();
                            $(hmode).remove();
                            $("#h-common-product-tree-info-list").removeAttr("data-selected");
                        },
                    })
                },
                preprocess:function(){

                    var domain_id = $("#h-common-product_domain-list").val();
                    $("#h-common-product-form").find("input[name='domain_id']").val(domain_id);

                    $.getJSON("/v1/common/product/get",{domain_id:domain_id},function (data) {

                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.product_id;
                            e.text = element.product_desc;
                            e.upId = element.product_up_id;
                            arr.push(e)
                        });

                        var e = {};
                        e.id = "-1";
                        e.text = "系统默认根节点";
                        e.upId = "##hzwy23##";
                        arr.push(e)

                        $("#h-common-product-form").find("select[name='product_up_id']").Hselect({
                            height:"30px",
                            data:arr,
                        })
                    })
                }
            })
        },
        edit:function(){
            var row = CommonProductObj.$table.bootstrapTable("getSelections")
            if (row.length == 0){
                var selected_id = $("#h-common-product-tree-info-list").attr("data-selected")
                if (selected_id == undefined) {
                    $.Notify({
                        title:"温馨提示",
                        message:"请在列表中选择一项需要编辑的产品信息",
                        type:"warning",
                    });
                    return
                }
                row.push($("#h-common-product-table-id").bootstrapTable('getRowByUniqueId',selected_id))
            } else if (row.length > 1){
                $.Notify({
                    title:"温馨提示",
                    message:"只能对<span style='color: red; font-weight: 600;'>一项</span>进行编辑",
                    type:"warning",
                });
                return
            };

            var domain_id = row[0].domain_id;
            $.Hmodal({
                body:$("#h-common-product-src").html(),
                header:"编辑产品信息",
                width:"420px",
                preprocess:function () {

                    $("#h-common-product-form").find("select[name='gl_level']").Hselect({
                        height:"30px",
                        value:row[0].gl_level,
                    });

                    $("#h-common-product-form").find("input[name='domain_id']").val(row[0].domain_id);

                    $.getJSON("/v1/common/product/get",{domain_id:row[0].domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.product_id;
                            e.text = element.product_desc;
                            e.upId = element.product_up_id;
                            arr.push(e)
                        });

                        var e = {};
                        e.id = "-1";
                        e.text = "系统默认根节点";
                        e.upId = "##hzwy23##";
                        arr.push(e)

                        $("#h-common-product-form").find("select[name='product_up_id']").Hselect({
                            height:"30px",
                            data:arr,
                            value:row[0].product_up_id,
                        })
                    })

                    $("#h-common-product-form").find("input[name='product_id']").val(row[0].code_number).attr("readonly","readonly")
                    $("#h-common-product-form").find("input[name='product_desc']").val(row[0].product_desc)

                },
                callback:function(hmode){
                    $.HAjaxRequest({
                        url: "/v1/common/product/put",
                        type: "put",
                        data: $("#h-common-product-form").serialize(),
                        success:function (data) {
                            $.Notify({
                                title:"温馨提示：",
                                message:"修改产品信息成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            CommonProductObj.tree(domain_id);
                            $("#h-common-product-tree-info-list").removeAttr("data-selected");
                        },
                    })
                }
            })
        },
        getSubOrg:function(set,all){

            var addArray = new Array();

            var search = function(obj,arr){
                $(arr).each(function(index,element){
                    if (obj.org_id == element.up_org_id){
                        addArray.push(element)
                        var newArray = all.splice(index,1)
                        search(element,newArray)
                    }
                });
            };

            $(set).each(function(index,element){
                search(element,all)
            });

            return addArray
        },
        delete:function(){

            var rows = CommonProductObj.$table.bootstrapTable("getSelections");

            if (rows.length == 0){
                var selected_id = $("#h-common-product-tree-info-list").attr("data-selected");
                if (selected_id == undefined) {
                    $.Notify({
                        title:"温馨提示",
                        message:"请选择需要删除的产品信息",
                        type:"warning",
                    })
                    return
                }
                rows.push($("#h-common-product-table-id").bootstrapTable('getRowByUniqueId',selected_id))
            };

            $.Hconfirm({
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/common/product/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                title:"操作成功",
                                message:"删除产品信息成功",
                                type:"success",
                            });
                            CommonProductObj.tree();
                            $("#h-common-product-tree-info-list").removeAttr("data-selected")
                        },
                    })
                },
                body:"点击确认删除选中的产品信息<br/>这个产品下级产品也会一同删除"
            })

        },
        tree:function(domain_id){
            if (domain_id == undefined){
                domain_id = $("#h-common-product_domain-list").val()
            }
            $.getJSON("/v1/common/product/get",{domain_id:domain_id},function(data){
                if (data.length==0){
                    $.Notify({
                        title:"温馨提示",
                        message:"您选择的产品项",
                        type:"info",
                    });
                    CommonProductObj.$table.bootstrapTable('load',[]);
                    $("#h-common-product-tree-info-list").HtreeWithLine({
                        data:[],
                    });
                } else {
                    var arr = new Array();
                    $(data).each(function(index,element){
                        var ijs = {}
                        ijs.id = element.product_id;
                        ijs.text = element.product_desc;
                        ijs.upId = element.product_up_id;
                        arr.push(ijs)
                    });

                    $("#h-common-product-tree-info-list").HtreeWithLine({
                        data:arr,
                        onChange:function(obj){
                            var id = $(obj).attr("data-id")
                            var domain_id = $("#h-common-product_domain-list").val()
                            $.getJSON("/v1/common/product/sub/get",{domain_id:domain_id,product_id:id},function (data) {
                                CommonProductObj.$table.bootstrapTable('load',data)
                                $("#h-common-product-table-id tbody tr").each(function (index, element) {
                                    if ( $(element).attr("data-uniqueid") == id ) {
                                        $(element).addClass("info")
                                    }
                                })
                            })
                        }
                    });
                    CommonProductObj.$table.bootstrapTable('load',data)
                }
            })
        },
        AccountFormatter:function(value,row,index){
            var upcombine = value.split("_join_")
            if (upcombine.length==2){
                return upcombine[1]
            }else{
                return upcombine
            }
        },
    };

    $(document).ready(function(){
        var hwindow = document.documentElement.clientHeight;
        $("#h-common-product-tree-info").height(hwindow-139);
        $("#h-common-product-table-info").height(hwindow-130);
        $("#h-common-product-tree-info-list").height(hwindow-214);
        $('#h-common-product-table-id').bootstrapTable({
            height:hwindow-130,
        });

        Hutils.InitDomain({
            id:"#h-common-product_domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                var id = $("#h-common-product_domain-list").val();
                CommonProductObj.tree(id);
            },
            callback:function (domainId) {
                CommonProductObj.tree(domainId);
            }
        });
    });
</script>
<script id="h-common-product-src" type="text/html">
    <form class="row" id="h-common-product-form">
        <div class="col-sm-12" style="margin-top: 6px;">
            <span>产品编码</span>
            <input name="product_id" placeholder="由1-30位字母,数字组成（必填）" style="height: 30px; line-height: 30px;" class="form-control"/>
        </div>
        <div class="col-sm-12" style="margin-top: 6px;">
            <span>产品名称</span>
            <input name="product_desc" placeholder="产品详细描述信息（必填）" style="height: 30px; line-height: 30px;" class="form-control"/>
        </div>
        <div class="col-sm-12" style="margin-top: 20px;">
            <span>上级产品编码</span>
            <select name="product_up_id" style="width:100%;height: 30px; line-height: 30px;" class="form-control">
            </select>
        </div>
        <div style="display: none;">
            <input name="domain_id"/>
        </div>
    </form>
</script>