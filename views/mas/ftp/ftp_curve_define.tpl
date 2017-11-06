<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">曲线定义</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">所属域：</span>
        <select id="h-ftp-curve-define-info-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        <button onclick="FtpCurveDefineObj.add()" class="btn btn-info btn-sm">
            <i class="icon-plus"> 新增</i>
        </button>
        <button onclick="FtpCurveDefineObj.update()" class="btn btn-info btn-sm">
            <span class="icon-edit"> 编辑</span>
        </button>
        <button onclick="FtpCurveDefineObj.delete()" class="btn btn-danger btn-sm">
            <span class="icon-trash"> 删除</span>
        </button>
    </div>
</div>

<div class="subsystem-content">
    <table id="h-ftp-curve-define-info-table-details"
           data-toggle="table"
           data-striped="true"
           data-side-pagination="client"
           data-pagination="true"
           data-click-to-select="true"
           data-url="/v1/ftp/curve/define/get"
           data-page-list="[20, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-sortable="true" data-field="code_number">曲线编码</th>
            <th data-sortable="true" data-field="curve_desc">曲线名称</th>
            <th data-sortable="true" data-align="center" data-field="iso_currency_desc">币种名称</th>
            <th data-sortable="true" data-align="center" data-field="create_date">创建日期</th>
            <th data-sortable="true" data-align="center" data-field="create_user">创建人</th>
            <th data-sortable="true" data-align="center" data-field="modify_date">修改日期</th>
            <th data-sortable="true" data-align="center" data-field="modify_user">修改人</th>
            <th data-sortable="true" data-align="center" data-field="latest_curve_date">最新曲线</th>
            <th data-align="center" data-formatter="FtpCurveDefineObj.formatter">操作</th>
        </tr>
        </thead>
    </table>
</div>
<script type="text/javascript">

    var FtpCurveDefineObj = {
        getCurveManagePage:function (id,name) {
            Hutils.openTab({
                url:"/v1/ftp/curve/manage/page?curve_id="+id,
                id:"0301020000",
                title:"曲线管理",
                error:function (m) {
                    $.Notify({
                        title:"温馨提示：",
                        message:"您没有被授权访问这个域。",
                        type:"info",
                    })
                }
            });
        },
        formatter:function (value, rows, index) {
            return '<span class="h-td-btn btn-primary btn-xs" onclick="FtpCurveDefineObj.getCurveManagePage(\''+rows.curve_id+'\',\''+ rows.curve_desc+'\')">曲线值管理</span>'
        },
        add:function () {
            var domain_id = $("#h-ftp-curve-define-info-domain-list").val();
            $.Hmodal({
                header:"新增曲线定义",
                width:"596px",
                body:$("#h-curve-defint-input").html(),
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:'/v1/ftp/curve/define/post',
                        data:$("#h-add-curve-def-form").serialize(),
                        type:'post',
                        success:function(){
                            $(hmode).remove();
                            $.Notify({
                                title:"恭喜",
                                message:"成功添加曲线信息",
                                type:"success",
                            });
                            $("#h-ftp-curve-define-info-table-details").bootstrapTable('refresh');
                        },
                })
                },
                preprocess:function () {
                    var domain_desc = $('#h-ftp-curve-define-info-domain-list option:selected').text();
                    $("#h-ftp-curve-def-domain-desc").val(domain_desc);
                    $("#h-ftp-curve-def-domain-id").val(domain_id);

                    setTimeout(function () {
                        // 币种信息初始化
                        $.getJSON("/v1/common/isocurrency/get",{
                            domain_id:domain_id
                        },function (data) {
                            var arr = new Array()
                            $(data).each(function (index, element) {
                                var e = {};
                                e.id = element.iso_currency_cd;
                                e.text = element.iso_currency_desc;
                                e.upId = "##hzwy23##"
                                arr.push(e)
                            });
                            $("#h-curve-define-currency-cd").Hselect({
                                height:"30px",
                                data:arr,
                            })
                        });

                        $.getJSON("/v1/ftp/curve/struct/get",function(data){
                            var optHtml = ""
                            $(data).each(function(index,element){
                                optHtml +='<div style="width: 80px; float: left;"><label class="control-label">'+element.struct_code+'</label><div class="switch" tabindex="0"> <input type="checkbox" name="termlist" value="'+element.struct_code+'"/></div></div>'
                            });
                            $("#h-term-list-info").html(optHtml)
                            $("[name='termlist']").bootstrapSwitch({size:"mini",onColor:"primary",
                                offColor:"warning"})
                        });
                    },300);
                },
            })
        },
        delete:function () {
            var domain_id = $("#h-ftp-curve-define-info-domain-list").val();
            var rows = $("#h-ftp-curve-define-info-table-details").bootstrapTable('getSelections')
            if (rows.length == 0) {
                $.Notify({
                    title:"温馨提示:",
                    message:"请选择需要删除的曲线",
                    type:"info",
                })
                return
            }
            $.Hconfirm({
                body:"点击确定,删除曲线信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ftp/curve/define/delete",
                        type:"post",
                        dataType:'json',
                        data:{JSON:JSON.stringify(rows),domain_id:domain_id},
                        success:function () {
                            $.Notify({
                                title:"温馨提示：",
                                message:"删除曲线信息成功",
                                type:"success",
                            })
                            $("#h-ftp-curve-define-info-table-details").bootstrapTable('refresh');
                        }
                    })
                },
            })
        },
        update:function () {
            $.notifyClose();
            var row = $("#h-ftp-curve-define-info-table-details").bootstrapTable('getSelections');

            if (row.length == 0){
                $.Notify({
                    title:"温馨提示:",
                    message:"请选择一条曲线进行编辑",
                    type:"info",
                })
                return
            } else if ( row.length > 1) {
                $.Notify({
                    title:"温馨提示:",
                    message:"您选择了多条曲线,不知道您想编辑那一条",
                    type:"info",
                })
                return
            }

            $.Hmodal({
              header:"编辑曲线定义信息",
              body:$("#h-modify-curve-def").html(),
              width:"420px",
              callback:function (hmode) {
                    var curve_id = row[0].curve_id;
                    var domain_id = row[0].domain_id;
                    var curve_desc = $("#h-modify-curve-desc").val();

                    $.HAjaxRequest({
                        url:"/v1/ftp/curve/define/put",
                        type:"put",
                        data:{curve_id:curve_id,domain_id:domain_id,curve_desc:curve_desc},
                        success:function (data) {
                            $.Notify({
                                title:"温馨提示:",
                                message:"更新曲线信息成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            $("#h-ftp-curve-define-info-table-details").bootstrapTable('refresh');
                        }
                    })
              },
              preprocess:function () {
                  var curve_id = row[0].curve_id;
                  var tmp = curve_id.split("_join_")
                  if (tmp.length==2){
                      curve_id = tmp[1]
                  }

                  $("#h-modify-curve-id").val(curve_id);
                  $("#h-modify-curve-desc").val(row[0].curve_desc);

              },
          });

        },
    };

    $(document).ready(function () {
        Hutils.InitDomain({
            id:"#h-ftp-curve-define-info-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                $("#h-ftp-curve-define-info-table-details").bootstrapTable('refresh')
            },
            callback:function (domainId) {
                $("#h-ftp-curve-define-info-table-details").bootstrapTable({
                    queryParams:function (params) {
                        params.domain_id = $("#h-ftp-curve-define-info-domain-list").val();
                        return params
                    }
                });
            },
        });
    })
