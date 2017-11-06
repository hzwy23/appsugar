<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">责任中心配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px;">
        <span style="font-size: 10px;font-weight: 600;height: 30px; line-height: 30px; margin-top: 7px;display: inline"
              class="pull-left">所属域：</span>
        <select id="h-ca-org-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0201010100"}}
        <button onclick="HCaOrgObj.refresh()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-refresh"> 刷新</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201010300"}}
        <button onclick="HCaOrgObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201010200"}}
        <button onclick="HCaOrgObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201010500"}}
        <button onclick="HCaOrgObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-upload-alt"> 导入</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201010600"}}
        <button onclick="HCaOrgObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-download-alt"> 下载</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201010400"}}
        <button onclick="HCaOrgObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content">
    <div class="row" style="padding-top: 1px;">
        <div class="col-sm-12 col-md-5 col-lg-4">
            <div id="h-ca-org-tree-info" class="thumbnail">
                <div class="col-sm-12">
                    <div style="border-bottom: #598f56 solid 1px;height: 44px; line-height: 44px;">
                        <div class="pull-left">
                            <span><i class="icon-sitemap"> </i>责任中心组织架构树</span>
                        </div>
                        <div class="pull-right">
                <span>
                    <i class=" icon-search" style="margin-top: 15px;"></i>&nbsp;
                </span>
                        </div>
                    </div>
                </div>
                <div id="h-ca-org-tree-info-list" class="col-sm-12 col-md-12 col-lg-12"
                     style="padding:15px 5px;overflow: auto;">
                </div>
            </div>
        </div>
        <div id="h-ca-org-table-info" class="col-sm-12 col-md-7 col-lg-8" style="padding-left: 0px;">
            <table id="h-ca-org-info-table-details"
                   data-toggle="table"
                   data-striped="true"
                   data-unique-id="org_unit_id"
                   data-side-pagination="client"
                   data-pagination="true"
                   data-page-size="30"
                   data-row-style="Hutils.rowStyle"
                   data-click-to-select="true"
                   data-page-list="[10,20,30, 50, 100, 200]"
                   data-search="false">
                <thead>
                <tr>
                    <th data-field="state" data-checkbox="true"></th>
                    <th data-sortable="true" data-field="code_number">责任中心编码</th>
                    <th data-sortable="true" data-field="org_unit_desc">责任中心名称</th>
                    <th data-sortable="true" data-field="org_up_id" data-formatter="HCaOrgObj.upOrgId">上级编码</th>
                    <th data-sortable="true" data-field="cost_type_desc">类型</th>
                    <th data-sortable="true" data-field="org_attr_desc">属性</th>
                    <th data-sortable="true" data-field="finance_org_id">财务编码</th>
                    <th data-sortable="true" data-field="modify_date">修改日期</th>
                    <th data-sortable="true" data-field="modify_user">修改人</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">

    /*
    * 初始化表结构，数值为空，后续会再次触发填充调结构，
    * 分两次初始化表结构，主要是防止在带宽比较差时，引起的页面变形加载问题。
    * */
    $(document).ready(function () {
        $('#h-ca-org-info-table-details').bootstrapTable({
            height:document.documentElement.clientHeight-130,
        });
    });

    /*
    * CA责任中心包含的处理函数。
    * */
    var HCaOrgObj = {
        $table:$('#h-ca-org-info-table-details'),
        /*
        * 新增责任中心编码信息，
        * 当点击新增按钮后，会调用这个函数进行处理
        * */
        add:function(){
            $.Hmodal({
                body:$("#h-ca-org_input_form").html(),
                header:"新增责任中心",
                width:"420px",
                callback:function(hmode){
                    $.HAjaxRequest({
                        url:"/v1/ca/responsibility/post",
                        data:$("#h-ca-org-add-form").serialize(),
                        type:"post",
                        success:function () {
                            $.Notify({
                                message:"新增责任中心信息成功",
                                type:"success",
                            });
                            var domain_id = $("#h-ca-org-domain-list").val();
                            HCaOrgObj.tree(domain_id);
                            $(hmode).remove();
                            //HCaOrgObj.$table.bootstrapTable("refresh")
                        },
                    })
                },
                preprocess:function(){
                    var domainId = $("#h-ca-org-domain-list").val();
                    var upid = $("#h-ca-org-tree-info-list").attr("data-selected");
                    $("#h-ca-org-form-domain-id").val(domainId);

                    $.getJSON("/v1/ca/responsibility/nodes/get",{
                        domain_id:domainId
                    },function(data){
                        var arr = new Array()
                        $(data).each(function(index,element){
                            var ijs = {};
                            ijs.id=element.org_unit_id;
                            ijs.text=element.org_unit_desc;
                            ijs.upId=element.org_up_id;
                            arr.push(ijs)
                        });
                        var ijs = {};
                        ijs.id="-1";
                        ijs.text="责任中心树根节点";
                        ijs.upId="######hzwy23#####";
                        arr.push(ijs)
                        $("#h-ca-org-up-id-form").Hselect({
                            data:arr,
                            value:upid,
                            height:"30px",
                        })
                    });


                    $("#h-ca-org-type-cd-form").Hselect({
                        height:"30px",
                        value:"0",
                    });
                    $("#h-ca-org-attr-form").Hselect({
                        height:"30px",
                        value:"0",
                    })
                }
            })
        },
        edit:function(){
            var row = HCaOrgObj.$table.bootstrapTable("getSelections").concat();
            var handle = function(){
                var domain_id = row[0].domain_id;
                $.Hmodal({
                    body:$("#h-ca-org_input_form").html(),
                    header:"修改责任中心信息",
                    width:"420px",
                    preprocess:function () {
                        $("#h-ca-org-form-domain-id").val(domain_id);

                        var org_unit_id = row[0].code_number;
                        var org_unit_desc = row[0].org_unit_desc;
                        var org_up_id = row[0].org_up_id;
                        var cost_type_cd = row[0].cost_type_cd;
                        var org_attr_cd = row[0].org_attr_cd;
                        var finance_org_id = row[0].finance_org_id;

                        $("#h-ca-org-add-form").find("input[name='org_unit_id']").val(org_unit_id).attr("readonly","readonly").css("background-color","#f4f4f4");
                        $("#h-ca-org-add-form").find("input[name='org_unit_desc']").val(org_unit_desc);
                        $("#h-ca-org-add-form").find("input[name='finance_org_id']").val(finance_org_id);

                        $.getJSON("/v1/ca/responsibility/nodes/get",{
                            domain_id:domain_id
                        },function(data){
                            var arr = new Array();
                            $(data).each(function(index,element){
                                var ijs = {};
                                ijs.id=element.org_unit_id;
                                ijs.text=element.org_unit_desc;
                                ijs.upId=element.org_up_id;
                                arr.push(ijs);
                            });
                            var ijs = {};
                            ijs.id = "-1";
                            ijs.text = "责任中心树根节点";
                            ijs.upId = "######hzwy23#####";
                            arr.push(ijs);

                            $("#h-ca-org-up-id-form").Hselect({
                                data:arr,
                                value:org_up_id,
                                height:"30px",
                            })
                        });

                        $("#h-ca-org-type-cd-form").Hselect({
                            height:"30px",
                            value:cost_type_cd,
                        });

                        $("#h-ca-org-attr-form").Hselect({
                            height:"30px",
                            value:org_attr_cd,
                            bgColor:"#f4f4f4",
                            disabled:true,
                        })

                    },
                    callback:function(hmode){

                        $.HAjaxRequest({
                            url:"/v1/ca/responsibility/put",
                            type:"Put",
                            data:{
                                org_unit_id:row[0].org_unit_id,
                                domain_id:domain_id,
                                org_up_id:$("#h-ca-org-up-id-form").val(),
                                org_unit_desc:$("#h-ca-org-add-form").find("input[name='org_unit_desc']").val(),
                                finance_org_id:$("#h-ca-org-add-form").find("input[name='finance_org_id']").val(),
                                cost_type_cd:$("#h-ca-org-type-cd-form").val()
                            },
                            dataType:'json',
                            success:function () {
                                $.Notify({
                                    title:"温馨提示：",
                                    message:"修改责任中心信息成功",
                                    type:"success",
                                });
                                $(hmode).remove();
                                HCaOrgObj.tree(domain_id)
                                $("#h-ca-org-tree-info-list").removeAttr("data-selected");
                            },
                        })
                    }
                })
            };
            if (row.length == 0){

                var selected_id = $("#h-ca-org-tree-info-list").attr("data-selected")
                if (selected_id == undefined){
                    $.Notify({
                        title:"温馨提示",
                        message:"请在列表中选择一项需要编辑的机构",
                        type:"info",
                    });
                    return
                }
                row.push(HCaOrgObj.$table.bootstrapTable("getRowByUniqueId",selected_id))
                handle()
            } else if (row.length == 1){
                handle()
            } else {
                $.Notify({
                    title:"温馨提示",
                    message:"只能选择<span style='font-weight: 600; color: red'>一项</span>进行编辑",
                    type:"warning",
                })
            }
        },
        /*
        * 当点击页面上的删除按钮后，会调用这个函数，
        * 删除功能，会将制定的责任中心，以及这个责任中心下属机构一同删除
        * */
        delete:function(){
            var domain_id = $("#h-ca-org-domain-list").val();

            var data = HCaOrgObj.$table.bootstrapTable("getSelections").concat();

            if (data.length == 0){

                var selected_id = $("#h-ca-org-tree-info-list").attr("data-selected");

                if (selected_id == undefined){
                    $.Notify({
                        title:"温馨提示",
                        message:"请选择需要删除的责任中心",
                        type:"warning",
                    });
                    return
                }

                data.push(HCaOrgObj.$table.bootstrapTable("getRowByUniqueId",selected_id))

                var notify = "点击确定,在删除责任中心的同时<br/>其下级责任中心也会一同删除"
                if (data[0].org_attr_cd == "0"){
                    notify = "点击确定,删除选中的责任中心信息"
                }

                $.Hconfirm({
                    callback:function () {
                        $.HAjaxRequest({
                            url:"/v1/ca/responsibility/delete",
                            type:"post",
                            data:{JSON:JSON.stringify(data),domain_id:domain_id},
                            success:function () {
                                $.Notify({
                                    title:"温馨提示：",
                                    message:"删除责任中心成功",
                                    type:"success",
                                });
                                HCaOrgObj.tree(domain_id)
                                $("#h-ca-org-tree-info-list").removeAttr("data-selected");
                            },
                        })
                    },
                    body:notify,
                })
            } else {
                var notify = "点击确定,在删除责任中心的同时<br/>其下级责任中心也会一同删除"
                if (data[0].org_attr_cd == "0"){
                    notify = "点击确定,删除选中的责任中心"
                }
                $.Hconfirm({
                    callback:function () {
                        $.HAjaxRequest({
                            url:"/v1/ca/responsibility/delete",
                            type:"post",
                            data:{JSON:JSON.stringify(data),domain_id:domain_id},
                            success:function () {
                                $.Notify({
                                    title:"温馨提示：",
                                    message:"删除责任中心成功",
                                    type:"success",
                                });
                                HCaOrgObj.tree(domain_id)
                                $("#h-ca-org-tree-info-list").removeAttr("data-selected");
                            },
                        })
                    },
                    body:notify,
                })
            }
        },
        download:function(){
            var domain_id = $("#h-ca-org-domain-list").val()
            var x=new XMLHttpRequest();
            x.open("GET", "/v1/ca/responsibility/download?domain_id="+domain_id, true);
            x.responseType = 'blob';
            x.onload=function(e){
                download(x.response, "责任中心信息.xlsx", "application/vnd.ms-excel" );
            };
            x.send();
        },
        upload:function(){
            var uploader;
            $.Hmodal({
                header:"导入责任中心信息",
                body:$("#h-ca-org-upload-form").html(),
                height:"360px",
                submitDesc:"上传",
                cancelDesc:"关闭",
                preprocess:function () {
                    uploader = WebUploader.create({

                        // swf文件路径
                        swf: '/static/webuploader/dist/Uploader.swf',

                        // 文件接收服务端。
                        server: '/v1/ca/responsibility/upload',

                        // 选择文件的按钮。可选。
                        // 内部根据当前运行是创建，可能是input元素，也可能是flash.
                        pick: '#h-ca-org-upload-select-file',

                        // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
                        resize: false
                    });
                    uploader.on('beforeFileQueued',function () {
                        uploader.reset();
                    });
                    uploader.on( 'fileQueued', function( file ) {

                        var unit = "KB"
                        var size = (file.size/1024).toFixed(0)
                        if (size > 1024) {
                            size = (size/1024).toFixed(2)
                            unit = "MB"
                        }
                        var v = size +" "+ unit

                        var optHtml = "<tr><td>"+file.name+"</td><td>"+v+"</td></tr>"

                        $("#h-ca-file-list").find("tbody").html(optHtml)

                    });

                    uploader.on("uploadError",function (file) {
                        $.Notify({
                            title:"温馨提示:",
                            message:"上传失败,请联系管理员",
                            type:"info",
                        });
                        $("#h-ca-org-upload-progress").css("width","100%");
                        $("#h-ca-org-upload-progress").removeClass("progress-bar-info progress-bar-striped").addClass("progress-bar-danger")
                        $("#h-ca-org-upload-progress span").html("导入失败")
                    });
                },
                callback:function () {
                    if (uploader.getFiles().length == 0){
                        $.Notify({
                            message:"请选择上传文件",
                            type:"info",
                        });

                        return
                    }

                    uploader.on("uploadSuccess",function (file,response ) {
                        $.Notify({
                            title:"温馨提示:",
                            message:response.data,
                            type:"success",
                        });
                        $("#h-ca-org-upload-progress span").html("100%")
                        $("#h-ca-org-upload-progress").css("width","100%");

                        $("#h-ca-org-upload-progress").removeClass("progress-bar-info progress-bar-striped").addClass("progress-bar-success")
                        var domain_id = $("#h-ca-org-domain-list").val()
                        HCaOrgObj.tree(domain_id)
                        $("#h-ca-org-tree-info-list").removeAttr("data-selected");
                    });
                    uploader.upload();
                    if ($("#h-ca-org-upload-progress").html() == undefined) {
                        $("#h-ca-file-list").find("tbody").append($("#h-ca-org-progress-template").html())
                    } else {
                        $.Notify({
                            title:"温馨提示:",
                            message:"已经上传完成",
                            type:"info",
                        });
                        return
                    }
                    uploader.on("uploadProgress",function (file, percentage) {
                        if (percentage==1) {
                            percentage = 0.99
                        }
                        var p = percentage*100+"%"
                        $("#h-ca-org-upload-progress span").html(p)
                        $("#h-ca-org-upload-progress").css("width",p);
                    });
                },
            })
        },
        /*
        * 责任中心树形展示处理函数
        * 左侧树形处理，将结构信息处理成层级状态
        * */
        tree:function(domain_id){
            // 获取指定域中的责任中心信息
            // 如果指定的域为空，则获取用户自己所在的域中责任中心信息
            $.getJSON("/v1/ca/responsibility/get",{
                domain_id:domain_id
            },function(data){

                if (data.length==0){
                    /*
                  * 如果指定的域中没有机构信息
                  * 则提示用户，这个域中没有配置责任中心信息
                  * */
                    $.Notify({
                        title:"温馨提示",
                        message:"您选择的域中没有配置责任中心",
                        type:"info",
                    });
                    // 用空置填充表格
                    HCaOrgObj.$table.bootstrapTable('load',[]);
                    // 用空置填充树形区域
                    $("#h-ca-org-tree-info-list").Htree({
                        data:[],
                    })
                } else {
                    var arr = new Array()
                    $(data).each(function(index,element){
                        var ijs = {};
                        ijs.id = element.org_unit_id;
                        ijs.text = element.org_unit_desc;
                        ijs.upId = element.org_up_id;
                        ijs.attr = element.org_attr_cd;
                        arr.push(ijs);
                    });

                    // 初始化树形展示区域
                    // 添加树形区域中,单击事件
                    $("#h-ca-org-tree-info-list").HtreeWithLine({
                        attr:true,
                        data:arr,
                        onChange:function(obj){
                            // 获取被选中的责任中心编码
                            var id = $(obj).attr("data-id");
                            // 获取域编码
                            var domain_id = $("#h-ca-org-domain-list").val();

                            // 获取被选中的责任中心所有下级责任中心信息
                            $.getJSON("/v1/ca/responsibility/sub/get",{org_unit_id:id,domain_id:domain_id},function(data){
                                HCaOrgObj.$table.bootstrapTable('load',data)
                                $("#h-ca-org-info-table-details tbody tr").each(function (index, element) {
                                    if ( $(element).attr("data-uniqueid") == id ) {
                                        $(element).addClass("info")
                                    }
                                })
                            });
                        }
                    });
                    // 触发表更新
                    // 当树形区域构建成功之后,将数据填写到表格中
                    HCaOrgObj.$table.bootstrapTable('load',data)

                }
            })
        },
        /*
        * 上级机构编码格式化
        * 由于数据库中存储的机构编码存储的是域与机构的组合，
        * 在向客户端展示机构编码时，想要将组合的域去掉
        * */
        upOrgId:function(value,row,index){
            var upcombine = row.org_up_id.split("_join_")
            if (upcombine.length==2){
                return upcombine[1]
            }else{
                return upcombine
            }
        },
        refresh:function () {
            var id = $("#h-ca-org-domain-list").val();
            HCaOrgObj.tree(id);
        }
    };

    $(document).ready(function(){
        var hwindow = document.documentElement.clientHeight;
        $("#h-ca-org-tree-info").height(hwindow-153);
        $("#h-ca-org-table-info").height(hwindow-179);
        $("#h-ca-org-tree-info-list").height(hwindow-224);

        Hutils.InitDomain({
            id:"#h-ca-org-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                var id = $("#h-ca-org-domain-list").val();
                HCaOrgObj.tree(id);
            },
            callback:function (domainId) {
                HCaOrgObj.tree(domainId);
            },
        });
    });
