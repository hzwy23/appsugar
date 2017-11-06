<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">菜单管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px;display: inline;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline;"
              class="pull-left">模块选项：</span>
        <select id="h-auth-menu-subsystem-list" class="form-control pull-left"
                style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0103070500"}}
        <button onclick="ResObj.add()" class="btn btn-info btn-sm">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0103070600"}}
        <button onclick="ResObj.edit()" class="btn btn-info btn-sm" title="编辑菜单信息">
            <span class="icon-edit"> 编辑菜单</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0103070800"}}
        <button onclick="ResObj.configTheme()" class="btn btn-info btn-sm"
                title="配置菜单主题信息">
            <span class="icon-edit"> 配置主题</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0103070700"}}
        <button onclick="ResObj.delete()" class="btn btn-danger btn-sm" title="删除菜单信息">
            <span class="icon-trash"> 删除</span>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content">
    <div class="row">
        <div class="col-sm-12 col-md-12 col-lg-4">
            <div class="thumbnail" id="h-auth-resource-tree-info">
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
                <div id="h-auth-resource-list-info" class="col-sm-12 col-md-12 col-lg-12"
                     style="padding:15px 5px;overflow: auto">
                </div>
            </div>
        </div>
        <div class="col-sm-12 col-md-12 col-lg-8" style="padding-left: 0px;">
            <div class="thumbnail" id="h-auth-resource-details-info">
                <div class="col-ms-12 col-md-12 col-lg-12">
                    <div style="border-bottom: #006c8f solid 2px;height: 44px; line-height: 44px;">
                        <div class="pull-left">
                            <span>资源详细信息</span>
                        </div>
                    </div>
                </div>
                <div class="col-sm-12 col-md-12 col-lg-12">
                    <table class="table table-bordered table-condensed" style="margin-top: 16px;">
                        <tr style="height: 36px; line-height: 36px;">
                            <td class="col-sm-2 col-md-2 col-lg-2"
                                style="background-color: #fafafa;text-align: right;padding-right: 15px;vertical-align: middle;">资源编码
                            </td>
                            <td id="h-auth-resource-show-id" class="col-sm-4 col-md-4 col-lg-4"
                                style="font-weight: 600;vertical-align: middle;padding-left: 15px;">-
                            </td>
                            <td class="col-sm-2 col-md-2 col-lg-2"
                                style="background-color: #fafafa;text-align: right;padding-right: 15px;vertical-align: middle;">资源描述
                            </td>
                            <td id="h-auth-resource-show-name" class="col-sm-4 col-md-4 col-lg-4"
                                style="font-weight: 600;vertical-align: middle;padding-left: 15px;">-
                            </td>
                        </tr>
                        <tr style="height: 36px; line-height: 36px;">
                            <td class="col-sm-2 col-md-2 col-lg-2"
                                style="background-color: #fafafa;text-align: right;padding-right: 15px;vertical-align: middle;">上级编码
                            </td>
                            <td id="h-auth-resource-show-up-id" class="col-sm-4 col-md-4 col-lg-4"
                                style="font-weight: 600;vertical-align: middle;padding-left: 15px;">-
                            </td>
                            <!--</tr>-->
                            <!--<tr style="height: 36px; line-height: 36px;">-->
                            <td class="col-sm-2 col-md-2 col-lg-2"
                                style="background-color: #fafafa;text-align: right;padding-right: 15px;vertical-align: middle;">资源属性
                            </td>
                            <td id="h-auth-resource-show-attr-desc" class="col-sm-4 col-md-4 col-lg-4"
                                style="font-weight: 600;vertical-align: middle;padding-left: 15px;">-
                            </td>
                        </tr>
                        <tr style="height: 36px; line-height: 36px;">
                            <td class="col-sm-2 col-md-2 col-lg-2"
                                style="background-color: #fafafa;text-align: right;padding-right: 15px;vertical-align: middle;">资源类别
                            </td>
                            <td id="h-auth-resource-show-type-desc" class="col-sm-4 col-md-4 col-lg-4"
                                style="font-weight: 600;vertical-align: middle;padding-left: 15px;">-
                            </td>
                            <td class="col-sm-2 col-md-2 col-lg-2"
                                style="background-color: #fafafa;text-align: right;padding-right: 15px;vertical-align: middle;">请求方式
                            </td>
                            <td id="h-auth-resource-show-method" class="col-sm-4 col-md-4 col-lg-4"
                                style="font-weight: 600;vertical-align: middle;padding-left: 15px;">-
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td id="h-auth-resource-show-type-id"></td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="thumbnail" id="h-auth-resource-theme-info" style="overflow: auto">
                <div class="col-ms-12 col-md-12 col-lg-12">
                    <div style="border-bottom: #8f2a07 solid 2px;height: 44px; line-height: 44px;">
                        <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
                        <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline"
                              class="pull-left">主题风格</span>
                        </div>
                        <div class="pull-right" style="height: 44px; line-height: 44px; width: 260px;">
                            <select onchange="ResObj.updateTheme()" id="h-auth-resource-theme-style-code"
                                    class="form-control pull-right"
                                    style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
                                <option value="1001">绿色主题</option>
                                <option value="1002">蓝色主题</option>
                                <option value="1003">粉丝主题</option>
                                <option value="1004">青色主题</option>
                                <option value="1005">传统主题</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-sm-12 col-md-12 col-lg-12">
                    <table class="table table-bordered table-condensed" style="margin-top: 16px;">
                        <tr style="height: 36px;line-height: 36px; display: none;">
                            <td class="col-sm-2"
                                style="background-color: #fafafa;text-align: right;padding-right: 15px;vertical-align: middle;">主题编码
                            </td>
                            <td id="h-auth-resource-show-theme-id" class="col-sm-4"
                                style="font-weight:600; vertical-align: middle;padding-left: 15px;">-
                            </td>
                            <td class="col-sm-2"
                                style="background-color: #fafafa;text-align: right;padding-right: 15px;vertical-align: middle;">主题名称
                            </td>
                            <td id="h-auth-resource-show-theme-desc" class="col-sm-4"
                                style="font-weight:600; vertical-align: middle;padding-left: 15px;">-
                            </td>
                        </tr>
                        <tr style="height: 36px;line-height: 36px;">
                            <td class="col-sm-2"
                                style="background-color: #fafafa; text-align: right;padding-right: 15px;vertical-align: middle;">资源色彩
                            </td>
                            <td id="h-auth-resource-show-res-bg-color" class="col-sm-4"
                                style="font-weight:600; vertical-align: middle;padding-left: 15px;">-
                            </td>
                            <td class="col-sm-2"
                                style="background-color: #fafafa; text-align: right;padding-right: 15px;vertical-align: middle;">资源样式
                            </td>
                            <td id="h-auth-resource-show-res-class" class="col-sm-4"
                                style="font-weight:600; vertical-align: middle;padding-left: 15px;">-
                            </td>
                        </tr>
                        <tr style="height: 36px;line-height: 36px;">
                            <td class="col-sm-2"
                                style="background-color: #fafafa; text-align: right;padding-right: 15px;vertical-align: middle;">图标
                            </td>
                            <td id="h-auth-resource-show-res-img" class="col-sm-4"
                                style="font-weight:600; vertical-align: middle;padding-left: 15px;">-
                            </td>
                            <td class="col-sm-2"
                                style="background-color: #fafafa; text-align: right;padding-right: 15px;vertical-align: middle;">路由
                            </td>
                            <td id="h-auth-resource-show-res-url" class="col-sm-4"
                                style="font-weight:600; vertical-align: middle;padding-left: 15px;">-
                            </td>
                        </tr>
                        <tr style="height: 36px;line-height: 36px;">
                            <td class="col-sm-2"
                                style="background-color: #fafafa; text-align: right;padding-right: 15px;vertical-align: middle;">分组号
                            </td>
                            <td id="h-auth-resource-show-res-group-id" class="col-sm-4"
                                style="font-weight:600; vertical-align: middle;padding-left: 15px;">-
                            </td>
                            <td class="col-sm-2"
                                style="background-color: #fafafa; text-align: right;padding-right: 15px;vertical-align: middle;">组内排序号
                            </td>
                            <td id="h-auth-resource-show-res-sort-id" class="col-sm-4"
                                style="font-weight:600; vertical-align: middle;padding-left: 15px;">-
                            </td>
                        </tr>

                        <tr style="height: 36px;line-height: 36px;">
                            <td class="col-sm-2"
                                style="background-color: #fafafa; text-align: right;padding-right: 15px;vertical-align: middle;">iframe嵌套
                            </td>
                            <td id="h-auth-resource-show-res-new-iframe" class="col-sm-4"
                                style="font-weight:600; vertical-align: middle;padding-left: 15px;">-
                            </td>

                            <td class="col-sm-2"
                                style="background-color: #fafafa; text-align: right;padding-right: 15px;vertical-align: middle;">打开方式
                            </td>
                            <td id="h-auth-resource-show-res-res-type-desc" class="col-sm-4"
                                style="font-weight:600; vertical-align: middle;padding-left: 15px;">-
                            </td>
                            <td id="h-auth-resource-show-res-res-type" class="col-sm-4"
                                style="font-weight:600; vertical-align: middle;padding-left: 15px;display: none"></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<!--菜单资源动态响应程序-->
