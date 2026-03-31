#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Windows Toast Notification Script
发送Windows桌面通知，无需第三方依赖
"""

import sys
import subprocess
import os


def send_notification(title, message, app_id="Python Notification"):
    """
    发送Windows桌面通知

    参数:
        title: 通知标题
        message: 通知内容
        app_id: 应用标识符（可选）
    """
    # 使用PowerShell发送通知（Windows 10/11原生支持）
    ps_script = f"""
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $template = @"
    <toast>
        <visual>
            <binding template="ToastText02">
                <text id="1">{title}</text>
                <text id="2">{message}</text>
            </binding>
        </visual>
    </toast>
"@

    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($template)
    $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("{app_id}").Show($toast)
    """

    try:
        subprocess.run(
            [
                "powershell",
                "-NoProfile",
                "-ExecutionPolicy",
                "Bypass",
                "-Command",
                ps_script,
            ],
            check=True,
            capture_output=True,
            text=True,
        )
        return True
    except subprocess.CalledProcessError as e:
        print(f"PowerShell错误: {e.stderr}", file=sys.stderr)
        return False
    except Exception as e:
        print(f"错误: {str(e)}", file=sys.stderr)
        return False


def main():
    """主函数：解析命令行参数并发送通知"""
    if len(sys.argv) < 3:
        print("用法: python notify.py <标题> <消息>")
        print('示例: python notify.py "提醒" "任务已完成！"')
        sys.exit(1)

    title = sys.argv[1]
    message = sys.argv[2]

    if send_notification(title, message):
        print("通知已发送")
    else:
        print("通知发送失败", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