</script>

<script type="text/html" id="h-ca-org_input_form">
    <form class="row" id="h-ca-org-add-form">
        <div class="col-sm-12" style="margin-top: 2px;">
            <label class="h-label" style="width:100%;">责任中心编码：</label>
            <input placeholder="请输入1-30位数字，字母（必填）" name="org_unit_id" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
        </div>

        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="h-label" style="width: 100%;">责任中心名称：</label>
            <input placeholder="责任中心详细描述信息（必填）" type="text" class="form-control" name="org_unit_desc" style="width: 100%;height: 30px;line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="h-label" style="width: 100%;">上级责任中心：</label>
            <select id="h-ca-org-up-id-form" name="org_up_id" style="width: 100%;height: 30px;line-height: 30px;">
            </select>
        </div>

        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="h-label" style="width: 100%;">成本类型：</label>
            <select id="h-ca-org-type-cd-form" name="cost_type_cd" style="width: 100%;height: 30px;line-height: 30px;">
                <option value="0" selected>成本中心</option>
                <option value="1">利润中心</option>
                <option value="2">其　　他</option>
            </select>
        </div>

        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="h-label" style="width: 100%;">层级属性：</label>
            <select id="h-ca-org-attr-form" name="org_attr_cd" style="width: 100%;height: 30px;line-height: 30px;">
                <option value="0">叶子</option>
                <option value="1">节点</option>
            </select>
        </div>

        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="h-label" style="width: 100%;">财务机构编码：</label>
            <input placeholder="请输入1-30位字母，数字（选填）" type="text" class="form-control" name="finance_org_id" style="width: 100%;height: 30px;line-height: 30px;">
        </div>
        <input id="h-ca-org-form-domain-id" name="domain_id" style="width: 100%;height: 30px;line-height: 30px;display: none;"/>
    </form>
</script>

<script id="h-ca-org-upload-form" type="text/html">
    <div class="row">
        <div class="col-sm-12 col-md-12 col-lg-12">
            <div class="pull-left">
                <div id="h-ca-org-upload-select-file">选择文件</div>
            </div>
        </div>
        <!--用来存放文件信息-->
        <div class="col-sm-12 col-md-12 col-lg-12 uploader-list" style="margin-top: 15px;">
            <table id="h-ca-file-list" class='table table-responsive table-bordered'>
                <thead>
                <tr><th>文件名</th><th>大小</th></tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
</script>

<script id="h-ca-org-progress-template" type="text/html">
    <tr><td colspan="2"><span>上传进度:</span><div class="progress" style="margin-top: 5px;"><div id="h-ca-org-upload-progress" class="progress-bar progress-bar-info progress-bar-striped active" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"><span>0%</span></div></div></td></tr>
</script>