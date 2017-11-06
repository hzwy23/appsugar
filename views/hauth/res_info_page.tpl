<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">按钮服务资源管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div style="height: 44px; line-height: 44px;display: inline;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline;"
              class="pull-left">模块选项：</span>
        <select id="h-subsystem-func-list" class="form-control pull-left"
                style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0103010200"}}
        <button onclick="ResFuncObj.add()" class="btn btn-info btn-sm">
            <i class="icon-plus"> 新增服务</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0103010300"}}
        <button onclick="ResFuncObj.edit()" class="btn btn-info btn-sm" title="编辑菜单信息">
            <span class="icon-edit"> 编辑服务</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0103010400"}}
        <button onclick="ResFuncObj.delete()" class="btn btn-danger btn-sm" title="删除菜单信息">
            <span class="icon-trash"> 删除服务</span>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
    <div class="row">
        <div class="col-sm-12 col-md-12 col-lg-4">
            <div class="thumbnail" id="h-resource-tree-info">
                <div class="col-ms-12 col-md-12 col-lg-12">
                    <div style="border-bottom: #598f56 solid 2px;height: 44px; line-height: 44px;">
                        <div class="pull-left">
                            <span><i class="icon-sitemap"> </i>菜单资源信息</span>
                        </div>
                        <div class="pull-right">
                    <span>
                        <i class=" icon-search" style="margin-top: 15px;"></i>&nbsp;
                    </span>
                        </div>
                    </div>
                </div>
                <div id="h-resource-list-info" class="col-sm-12 col-md-12 col-lg-12"
                     style="padding:15px 5px;overflow: auto">
                </div>
            </div>
        </div>
        <div class="col-sm-12 col-md-12 col-lg-8" style="padding-left: 0px;">
            <table id="h-resource-button"
                   class="table"
                   data-toggle="table"
                   data-side-pagination="client"
                   data-pagination="true"
                   data-striped="true"
                   data-click-to-select="true"
                   data-show-refresh="false"
                   data-page-size="30"
                   data-page-list="[20, 30, 50, 100, 200]"
                   data-search="false">
                <thead>
                <tr>
                    <th data-field="state" data-checkbox="true"></th>
                    <th data-field="ResId">资源编码</th>
                    <th data-field="ResName">资源名称</th>
                    <th data-field="ResUrl">资源地址</th>
                    <th data-field="ResOpenType" data-formatter="ResFuncObj.formatterOpenType">打开方式</th>
                    <th data-align="center" data-field="NewIframe">iframe</th>
                    <th data-align="center" data-field="Method">请求方式</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
</div>
<!--功能按钮动态响应程序-->
<script type="text/javascript" src="/static/js/auth/buttonResource.js"></script>

<!--新增功能按钮表单-->
<script type="text/html" id="res_input_form">
    <form class="row" id="h-res-add-info">
        <div class="col-sm-12" style="margin-top: 3px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">资源编码：</label>
            <input id="h-res-add-res-id" placeholder="1-30位字母、数字组成" name="res_id" type="text" class="form-control" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 3px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">资源名称：</label>
            <input id="h-res-add-res-name" placeholder="1-30位汉字、字母组成" type="text" class="form-control" name="res_name" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">路由信息：</label>
            <input id="h-res-add-res-url" placeholder="如：/v1/auth/help" type="url" class="form-control" name="res_url" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">请求方式：</label>
            <select id="h-res-add-res-method" name="method" class="form-control" style="height: 30px; line-height: 30px;">
                <option value="GET">GET</option>
                <option value="POST">POST</option>
                <option value="DELETE">DELETE</option>
                <option value="PUT">PUT</option>
                <option value="HEAD">HEAD</option>
                <option value="OPTIONS">OPTIONS</option>
                <option value="TRACE">TRACE</option>
                <option value="CONNECT">CONNECT</option>
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">打开方式：</label>
            <select id="h-res-add-res-type" name="res_type" class="form-control" style="height: 30px; line-height: 30px;">
                <option value="0">内部区域</option>
                <option value="1">新建选项卡</option>
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">是否使用iframe：</label>
            <select id="h-res-add-new-iframe" name="new_iframe" class="form-control" style="height: 30px; line-height: 30px;">
                <option value="true">使用</option>
                <option value="false">不使用</option>
            </select>
        </div>
        <input id="h-res-add-up-res-id" name="res_up_id" type="text" style="display: none"/>
        <input id="h-res-modify-uuid" name="uuid" type="text"  style="display: none"/>
    </form>
</script>