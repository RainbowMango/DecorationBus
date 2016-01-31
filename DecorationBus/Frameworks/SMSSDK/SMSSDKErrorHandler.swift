//
//  SMSSDKErrorHandler.swift
//  DecorationBus
//
//  Created by ruby on 16/1/16.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation

let smssdkErrorMap: Dictionary<Int, String> = [
    251: "访问过于频繁",
    252: "发送短信条数超过限制",
    400: "无效请求",
    408: "无效参数",
    456: "手机号码为空",
    457: "手机号码格式错误",
    458: "手机号码在黑名单中",
    459: "无appKey的控制数据",
    460: "无权限发送短信",
    461: "不支持该地区发送短信",
    462: "每分钟发送次数超限",
    463: "手机号码每天发送次数超限",
    464: "每台手机每天发送次数超限",
    465: "号码在App中每天发送短信次数超限",
    466: "验证码为空",
    467: "校验验证码请求频繁",
    468: "验证码错误",
    470: "账号余额不足",
    472: "客户端请求发送短信验证过于频繁",
    475: "appkey的应用信息不存在",
    476: "当前appkey发送短信的数量超过限额",
    477: "当前手机号发送短信的数量超过当天限额",
    478: "当前手机号在当前应用内发送超过限额",
    500: "服务器内部错误"
]

let VERIFY_SMS_SUCCESS_TITLE = "验证成功"
let VERIFY_SMS_SUCCESS_MSG   = "验证码正确"
let VERIFY_SMS_FAILED_TITLE  = "验证失败"
let VERIFY_SMS_FAILED_MSG    = "验证码无效"


//TODO: 根据SMMSDK error code 返回用户提示信息

func getSMSErrorInfo(ecode: Int) -> String {
    for(code, info) in smssdkErrorMap {
        if(code == ecode) {
            return info
        }
    }
    
    return "未定义的异常:\(ecode)"
}