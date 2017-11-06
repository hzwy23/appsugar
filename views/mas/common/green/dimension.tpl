<div id="wrapper" class="navbar-static-side hzwy23-theme-background" style="margin: 0px;">
    <div class="H-logo-area" style="margin: 0px; padding: 0 0 0 30px;">
        公共维度信息
    </div>
    <div class="col-sm-12 col-md-12 col-lg-12" id="H-main-menu" style="margin-bottom: 60px;">
        <div id="h-system-service" class="col-sm-12 col-md-6 col-lg-4">
        </div>
        <div id="h-mas-service" class="col-sm-12 col-md-6 col-lg-4">
        </div>
        <div id="h-other-service"  class="col-sm-12 col-md-6 col-lg-4">
        </div>
    </div>
</div>

<div id="page-wrapper" class="gray-bg col-sm-12 col-md-12 col-lg-12"
     style="margin:0px;padding: 0px;">
    <div id="h-main-content"
         style="padding: 0px; margin: 0px;position: relative; overflow: auto;">
    </div>
</div>

<script type="text/javascript">
    /*
    * 调整页面宽度和高度
    * */
    $(document).ready(function(){
        var hwindow = document.documentElement.clientHeight;
        var wwindow = document.documentElement.clientWidth;
        $("#wrapper").height(hwindow);
        $("#wrapper").width(wwindow);
        $("#page-wrapper").height(hwindow);
        $("#page-wrapper").width(wwindow);
        $("#main-menu-bar").height(hwindow);
        $("#h-main-content").height(hwindow);
        $(".H-content-tab").width(wwindow);
        $(".navbar-static-side").width(wwindow);
        Hutils.initMenu(1,'0400000000',"维度一","维度二","维度三");

    });

    window.onresize = function(){
        var hw = document.documentElement.clientWidth;
        var hh = document.documentElement.clientHeight;
        $("#wrapper").height(hh);
        $("#wrapper").width(hw);
        $("#page-wrapper").height(hh)
        $("#page-wrapper").width(hw)
        $("#H-main-content").height(hh);
    }
</script>