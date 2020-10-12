#!/usr/local env python3
# -*-coding: utf-8-*-

import smtplib
import time
from email.mime.text import MIMEText

# mail_settings
smtp_server = 'smtp.exmail.qq.com'
send_user = 'xxx'
user_pass = 'xxx'
receivers = ['xxx1', 'xxx2']
mail_time = time.strftime('%Y-%m-%d', time.localtime())

# mail_context
f = open("api_totel")
lines = f.read()
f.close()
message_txt = ''' \
Hi,xxx: 
统计如下
''' + lines + '''
\n\n this is automatic mail by ops...
'''

message = MIMEText(str(message_txt), 'plain', 'utf-8')
message['Subject'] = mail_time + '测试环境日志'
message['From'] = 'xxx'
message['To'] = receivers[0]+',' + receivers[1]


try:
    smtpObj = smtplib.SMTP_SSL(smtp_server)
    smtpObj.login(send_user, user_pass)
    smtpObj.sendmail(
        send_user, receivers, message.as_string())
    smtpObj.quit()
    print('success')
except smtplib.SMTPException as e:
    print('error', e)