<script type="text/javascript" src="/static/js/auth/menuResource.js"></script>

<!--新增菜单表单-->
<script type="text/html" id="h_auth_res_input_form">
    <form class="row" id="h-res-add-info">
        <div class="col-sm-12">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">资源编码：</label>
            <input id="h-res-add-res-id" placeholder="1-30位字母、数字组成" name="res_id" type="text" class="form-control" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">资源名称：</label>
            <input id="h-res-add-res-name" placeholder="1-30位汉字、字母组成" type="text" class="form-control" name="res_name" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">菜单类别：</label>
            <select id="h-res-add-type-id" name="res_type" class="form-control" style="height: 30px; line-height: 30px;">
                <option value="0">系统首页</option>
                <option value="1">菜单叶子</option>
                <option value="4">菜单结点</option>
            </select>
        </div>
        <div class="col-sm-12" style="display: none;margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">上级菜单：</label>
            <select id="h-res-add-up-res-id" name="res_up_id" type="text" class="form-control" style="height: 30px; line-height: 30px;padding: 0px; display: block">
            </select>
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
    </form>
</script>

<!--修改菜单表单-->
<script type="text/html" id="h_auth_res_input_form_modify">
    <form class="row form-horizontal" id="h-res-modify-info">
        <div class="col-sm-12">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">资源编码：</label>
            <input readonly="readonly" id="h-res-modify-res-id" placeholder="1-30位字母、数字组成" name="res_id" type="text" class="form-control" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">资源名称：</label>
            <input id="h-res-modify-res-name" placeholder="1-30位汉字、字母组成" type="text" class="form-control" name="res_name" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">上级菜单：</label>
            <select id="h-res-modify-res-up-id" class="form-control" name="res_up_id" style="height: 30px; line-height: 30px;">
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">请求方式：</label>
            <select id="h-res-modify-method" class="form-control" name="method" style="height: 30px; line-height: 30px;">
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
        <input name="res_type" style="display: none;"/>
    </form>
