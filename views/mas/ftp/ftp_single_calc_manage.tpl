<style>
    .ibox-label{
        height:26px;
        line-height:26px;
        font-size:11px;
        font-weight: 600;
        float:left;
        width: 90px;
    }
</style>
<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">FTP价格计算</span>
    </div>
    <div class="pull-right">
    </div>
</div>

<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-ftp-single-calculate-domain" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        <button onclick="ftpTrialCalc()" type="button" class="btn btn-info btn-sm">开始试算</button>
    </div>
</div>

<div class="subsystem-content" style="overflow: auto;">
    <div id="ftpInterface" style="margin-bottom: 120px;">
        <form id="ftpAcctInfo" class="form-inline" role="form"
              style="margin: 25px 15px auto 15px">
            <div class="row" style="margin:auto 0px;border-top: #cccccc solid 1px; padding: 15px 15px;
        position: relative; border-radius: 5px;">
                <h4 style="position: absolute;
        margin-top: -30px;
        background-color:#f3f3f4;
        font-size: 14px;
        width: 80px;
        font-weight: 600;
        color: #901253;
        text-align: center;
        margin-left: 15px;">基础信息</h4>
                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">业务分类:</label>
                    <select placeholder="币种信息"
                            name="busiz_id"
                            id="busiz_id"
                            class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
                    </select>
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">起息日期:</label>
                    <input id="origination_date"
                           name="origination_date"
                           type="text"
                           class="form-control"
                           placeholder="业务开始计息日期" style="width: 100%;height: 30px;line-height: 30px;">
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">到期日期:</label>
                    <input id="maturity_date"
                           name="maturity_date"
                           type="text"
                           class="form-control"
                           placeholder="业务到期日期" style="width: 100%;height: 30px;line-height: 30px;">
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">执行利率(%):</label>
                    <input id="cur_net_rate"
                           name="cur_net_rate"
                           type="text"
                           class="form-control"
                           placeholder="业务的执行利率值（%）" style="width: 100%;height: 30px;line-height: 30px;">
                </div>


                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">计息方式:</label>
                    <select placeholder="币种信息"
                            name="accrual_basis_cd"
                            id="accrual_basis_cd"
                            class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
                        <option value="1">30/360</option>
                        <option value="2" selected>Actual/360</option>
                        <option value="3">Actual/Actual</option>
                        <option value="4">30/365</option>
                        <option value="5">30/Actual</option>
                        <option value="6">Actual/365</option>
                    </select>
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">合同金额:</label>
                    <input id="org_par_bal"
                           name="org_par_bal"
                           type="text"
                           class="form-control"
                           placeholder="合同金额" style="width: 100%;height: 30px;line-height: 30px;">
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label" style="width: 100%;">利率调整方式:</label>
                    <div id="adjustable_type_cd" style="height: 30px; line-height: 30px; width: 100%;">
                        <label class="radio-inline">
                            <input type="radio" name="adjustable_type_cd"
                                   style="margin-top: 9px;"
                                   id="fixed_rate" value="0" checked> 固定利率
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="adjustable_type_cd"
                                   style="margin-top: 9px;"
                                   id="float_rate" value="250"> 浮动利率
                        </label>
                    </div>
                </div>
            </div>
            <br/>
            <br/>
            <div id="ftp-payment-area"
                 class="row"
                 style="margin:auto 0px;border-top: #cccccc solid 1px; padding: 15px 15px;
                     position: relative;border-radius: 5px;">
                <h4 style="position: absolute;
            margin-top: -30px;
            background-color:#f3f3f4;
            font-size: 14px;
            width: 80px;
            font-weight: 600;
            color: #901253;
            text-align: center;
            margin-left: 15px;">支付信息</h4>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">支付方式:</label>
                    <select placeholder="支付方式"
                            name="amart_type_cd"
                            id="amart_type_cd"
                            class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
                        <option value="300">整存零取</option>
                        <option value="400">零存整取</option>
                        <option value="500">一次还本,分期付息</option>
                        <option value="600">到期还本付息</option>
                        <option value="700">等额本息</option>
                        <option value="800">等额本金</option>
                        <option value="900">不规则还款</option>
                    </select>
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">下次支付日:</label>
                    <input id="next_payment_date"
                           name="next_payment_date"
                           type="text"
                           class="form-control"
                           placeholder="下次支付日" style="width: 100%;height: 30px;line-height: 30px;">
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">支付频率:</label>
                    <input id="pmt_freq"
                           name="pmt_freq"
                           type="text"
                           class="form-control"
                           placeholder="支付频率" style="width: 100%;height: 30px;line-height: 30px;">
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">支付频率单位:</label>
                    <select placeholder="支付方式"
                            name="pmt_freq_mult"
                            id="pmt_freq_mult"
                            class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
                        <option value="D">天</option>
                        <option value="M" selected>月</option>
                        <option value="Y">年</option>
                    </select>
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">支付金额:</label>
                    <input id="org_payment_amt"
                           name="org_payment_amt"
                           type="text"
                           class="form-control"
                           placeholder="支付频率" style="width: 100%;height: 30px;line-height: 30px;">
                </div>
            </div>
            <br/>
            <br/>
            <div id="ftp-reprice-area"
                 class="row"
                 style="margin:auto 0px;border-top: #cccccc solid 1px; padding: 15px 15px;
                  position: relative;border-radius: 5px;">
                <h4 style="position: absolute;
        margin-top: -30px;
        background-color:#f3f3f4;
        font-size: 14px;
        width: 80px;
        font-weight: 600;
        color: #901253;
        text-align: center;
        margin-left: 15px;">重定价信息</h4>
                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">上次重定价日:</label>
                    <input id="last_reprice_date"
                           name="last_reprice_date"
                           type="text"
                           class="form-control"
                           placeholder="上次重定价日" style="width: 100%;height: 30px;line-height: 30px;">
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">下次重定价日:</label>
                    <input id="next_reprice_date"
                           name="next_reprice_date"
                           type="text"
                           class="form-control"
                           placeholder="上次重定价日" style="width: 100%;height: 30px;line-height: 30px;">
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">上次重定价余额:</label>
                    <input id="lrd_balance"
                           name="lrd_balance"
                           type="text"
                           class="form-control"
                           placeholder="上次重定价日" style="width: 100%;height: 30px;line-height: 30px;">
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">重定价频率:</label>
                    <input id="reprice_freq"
                           name="reprice_freq"
                           type="text"
                           class="form-control"
                           placeholder="上次重定价日" style="width: 100%;height: 30px;line-height: 30px;">
                </div>

                <div class="col-sm-12 col-md-6 col-lg-3" style="margin-top: 8px;">
                    <label class="ibox-label">重定价频率单位:</label>
                    <select placeholder="支付方式"
                            name="reprice_freq_mult"
                            id="reprice_freq_mult"
                            class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
                        <option value="D">天</option>
                        <option value="M">月</option>
                        <option value="Y" selected>年</option>
                    </select>
                </div>
                <input name="domain_id" style="display: none;"/>
            </div>
        </form>
    </div>
    <div id="ftpResult" class="col-sm-12 col-md-12 col-lg-12"
         style="display: none;margin-top:30px;">
        <div class="form-inline" style="margin:auto 15px;">
            <div id="R_ftp-payment-area"
                 class="row"
                 style="margin:auto 0px;border-top: #cccccc solid 1px; padding: 15px 15px;
                  position: relative;border-radius: 5px;">
                <h4 style="position: absolute;
        margin-top: -30px;
        background-color:#f3f3f4;
        font-size: 14px;
        width: 80px;
        font-weight: 600;
        color: #901253;
        text-align: center;
        margin-left: 15px;">调节项价格</h4>
                <div class="form-group col-lg-4" style="margin-top: 8px;">
                    <label class="ibox-label">期限流动性:</label>
                    <span  id="R_adj_601"
                           class="form-control ibox"
                           style="margin: auto 5px !important;"></span>
                </div>
                <div class="form-group col-lg-4" style="margin-top: 8px;">
                    <label class="ibox-label">准备金:</label>
                    <span  id="R_adj_604"
                           class="form-control ibox"
                           style="margin: auto 5px !important;"></span>
                </div>
            </div>
            <br/>
            <div class="row" style="margin:auto 0px;border-top: #cccccc solid 1px; padding: 15px 15px;
                  position: relative;border-radius: 5px;">
                <h4 style="position: absolute;
        margin-top: -30px;
        background-color:#f3f3f4;
        font-size: 14px;
        width: 80px;
        font-weight: 600;
        color: #901253;
        text-align: center;
        margin-left: 15px;">FTP价格</h4>
                <div class="form-group col-lg-4" style="margin-top: 8px;">
                    <label class="ibox-label">基础FTP价格:</label>
                    <span  id="R_ftp_rate"
                           class="form-control ibox"
                           style="margin: auto 5px !important;"></span>
                </div>
                <div class="form-group col-lg-4" style="margin-top: 8px;">
                    <label class="ibox-label">调节前FTP价格:</label>
                    <span  id="R_ftp_rate_innerAdjust"
                           class="form-control ibox"
                           style="margin: auto 5px !important;"></span>
                </div>
                <div class="form-group col-lg-4" style="margin-top: 8px;">
                    <label class="ibox-label">调节后FTP价格:</label>
                    <span  id="R_ftp_rate_outerAdjust"
                           class="form-control ibox"
                           style="margin: auto 5px !important;"></span>
                </div>
            </div>
            <br/>
            <div class="row"
                 style="margin:auto 0px;border-top: #cccccc solid 1px; padding: 15px 15px;
                  position: relative;border-radius: 5px;">
                <h4 style="position: absolute;
        margin-top: -30px;
        background-color:#f3f3f4;
        font-size: 14px;
        width: 80px;
        font-weight: 600;
        color: #901253;
        text-align: center;
        margin-left: 15px;">相关指标</h4>
                <div style="margin-top: 8px;color: #a2a2a2; font-size: 12px; font-weight: 600;" class="col-sm-12 col-md-12 col-lg-12">资产业务利差：</div>
                <div class="form-group col-lg-4" style="margin-top: 8px;">
                    <label class="ibox-label">原始FTP利差:</label>
                    <span  id="R_ftp_interest_margin"
                           class="form-control ibox"
                           style="margin: auto 5px !important;"></span>
                </div>
                <div class="form-group col-lg-4" style="margin-top: 8px;">
                    <label class="ibox-label">调节前FTP利差:</label>
                    <span  id="R_ftp_interest_margin_innerAdjust"
                           class="form-control ibox"
                           style="margin: auto 5px !important;"></span>
                </div>
                <div class="form-group col-lg-4" style="margin-top: 8px;">
                    <label class="ibox-label">调节后FTP利差:</label>
                    <span  id="R_ftp_interest_margin_outerAdjust"
                           class="form-control ibox"
                           style="margin: auto 5px !important;"></span>
                </div>
                <div style="margin-top: 8px;color: #a2a2a2; font-size: 12px; font-weight: 600;" class="col-sm-12 col-md-12 col-lg-12">负债业务利差：</div>
                <div class="form-group col-lg-4" style="margin-top: 8px;">
                    <label class="ibox-label">原始FTP利差:</label>
                    <span  id="R_ftp_interest_margin-l"
                           class="form-control ibox"
                           style="margin: auto 5px !important;"></span>
                </div>
                <div class="form-group col-lg-4" style="margin-top: 8px;">
                    <label class="ibox-label">调节前FTP利差:</label>
                    <span  id="R_ftp_interest_margin_innerAdjust-l"
                           class="form-control ibox"
                           style="margin: auto 5px !important;"></span>
                </div>
                <div class="form-group col-lg-4" style="margin-top: 8px;">
                    <label class="ibox-label">调节后FTP利差:</label>
                    <span  id="R_ftp_interest_margin_outerAdjust-l"
                           class="form-control ibox"
                           style="margin: auto 5px !important;"></span>
                </div>
            </div>
            <br/>
            <button onclick="backftpTrialCalc()" type="button" class="btn btn-success pull-right">返回</button>
        </div>
    </div>