</script>

<script type="text/html" id="h-curve-defint-input">
    <form class="row" id="h-add-curve-def-form">
        <div class="col-sm-6 col-md-6 col-lg-6">
            <label class="control-label" style="font-size: 12px;">曲线编码：</label>
            <input placeholder="1-30个字母、数字组成" name="curve_id" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
        </div>
        <div class="col-sm-6 col-md-6 col-lg-6">
            <label class="control-label" style="font-size: 12px;">曲线描述：</label>
            <input placeholder="1-30个汉字、字母、数字组成" name="curve_desc" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
        </div>
        <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 12px;">
            <label class="control-label" style="font-size: 12px;">域名：</label>
            <input readonly="readonly" id="h-ftp-curve-def-domain-desc" name="domain_desc" class="form-control" style="width: 100%;height: 30px;line-height: 30px; background-color: #f5f5f5;" />
            <input readonly="readonly" id="h-ftp-curve-def-domain-id" name="domain_id" class="form-control" style="width: 100%;height: 30px;line-height: 30px; background-color: #f5f5f5;display: none;" />
        </div>
        <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 12px;">
            <label class="control-label" style="font-size: 12px;">币种：</label>
            <select placeholder="币种信息" name="iso_currency_cd" id="h-curve-define-currency-cd" class="form-control" style="width: 100%;">
            </select>
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 12px;">
            <label class="control-label" style="font-size: 12px;">曲线期限点：</label>
            <div id="h-term-list-info">
            </div>
        </div>
    </form>
</script>

<script type="text/html" id="h-modify-curve-def">
    <form class="row" id="h-modify-curve-def-info">
        <div class="col-sm-12">
            <label style="font-size: 12px;" class="control-label">曲线编码：</label>
            <input id="h-modify-curve-id" readonly="readonly" style="height: 30px; line-height: 30px;background-color: transparent" name="curve_id" type="text" class="form-control">
        </div>
        <div class="col-sm-12" style="margin-top: 23px;">
            <label style="font-size: 12px;" class="control-label">曲线描述：</label>
            <input id="h-modify-curve-desc" style="height: 30px; line-height: 30px;" type="text" class="form-control" name="curve_desc">
        </div>
    </form>
</script>