</script>

<!--主题信息配置表单-->
<script type="text/html" id="res_modify_theme_form">
    <form class="row" id="h-res-modify-theme-info">
        <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 2px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">所属主题：</label>
            <select id="h-res-modify-theme-id" name="theme_id" class="form-control" style="height: 30px; line-height: 30px;">
                <option value="1001">绿色主题</option>
                <option value="1002">蓝色主题</option>
                <option value="1003">粉丝主题</option>
                <option value="1004">青色主题</option>
                <option value="1005">传统主题</option>
            </select>
        </div>
        <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 2px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">样式属性：</label>
            <select id="h-res-modify-res-class" name="res_class" class="form-control" style="height: 30px; line-height: 30px;">
                <option value="tile">小方块图形</option>
                <option value="tile tile-wide">长方形图形</option>
                <option value="tile tile-large">大方块图形</option>
            </select>
        </div>
        <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">打开方式：</label>
            <select id="h-res-modify-res-type" name="res_type" class="form-control" style="height: 30px; line-height: 30px;">
                <option value="0">内部区域</option>
                <option value="1">新建选项卡</option>
            </select>
        </div>

        <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">是否使用iframe：</label>
            <select id="h-res-modify-new-iframe" name="new_iframe" class="form-control" style="height: 30px; line-height: 30px;">
                <option value="true">使用</option>
                <option value="false">不使用</option>
            </select>
        </div>

        <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">图标路径：</label>
            <input id="h-res-modify-res-img" placeholder="如：/static/images/example.png" name="res_img" type="text" class="form-control" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">图标色彩：</label>
            <input id="h-res-modify-res-bg-color" placeholder="#339999" name="res_bg_color" type="text" class="form-control" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">路由信息：</label>
            <input id="h-res-modify-res-url" placeholder="如：/v1/auth/help" type="url" class="form-control" name="res_url" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">分组编号：</label>
            <select id="h-res-modify-group-id" class="form-control" name="group_id" style="height: 30px; line-height: 30px;">
                <option value="1">第一列</option>
                <option value="2">第二列</option>
                <option value="3">第三列</option>
            </select>
        </div>
        <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
            <label class="control-label" style="font-size: 14px; font-weight: 500;text-align: left">排序号：</label>
            <input id="h-res-modify-sort-id" placeholder="所在分组的排序号，请用数字表示" name="sort_id" type="number" class="form-control" style="height: 30px; line-height: 30px;">
        </div>
    </form>
</script>