</div>


<script>

    // 返回试算页面
    function backftpTrialCalc(){
        $("#ftpInterface").show()
        $("#ftpResult").hide()
    }

    // 转换浮点数
    function roundNumber(number,decimals) {
        var newString;// The new rounded number
        decimals = Number(decimals);
        if (decimals < 1) {
            newString = (Math.round(number)).toString();
            return newString
        } else {
            var value = number.toString()
            var i = value.indexOf(".")
            console.log("index is "+i)
            var preci = value.length - i;
            if (parseInt(preci) > parseInt(decimals)){
                var idx = parseInt(i)+parseInt(decimals)+1
                console.log("idx is :",idx)
                return value.substring(0,idx)
            }else{
                return value
            }
        }
    }

    // 提交试算
    function ftpTrialCalc(){
        $.HAjaxRequest({
            type:"Post",
            url:'/v1/ftp/single/calc/post',
            cache:false,
            data:$("#ftpAcctInfo").serialize(),
            async:false,
            dataType:"json",
            success: function(data){
                $("#ftpInterface").hide();
                $("#ftpResult").show();
                $(data).each(function(index,element) {
                    $("#R_ftp_rate").html(parseFloat(element.FtpRate));
                    var innerFtpAdjust = 0;
                    var outerFtpAdjust = 0;

                    for (var x in element.Adjust){
                        if (x=="601"){
                            if (element.Adjust[x]==""){
                                $("#R_adj_601").html(0)
                            }else{
                                innerFtpAdjust += parseFloat(element.Adjust[x])
                                $("#R_adj_601").html(element.Adjust[x])
                            }
                        }
                        if (x == "604"){
                            if (element.Adjust[x]==""){
                                $("#R_adj_604").html(0)
                            }else{
                                innerFtpAdjust += parseFloat(element.Adjust[x])
                                $("#R_adj_604").html(element.Adjust[x])
                            }
                        }
                    }

                    $("#R_ftp_rate_innerAdjust").html(roundNumber((parseFloat(element.FtpRate)+innerFtpAdjust),6))
                    $("#R_ftp_rate_outerAdjust").html(roundNumber((parseFloat(element.FtpRate)+innerFtpAdjust+outerFtpAdjust),6))

                    var ftpInterestMargin = 0

                    $("#R_ftp_interest_margin").html(roundNumber((-parseFloat(element.FtpRate) + parseFloat(element.Cur_net_rate)),6))
                    $("#R_ftp_interest_margin_innerAdjust").html(roundNumber((-(parseFloat(element.FtpRate)+innerFtpAdjust) + parseFloat(element.Cur_net_rate)),6))
                    $("#R_ftp_interest_margin_outerAdjust").html(roundNumber((-(parseFloat(element.FtpRate)+innerFtpAdjust+outerFtpAdjust) + parseFloat(element.Cur_net_rate)),6))

                    $("#R_ftp_interest_margin-l").html(roundNumber((parseFloat(element.FtpRate) - parseFloat(element.Cur_net_rate)),6))
                    $("#R_ftp_interest_margin_innerAdjust-l").html(roundNumber((parseFloat(element.FtpRate)+innerFtpAdjust - parseFloat(element.Cur_net_rate)),6))
                    $("#R_ftp_interest_margin_outerAdjust-l").html(roundNumber((parseFloat(element.FtpRate)+innerFtpAdjust+outerFtpAdjust - parseFloat(element.Cur_net_rate)),6))

                });
            }
        });
    }

    // 选项变更时响应状态
    var inputRespon = function(){

        var busizId = $("#busiz_id").val();
        if (busizId == null){
            return
        }

        $.HAjaxRequest({
            url: '/v1/ftp/rules/busiz_id/query',
            type: 'get',
            data: {busiz_id: busizId},
            success: function (data) {
                $.notifyClose();
                switch (data) {
                    case "101":
                        $("#ftp-payment-area").hide()
                        $("#ftp-reprice-area").hide()
                        $("#origination_date").val("").parent().show()
                        $("#maturity_date").val("").parent().hide()
                        $("#cur_net_rate").val("")
                        $("#accrual_basis_cd").val("2");
                        $("#cur_book_bal").val("")
                        $("#adjustable_type_cd").parent().hide()
                        $("#amart_type_cd").val("");
                        $("#next_payment_date").val("")
                        $("#pmt_freq").val("")
                        $("#pmt_freq_mult").val("M")
                        $("#last_reprice_date").val("")
                        $("#next_reprice_date").val("")
                        $("#lrd_balance").val("")
                        $("#reprice_freq").val("")
                        $("#reprice_freq_mult").val("Y")
                        break;
                    case "102":
                        $("#ftp-payment-area").hide()
                        $("#origination_date").parent().show()
                        $("#maturity_date").parent().show()
                        $("#cur_net_rate").parent().show()
                        $("#accrual_basis_cd").parent().show()
                        $("#cur_book_bal").parent().show()

                        $("#adjustable_type_cd").parent().show();
                        var adjid = $("#adjustable_type_cd").find("input:radio:checked").val()
                        if (adjid == "0") {
                            $("#ftp-reprice-area").hide()
                            $("#last_reprice_date").val("")
                            $("#next_reprice_date").val("")
                            $("#lrd_balance").val("")
                            $("#reprice_freq").val("")
                            $("#reprice_freq_mult").val("Y")
                        } else {
                            $("#ftp-reprice-area").show()
                            $("#last_reprice_date").val("").parent().show()
                            $("#next_reprice_date").val("").parent().show()
                            $("#lrd_balance").val("").parent().hide()
                            $("#reprice_freq").val("").parent().hide()
                            $("#reprice_freq_mult").val("Y").parent().hide()
                        }
                        break;
                    case "105":
                    case "103":
                        $("#ftp-payment-area").show()
                        $("#origination_date").parent().show()
                        $("#maturity_date").parent().show()

                        var adjid = $("#adjustable_type_cd").find("input:radio:checked").val()
                        if (adjid == "0") {
                            $("#ftp-reprice-area").hide()
                            $("#last_reprice_date").val("").parent().hide();
                            $("#next_reprice_date").val("").parent().hide();
                            $("#lrd_balance").val("").parent().hide();
                            $("#reprice_freq").val("").parent().hide();
                            $("#reprice_freq_mult").val("Y").parent().hide();
                        } else {
                            $("#ftp-reprice-area").show()
                            $("#last_reprice_date").val("").parent().show()
                            $("#next_reprice_date").val("").parent().show()
                            $("#lrd_balance").val("").parent().show()
                            $("#reprice_freq").val("").parent().show()
                            $("#reprice_freq_mult").val("Y").parent().show()
                        }
                        var amid = $("#amart_type_cd").val()

                        if (amid == "600") {
                            $("#ftp-reprice-area").hide()
                            //$("#adjustable_type_cd").parent().hide()
                            $("#adjustable_type_cd").find("input:radio:eq(0)").prop("checked", "true")
                            $("#adjustable_type_cd").parent().hide()
                            $("#next_payment_date").val("").parent().hide()
                            $("#pmt_freq").val("").parent().hide()
                            $("#pmt_freq_mult").val("M").parent().hide()
                            $("#org_payment_amt").val("").parent().hide()
                        } else if (amid == "900") {
                            $("#next_payment_date").val("").parent().hide()
                            $("#pmt_freq").val("").parent().hide()
                            $("#pmt_freq_mult").val("M").parent().hide()
                            $("#org_payment_amt").val("").parent().hide()
                        } else {
                            $("#next_payment_date").parent().show()
                            $("#adjustable_type_cd").parent().show()
                            $("#pmt_freq").parent().show()
                            $("#pmt_freq_mult").parent().show()
                            $("#org_payment_amt").val("").parent().show()
                        }
                        break;
                    case "104":
                        $("#ftp-payment-area").hide()
                        $("#ftp-reprice-area").hide()
                        $("#origination_date").val("").parent().show()
                        $("#maturity_date").val("").parent().hide()
                        $("#cur_net_rate").val("")
                        $("#accrual_basis_cd").val("2");
                        $("#cur_book_bal").val("")
                        $("#adjustable_type_cd").parent().hide();
                        $("#amart_type_cd").val("");
                        $("#next_payment_date").val("")
                        $("#pmt_freq").val("")
                        $("#pmt_freq_mult").val("M")
                        $("#last_reprice_date").val("")
                        $("#next_reprice_date").val("")
                        $("#lrd_balance").val("")
                        $("#reprice_freq").val("")
                        $("#reprice_freq_mult").val("Y")
                        break;
                    case "106":
                        $("#ftp-payment-area").hide()
                        $("#ftp-reprice-area").hide()
                        $("#origination_date").val("").parent().hide()
                        $("#maturity_date").val("").parent().hide()
                        $("#cur_net_rate").val("")
                        $("#accrual_basis_cd").val("2");
                        $("#cur_book_bal").val("")
                        $("#adjustable_type_cd").parent().hide();
                        $("#amart_type_cd").val("");
                        $("#next_payment_date").val("")
                        $("#pmt_freq").val("")
                        $("#pmt_freq_mult").val("M")
                        $("#last_reprice_date").val("")
                        $("#next_reprice_date").val("")
                        $("#lrd_balance").val("")
                        $("#reprice_freq").val("")
                        $("#reprice_freq_mult").val("Y")
                        break;
                }
            },
            error:function () {
                $.notifyClose();
                $.Notify({
                    message:"请选择业务分类",
                    type:"info"
                })
            }
        });
    };

    $(document).ready(function(){

        Hutils.InitDomain({
            id:"#h-ftp-single-calculate-domain",
            height:"24px",
            width:"180px",
            onclick:function () {
                var domainId = $("#h-ftp-single-calculate-domain").val();
                $("#ftpAcctInfo").find("input[name='domain_id']").val(domainId);
                inputRespon();

                $.get("/v1/ftp/rules/manage/get",{
                    domain_id:domainId
                },function(data){
                    var dat = JSON.parse(data);
                    var arr = [];
                    $(dat).each(function(index,element){
                        var ijs = {};
                        ijs.id = element.busiz_id;
                        ijs.text = element.busiz_desc;
                        ijs.upId = element.busiz_up_id;
                        if (element.busiz_type == "0") {
                            ijs.attr = "1";
                        } else {
                            ijs.attr = "0"
                        }
                        arr.push(ijs)
                    });

                    $("#busiz_id").Hselect({
                        data:arr,
                        height:"30px",
                        nodeSelect:false,
                        onclick:function(){
                            inputRespon();
                        }
                    });
                });
            },
            callback:function (domainId) {
                $("#ftpAcctInfo").find("input[name='domain_id']").val(domainId);
                inputRespon();
                $.get("/v1/ftp/rules/manage/get",{
                    domain_id:domainId
                },function(data){
                    var dat = JSON.parse(data);
                    var arr = [];
                    $(dat).each(function(index,element){
                        var ijs = {};
                        ijs.id = element.busiz_id;
                        ijs.text = element.busiz_desc;
                        ijs.upId = element.busiz_up_id;
                        if (element.busiz_type == "0") {
                            ijs.attr = "1";
                        } else {
                            ijs.attr = "0"
                        }
                        arr.push(ijs)
                    });

                    $("#busiz_id").Hselect({
                        data:arr,
                        height:"30px",
                        nodeSelect:false,
                        onclick:function(){
                            inputRespon();
                        }
                    });
                });
            },
        });

        $("#accrual_basis_cd").Hselect({
            height:"30px",
        });

        $("#reprice_freq_mult").Hselect({
            height:"30px",
        });

        $("#amart_type_cd").Hselect({
            height:"30px",
            onclick:function(){
                inputRespon()
            }
        });

        $("#pmt_freq_mult").Hselect({
            height:"30px",
        });
    });


    $("#adjustable_type_cd").find("input:radio").change(function(){
        inputRespon()
    });

    laydate({
        elem:"#origination_date",
        format: 'YYYY-MM-DD',
        max: '2099-06-16', //最大日期
        istime: true,
        istoday: false,
    });

    laydate({
        elem:"#maturity_date",
        format: 'YYYY-MM-DD',
        max: '2099-06-16', //最大日期
        istime: true,
        istoday: false,
    });

    laydate({
        elem:"#next_payment_date",
        format: 'YYYY-MM-DD',
        max: '2099-06-16', //最大日期
        istime: true,
        istoday: false,
    });

    laydate({
        elem:"#last_reprice_date",
        format: 'YYYY-MM-DD',
        max: '2099-06-16', //最大日期
        istime: true,
        istoday: false,
    });


    laydate({
        elem:"#next_reprice_date",
        format: 'YYYY-MM-DD',
        max: '2099-06-16', //最大日期
        istime: true,
        istoday: false,
    });

</script>